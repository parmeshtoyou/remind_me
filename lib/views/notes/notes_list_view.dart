import 'package:flutter/material.dart';
import 'package:remind_me/services/crud/notes_service.dart';
import 'package:remind_me/utils/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notesList;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notesList,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        final note = notesList[index];
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if(shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
