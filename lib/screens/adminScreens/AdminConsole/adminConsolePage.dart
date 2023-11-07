import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';

import '../../../adminManagement/adminProvider.dart';
import '../../../models/adminConsoleModels/adminConsoleActions.dart';
import '../../../projectModules/adminConsoleModules/adminProfileHeaderWidget.dart';
import '../../../projectModules/adminConsoleModules/adminActionsWidget.dart';

class AdminConsolePage extends StatelessWidget {
  final List<AdminActions> adminActions = [
    AdminActions(
        name: 'User Management', icon: Icons.group, actionId: 'user_mgmt'),
    AdminActions(
        name: 'Course Management', icon: Icons.school, actionId: 'crs_mgmt'),
    AdminActions(name: 'Instructions', icon: Icons.book, actionId: 'instr'),
    AdminActions(
        name: 'Download Data', icon: Icons.download, actionId: 'dwnld'),
  ];

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    AdminProvider adminConsoleProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
      appBar: CustomAppBar(loggedInState: loggedInState),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurpleAccent.shade100,
            expandedHeight: 220.0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(background: AdminInfoWidget()),
          ),
          SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(adminActions.length, (index) {
                  final action = adminActions[index];
                  return Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width > 500
                          ? MediaQuery.of(context).size.width * 0.5
                          : MediaQuery.of(context).size.width,
                    ),
                    child: AdminActionsWidget(
                      action: action,
                      adminConsoleProvider: adminConsoleProvider,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
