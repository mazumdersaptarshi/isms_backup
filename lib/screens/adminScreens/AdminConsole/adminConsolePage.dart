import 'package:flutter/material.dart';
import 'package:isms/projectModules/adminConsoleModules/adminProfileHeaderWidget.dart';
import 'package:provider/provider.dart';

import '../../../adminManagement/adminProvider.dart';
import '../../../models/adminConsoleModels/adminConsoleActions.dart';
import '../../../projectModules/adminConsoleModules/adminActionsWidget.dart';
import '../../../userManagement/userDataGetterMaster.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/screens/login/loginScreen.dart';

class AdminConsolePage extends StatelessWidget {
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  final List<AdminActions> adminActions = [
    AdminActions(
        name: 'Dashboard', icon: Icons.dashboard, actionId: 'dashboard'),
    AdminActions(name: 'Reports', icon: Icons.description, actionId: 'reports'),
    AdminActions(
        name: 'User Management', icon: Icons.group, actionId: 'user_mgmt'),
    AdminActions(
        name: 'Course Management', icon: Icons.school, actionId: 'crs_mgmt'),
    AdminActions(name: 'Draft Courses', icon: Icons.edit, actionId: 'drf_crs'),
    AdminActions(name: 'Exams', icon: Icons.assignment, actionId: 'exms'),
    AdminActions(name: 'Instructions', icon: Icons.book, actionId: 'instr'),
    AdminActions(name: 'Logout', icon: Icons.exit_to_app, actionId: 'logout'),
    AdminActions(
        name: 'Download Data', icon: Icons.download, actionId: 'dwnld'),
  ];

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.user == null) {
      return LoginPage();
    }

    AdminProvider adminConsoleProvider = Provider.of<AdminProvider>(context);
    print('adminConsoleProvider: $adminConsoleProvider');

    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Console'),
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: AdminInfoWidget()),
            Expanded(
                flex: 2,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: adminActions.length,
                    itemBuilder: (context, index) {
                      final action = adminActions[index];

                      return AdminActionsWidget(
                          action: action,
                          adminConsoleProvider: adminConsoleProvider);
                    }))
          ],
        ));
  }
}
