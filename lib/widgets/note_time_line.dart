import 'package:flutter/material.dart';

import 'note_time_line_item_widget.dart';

class NoteTimeLineWidget extends StatelessWidget {
  const NoteTimeLineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Reminder Timeline"),
            Divider(
              height: 1,
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            NoteTimeLineItemWidget()
          ],
        ),
      ),
    );
  }
}


