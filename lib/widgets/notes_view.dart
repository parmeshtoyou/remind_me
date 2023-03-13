import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remind_me/main.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            devtools.log(value.name);
            switch(value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                if(shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/login", (route) => false);
                }
                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(
                  value: MenuAction.logout, child: Text('Logout'))
            ];
          })
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: const Text('Hello world'),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
