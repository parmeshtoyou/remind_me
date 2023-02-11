import 'package:flutter/material.dart';
import 'package:remind_me/business/note_list_model.dart';
import 'package:remind_me/core/dimens.dart';
import 'package:remind_me/core/utils.dart';
import 'package:remind_me/resource/strings.dart';
import 'package:remind_me/widgets/input_field_widget.dart';


class AddNotePage extends StatefulWidget {
  final Function(Note newNote) addNoteCallback;

  const AddNotePage({Key? key, required this.addNoteCallback})
      : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  DateTime? _purchaseDate;

  DateTime? _expireDate;

  bool _isNameEmpty = false;
  bool _isDescriptionEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.newNote),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _validate() ? Colors.blue : Colors.grey,
        onPressed: _validate()
            ? () {
                Note newNote = Note(
                    noteId: 1,
                    productName: nameTextController.text,
                    description: descriptionTextController.text,
                    purchasedOn: _purchaseDate!,
                    expiresOn: _expireDate!);
                widget.addNoteCallback(newNote);
                Navigator.pop(context);
              }
            : null,
        child: const Icon(Icons.save),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(Dimens.dimen_16),
          child: Column(
            children: [
              InputField(
                hintText: Strings.productName,
                controller: nameTextController,
                onTextChange: (text) {
                  setState(() {
                    _isNameEmpty = text.isNotEmpty;
                  });
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              InputField(
                hintText: Strings.productDescription,
                controller: descriptionTextController,
                onTextChange: (text) {
                  setState(() {
                    _isDescriptionEmpty = text.isNotEmpty;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _purchaseDate ?? DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 20),
                        ).then((value) {
                          setState(() {
                            _purchaseDate = value;
                          });
                        });
                      },
                      child: const Text(Strings.purchaseDate),
                    ),
                  ),
                  const SizedBox(
                    width: Dimens.dimen_16,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(_purchaseDate != null
                        ? getFormattedDate(_purchaseDate!)
                        : Strings.emptyString),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _expireDate ?? DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 20),
                        ).then((value) {
                          setState(() {
                            _expireDate = value;
                          });
                        });
                      },
                      child: const Text(Strings.expireDate),
                    ),
                  ),
                  const SizedBox(
                    width: Dimens.dimen_16,
                  ),
                  Expanded(
                    child: Text(_expireDate != null
                        ? getFormattedDate(_expireDate!)
                        : Strings.emptyString),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController nameTextController = TextEditingController();

  TextEditingController descriptionTextController = TextEditingController();

  _validate() {
    return _purchaseDate != null &&
        _expireDate != null &&
        _isNameEmpty &&
        _isDescriptionEmpty;
  }
}
