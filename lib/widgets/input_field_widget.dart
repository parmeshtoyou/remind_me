import 'package:flutter/material.dart';
import 'package:remind_me/resource/strings.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String) onTextChange;

  const InputField(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.onTextChange})
      : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String enteredText = Strings.emptyString;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            autofocus: true,
            controller: widget.controller,
            onChanged: (newText) {
              widget.onTextChange(newText);
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              counter: Text("count:${widget.controller.text.length}"),
            ),
            onSubmitted: (text) async {
              setState(() {
                enteredText = text;
              });
            },
          )
        ],
      ),
    );
  }
}
