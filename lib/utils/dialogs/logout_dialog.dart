import 'package:flutter/material.dart';
import 'package:remind_me/utils/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionBuilder: () {
      return {'Cancel': false, 'Logout': true};
    },
  ).then((value) => value ?? false);
}
