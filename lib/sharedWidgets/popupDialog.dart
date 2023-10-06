import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  PopupDialog({
    super.key,
    this.onPressedOK,
    this.onPressedAction,
    this.title,
    this.description,
    this.actionText,
  });
  Function? onPressedOK;
  Function? onPressedAction;
  String? actionText;
  String? title;
  String? description;

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
            this.onPressedOK!();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
