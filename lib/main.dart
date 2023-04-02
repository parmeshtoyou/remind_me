import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_me/business/note_list_model.dart';
import 'package:remind_me/pages/home_page.dart';
import 'package:remind_me/resource/strings.dart';
import 'package:remind_me/routes.dart';
import 'package:remind_me/services/auth/bloc/auth_bloc.dart';
import 'package:remind_me/services/auth/firebase_auth_provider.dart';
import 'package:remind_me/views/notes/create_update_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NotesListModel notesListModel = NotesListModel();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey.shade300),
      home: BlocProvider(
        create: (BuildContext context) {
          return AuthBloc(FirebaseAuthProvider());
        },
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
      },
    );
  }
}
