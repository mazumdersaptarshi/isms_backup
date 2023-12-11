// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({
    super.key,
    this.onPressedOK,
    this.onPressedAction,
    this.title,
    this.description,
    this.actionText,
  });
  final Function? onPressedOK;
  final Function? onPressedAction;
  final String? actionText;
  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Item does not exist'),
      content: Text(description ?? 'Please check if item exists'),
      actions: <Widget>[
        if (onPressedAction != null)
          TextButton(
            onPressed: () {
              onPressedAction!();
            },
            child: Text(actionText != null ? actionText! : "Take action"),
          ),
        TextButton(
          onPressed: () {
            onPressedOK!();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
