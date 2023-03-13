import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:remind_me/firebase_options.dart';
import 'package:remind_me/pages/login_view.dart';
import 'package:remind_me/pages/verify_email_view.dart';
import 'package:remind_me/widgets/notes_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if(user.emailVerified) {
                return const NotesView();
              } else {
                return const LoginView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

/**
 * body: ReminderListWidget(
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
 */
