import 'package:flutter/material.dart';
import 'package:remind_me/services/auth/auth_service.dart';
import 'package:remind_me/services/crud/notes_service.dart';
import 'package:remind_me/utils/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();
    if(widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    _note =  await _notesService.createNote(owner: owner);
    return Future.value(_note);
  }

  // void _deleteNoteIfTextIsEmpty() {
  //   final note = _note;
  //   if (_textController.text.isNotEmpty && note != null) {
  //     _notesService.deleteNote(id: note.id);
  //   }
  // }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    print('save note');
    if (note != null && text.isNotEmpty) {
      print('save note:$text');
      await _notesService.updateNote(note: note, text: text);
      var savedNote = _notesService.getNote(noteId: note.id);
      savedNote.then((value) => print('after save:$value'));
    }
  }

  @override
  void dispose() {
    _saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              if (snapshot.hasError) {
                return Column(
                  children: [
                    TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Start typing your note...'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Save'),
                    )
                  ],
                );
              }
              _setupTextControllerListener();
              return Column(
                children: [
                  TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Start typing your note...'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _saveNoteIfTextIsNotEmpty();
                    },
                    child: const Text('Save'),
                  )
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
