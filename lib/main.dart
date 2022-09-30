import 'package:flutter/material.dart';
import 'package:remind_me/business/NoteListModel.dart';
import 'package:remind_me/pages/home_page.dart';
import 'package:remind_me/resource/strings.dart';

void main() {
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
      home: HomePage(
        listModel: notesListModel,
      ),
    );
  }
}
