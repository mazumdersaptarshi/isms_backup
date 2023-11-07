// ignore_for_file: unused_local_variable, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../adminManagement/adminProvider.dart';
import '../../models/adminConsoleModels/adminConsoleActions.dart';
import 'adminActionDropdown.dart';

class AdminActionsWidget extends StatelessWidget {
  const AdminActionsWidget({super.key, 
    required this.action,
    required this.adminConsoleProvider,
  });

  final AdminActions action;
  final AdminProvider adminConsoleProvider;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(action.icon),
      title: Text("${action.name}"),
      onExpansionChanged: (expanded) async {
        if (expanded) {
          AdminProvider adminProvider =
              Provider.of<AdminProvider>(context, listen: false);
          // await adminProvider.allCoursesDataFetcher();
          // await adminProvider.allUsersDataFetcher();
        }
      },
      children: [
        AdminActionDropdown(
          adminProvider: adminConsoleProvider,
          actionId: action.actionId!,
        )
      ],
    );
  }
}
