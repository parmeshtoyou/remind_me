import 'package:flutter/material.dart';
import 'package:remind_me/business/note_list_model.dart';
import 'package:remind_me/core/dimens.dart';
import 'package:remind_me/pages/note_add_page.dart';
import 'package:remind_me/pages/note_detail_page.dart';
import 'package:remind_me/resource/strings.dart';
import 'package:remind_me/widgets/reminder_list_widget.dart';

class HomePage extends StatefulWidget {
  final NotesListModel listModel;

  const HomePage({Key? key, required this.listModel}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
      ),
      body: ReminderListWidget(
        onNoteClickListener: (Note note) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailPage(
                note: note,
              ),
            ),
          );
        },
        notesListModel: widget.listModel,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(
                addNoteCallback: (Note newNote) {
                  setState(() {
                    widget.listModel.saveNote(newNote);
                  });
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        child: Container(
          height: Dimens.dimen_50,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
