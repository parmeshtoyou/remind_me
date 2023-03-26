import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:remind_me/enums/menu_action.dart';
import 'package:remind_me/routes.dart';
import 'package:remind_me/services/auth/auth_service.dart';
import 'package:remind_me/services/crud/notes_service.dart';
import 'package:remind_me/utils/dialogs/logout_dialog.dart';
import 'package:remind_me/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  /// we will reach to this page when we will have email associated to an user,
  /// force unwrap will not create any issue here
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    print('userEmail:$userEmail');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            devtools.log(value.name);
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }
                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: MenuAction.logout,
                child: Text('Logout'),
              )
            ];
          })
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      print("snapshot:$snapshot");
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DatabaseNote>;
                            return NotesListView(
                              notesList: allNotes,
                              onDeleteNote: (note) async {
                                await _notesService.deleteNote(id: note.id);
                              },
                              onTap: (DatabaseNote note) {
                                Navigator.of(context).pushNamed(
                                  createOrUpdateNoteRoute,
                                  arguments: note,
                                );
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
