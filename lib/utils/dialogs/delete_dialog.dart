import 'package:flutter/cupertino.dart';
import 'package:remind_me/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionBuilder: () {
      return {'Cancel': false, 'Yes': true};
    },
  ).then((value) => value ?? false);
}
