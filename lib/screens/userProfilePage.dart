import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/UserActions.dart';
import 'package:isms/userManagement/customUserProvider.dart';
import 'package:provider/provider.dart';

import '../UserManagement/userInfo.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  DocumentSnapshot? currentUserSnapshot;
  String? userRole;
  final List<UserActions> userActions = [
    UserActions(
        name: 'Dashboard', icon: Icons.dashboard, actionId: 'dashboard'),
    UserActions(name: 'Reports', icon: Icons.description, actionId: 'reports'),
    UserActions(
        name: 'User Management', icon: Icons.group, actionId: 'user_mgmt'),
    UserActions(
        name: 'Course Management', icon: Icons.school, actionId: 'crs_mgmt'),
    UserActions(name: 'Draft Courses', icon: Icons.edit, actionId: 'drf_crs'),
    UserActions(name: 'Exams', icon: Icons.assignment, actionId: 'exms'),
    UserActions(name: 'Logout', icon: Icons.exit_to_app, actionId: 'logout'),
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
    CustomUserProvider();
  }

  Widget build(BuildContext context) {
    CustomUserProvider customUserProvider =
        Provider.of<CustomUserProvider>(context);
    print('adminConsoleProvider: $customUserProvider');

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        children: [
          Expanded(child: UserProfileWidget()),
          Text('Courses Enrolled:'),
        ],
      ),
    );
  }
}
