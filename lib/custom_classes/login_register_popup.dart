// Displays popup notification if the user enters incorrect login information.
import 'package:flutter/material.dart';

class LoginRegisterPopup {
  static Future<String?> showPopup(
      BuildContext context, String popupTitle, String popupContent) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(popupTitle),
                content: Text(popupContent),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ]));
  }
}
