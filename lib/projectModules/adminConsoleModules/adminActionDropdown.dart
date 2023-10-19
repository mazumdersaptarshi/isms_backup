import 'package:flutter/material.dart';

import '../../adminManagement/adminConsoleProvider.dart';
import 'adminActionsDropdownModules/courseManagementDrowpdown.dart';
import 'adminActionsDropdownModules/userManagementDropdown.dart';

class AdminActionDropdown extends StatefulWidget {
  AdminActionDropdown({
    required this.adminConsoleProvider,
    required this.actionId,
  });

  final AdminProvider adminConsoleProvider;
  final String actionId;

  @override
  State<AdminActionDropdown> createState() => _AdminActionDropdownState();
}

class _AdminActionDropdownState extends State<AdminActionDropdown> {
  @override
  Widget build(BuildContext context) {
    if (widget.actionId == 'crs_mgmt') {
      return CourseManagementDrowpdown(
          adminConsoleProvider: widget.adminConsoleProvider);
    } else if (widget.actionId == 'user_mgmt') {
      return UsermanagementDropdown(
          adminConsoleProvider: widget.adminConsoleProvider);
    } else {
      return Text('No data to show!');
    }
  }
}
