import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:remind_me/services/crud/crud_constants.dart';
import 'package:remind_me/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class NotesService {
  Database? _db;

  List<DatabaseNote> _notes = [];
  static final NotesService _instance = NotesService._internal();

  NotesService._internal() {
    _notesStreamController =
        StreamController<List<DatabaseNote>>.broadcast(onListen: () {
      _notesStreamController.sink.add(_notes);
    });
  }

  factory NotesService() => _instance;

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    // make sure note exists
    await getNote(id: note.id);

    //update db
    final updatesCount = await db
        .update(noteTable, {textColumn: text, isSyncedWithCloudColumn: 0});
    if (updatesCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((element) => element.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    }
    return notes.map(
      (note) => DatabaseNote.fromRow(note),
    );
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((element) => element.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((element) => element.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNote> createNote({
    required DatabaseUser owner,
    required String text,
  }) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    } else if (text.isEmpty) {
      throw NoteTextEmptyException();
    } else {
      //create the note
      final noteId = await db.insert(noteTable, {
        userIdColumn: owner.id,
        textColumn: text,
        isSyncedWithCloudColumn: 1
      });

      final note = DatabaseNote(
        id: noteId,
        userId: owner.id,
        text: text,
        isSyncedWithCloud: true,
      );
      if (text.isEmpty) {
        return note;
      }
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExistsException();
    } else {
      final userId = await db.insert(userTable, {emailColumn: email});
      return DatabaseUser(id: userId, email: email);
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> _ensureDBIsOpen() async {
    try {
      print('tag-param: _ensureDBIsOpen');
      await open();
    } on DatabaseAlreadyOpenException {
      // do nothing
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    } else {
      try {
        final documentPath = await getApplicationDocumentsDirectory();

        final dbPath = join(documentPath.path, dbName);

        _db = await openDatabase(dbPath);

        /// create the user table
        await _db!.execute(createUserTable);

        /// create the note table
        await _db?.execute(createNoteTable);
        await _cacheNotes(); //when opening db, pull all notes and cached them
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentsDirectoryException();
      } catch (e) {
        print('some generic error:${e}');
      }
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() {
    return 'DatabaseUser{id: $id, email: $email}';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() {
    return 'Note{id: $id, userId: $userId, text: $text, isSynced: $isSyncedWithCloud}';
  }

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
