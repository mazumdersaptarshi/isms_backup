import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/projectModules/adminConsoleModules/adminInfo.dart';

import 'package:provider/provider.dart';

import '../../UserManagement/userInfo.dart';
import '../../adminManagement/adminConsoleProvider.dart';

import '../../models/adminConsoleModels/adminConsoleActions.dart';
import '../../projectModules/adminConsoleModules/adminActionsWidget.dart';

class AdminConsoleHomePage extends StatefulWidget {
  const AdminConsoleHomePage({super.key});

  @override
  State<AdminConsoleHomePage> createState() => _AdminConsoleHomePageState();
}

class _AdminConsoleHomePageState extends State<AdminConsoleHomePage> {
  DocumentSnapshot? currentUserSnapshot;
  String? userRole;

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
    AdminActions(name: 'Logout', icon: Icons.exit_to_app, actionId: 'logout'),
  ];

  Future<void> _loadUserInformation() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot? userSnapshot = await getUserDetails(currentUser);
      if (userSnapshot != null) {
        setState(() {
          currentUserSnapshot = userSnapshot;
        });
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        userRole = userData?['role'];
      } else {
        print('User not found');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
    AdminConsoleProvider();
  }

  Widget build(BuildContext context) {
    AdminConsoleProvider adminConsoleProvider =
        Provider.of<AdminConsoleProvider>(context);
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
