import 'package:flutter/material.dart';

import '../../adminManagement/adminConsoleProvider.dart';
import 'adminActionsDropdownModules/courseManagementDrowpdown.dart';

class AdminActionDropdown extends StatefulWidget {
  AdminActionDropdown({
    required this.adminConsoleProvider,
    required this.actionId,
  });

  final AdminConsoleProvider adminConsoleProvider;
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
      return FutureBuilder<List<dynamic>>(
          future: widget.adminConsoleProvider.getAllUsersList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title:
                        Text('${index + 1}: ${snapshot.data![index].username}'),
                  );
                },
              );
            } else {
              return Text('No data');
            }
          });
    } else {
      return Text('No data to show!');
    }
  }
}
