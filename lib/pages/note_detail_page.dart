import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remind_me/business/NoteListModel.dart';
import 'package:remind_me/core/utils.dart';
import 'package:remind_me/resource/strings.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;

  const NoteDetailPage({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.detail),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.productName.toUpperCase(),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
            ),
            Text(widget.note.description),
            Text(
              "${Strings.purchasedOn} ${getFormattedDate(widget.note.purchasedOn)}",
              style: const TextStyle(color: Colors.blue),
            ),
            Text(
              "${Strings.expiringOn} ${getFormattedDate(widget.note.expiresOn)}",
              style: const TextStyle(color: Colors.red),
            ),
            SvgPicture.asset(
              "assets/icons/sample_svg.svg",
              height: 24.0,
              width: 24.0,
            )
          ],
        ),
      ),
    );
  }
}
