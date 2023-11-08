// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/projectModules/adminConsoleModules/adminProfileHeaderWidget.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../adminManagement/adminProvider.dart';
import '../../../models/adminConsoleModels/adminConsoleActions.dart';
import '../../../projectModules/adminConsoleModules/adminActionsWidget.dart';

class AdminConsolePage extends StatelessWidget {
  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  final List<AdminActions> adminActions = [
    AdminActions(
        name: 'User Management', icon: Icons.group, actionId: 'user_mgmt'),
    AdminActions(
        name: 'Course Management', icon: Icons.school, actionId: 'crs_mgmt'),
    AdminActions(name: 'Instructions', icon: Icons.book, actionId: 'instr'),
    // AdminActions(name: 'Logout', icon: Icons.exit_to_app, actionId: 'logout'),
    AdminActions(
        name: 'Download Data', icon: Icons.download, actionId: 'dwnld'),
  ];

  AdminConsolePage({super.key});

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    AdminProvider adminConsoleProvider = Provider.of<AdminProvider>(context);
    debugPrint('adminConsoleProvider: $adminConsoleProvider');

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          expandedHeight: 220.0,
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
