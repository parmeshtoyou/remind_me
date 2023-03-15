import 'package:flutter/material.dart';
import 'package:remind_me/business/note_list_model.dart';
import 'package:remind_me/pages/home_page.dart';
import 'package:remind_me/pages/login_view.dart';
import 'package:remind_me/pages/register_view.dart';
import 'package:remind_me/pages/verify_email_view.dart';
import 'package:remind_me/resource/strings.dart';
import 'package:remind_me/routes.dart';
import 'package:remind_me/widgets/notes_view.dart';

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
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView()
      },
    );
  }
}
