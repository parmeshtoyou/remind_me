import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remind_me/business/note_list_model.dart';

class ReminderListWidget extends StatefulWidget {
  final Function(Note) onNoteClickListener;
  final NotesListModel notesListModel;

  const ReminderListWidget(
      {Key? key,
      required this.onNoteClickListener,
      required this.notesListModel})
      : super(key: key);

  @override
  State<ReminderListWidget> createState() => _ReminderListWidgetState();
}

class _ReminderListWidgetState extends State<ReminderListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  widget.onNoteClickListener(
                      widget.notesListModel.getNotes()[index]);
                },
                title:
                    Text(widget.notesListModel.getNotes()[index].productName),
                subtitle:
                    Text(widget.notesListModel.getNotes()[index].description),
                trailing: const Icon(CupertinoIcons.right_chevron),
              ),
            ),
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.black26),
        itemCount: widget.notesListModel.getNotes().length);
  }
}
