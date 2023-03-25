import 'package:flutter/material.dart';
import 'package:remind_me/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: text,
    content: text,
    optionBuilder: () => {'Ok': null},
  );
}
