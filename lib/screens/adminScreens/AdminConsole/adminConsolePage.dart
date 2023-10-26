import 'package:flutter/material.dart';
import 'package:isms/projectModules/adminConsoleModules/adminProfileHeaderWidget.dart';
import 'package:provider/provider.dart';

import '../../../adminManagement/adminProvider.dart';
import '../../../models/adminConsoleModels/adminConsoleActions.dart';
import '../../../projectModules/adminConsoleModules/adminActionsWidget.dart';
import '../../../userManagement/userDataGetterMaster.dart';

class AdminConsolePage extends StatelessWidget {
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  final List<AdminActions> adminActions = [
    AdminActions(
        name: 'User Management', icon: Icons.group, actionId: 'user_mgmt'),
    AdminActions(
        name: 'Course Management', icon: Icons.school, actionId: 'crs_mgmt'),
    AdminActions(name: 'Instructions', icon: Icons.book, actionId: 'instr'),
    AdminActions(name: 'Logout', icon: Icons.exit_to_app, actionId: 'logout'),
    AdminActions(
        name: 'Download Data', icon: Icons.download, actionId: 'dwnld'),
  ];

  @override
  Widget build(BuildContext context) {
    AdminProvider adminConsoleProvider = Provider.of<AdminProvider>(context);
    print('adminConsoleProvider: $adminConsoleProvider');

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120.0,
          flexibleSpace: FlexibleSpaceBar(background: AdminInfoWidget()),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final action = adminActions[index];

              return AdminActionsWidget(
                  action: action, adminConsoleProvider: adminConsoleProvider);
            },

            childCount: adminActions.length, // Change this count as needed
          ),
        ),
      ],
    ));
  }
}
