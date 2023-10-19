import 'package:flutter/material.dart';

import '../../adminManagement/adminConsoleProvider.dart';
import '../../models/adminConsoleModels/adminConsoleActions.dart';
import 'adminActionDropdown.dart';

class AdminActionsWidget extends StatelessWidget {
  AdminActionsWidget({
    required this.action,
    required this.adminConsoleProvider,
  });

  final AdminActions action;
  final AdminProvider adminConsoleProvider;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(action.icon),
      title: Text(action.name!),
      children: [
        AdminActionDropdown(
          adminConsoleProvider: adminConsoleProvider,
          actionId: action.actionId! ?? 'n/a',
        )
      ],
    );
  }
}
