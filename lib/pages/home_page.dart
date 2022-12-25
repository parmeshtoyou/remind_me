import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remind_me/core/dimens.dart';
import 'package:remind_me/pages/note_add_page.dart';
import 'package:remind_me/pages/note_detail_page.dart';
import 'package:remind_me/resource/strings.dart';
import 'package:remind_me/widgets/note_time_line.dart';
import 'package:remind_me/widgets/reminder_list_widget.dart';

import '../business/NoteListModel.dart';

class HomePage extends StatefulWidget {
  final NotesListModel listModel;

  const HomePage({Key? key, required this.listModel}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const methodChannel = MethodChannel('com.param.remindme/method');

  String _sensorAvailable = 'Unknown';

  Future<void> checkAvailability() async {
    try {

      var available = await methodChannel.invokeMethod('testMethod', <String, String> {
        "key" : "Hello From Flutter to Native Android"
      });
      print("available: $available");
      setState(() {
        _sensorAvailable = 'Sensor Available:$available';
      });
    } on PlatformException catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
      ),
      body: widget.listModel.getNotes().isEmpty
          ? SensorStatusWidget(
              isSensorAvailable: _sensorAvailable, callback: checkAvailability)
          : ReminderListWidget(
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

class SensorStatusWidget extends StatelessWidget {
  const SensorStatusWidget(
      {Key? key, required this.isSensorAvailable, required this.callback})
      : super(key: key);
  final String isSensorAvailable;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text(isSensorAvailable)),
        TextButton(
          onPressed: () {
            callback();
          },
          child: const Text("Check Sensor Availability"),
        )
      ],
    );
  }
}
