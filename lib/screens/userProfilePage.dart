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
        name: 'Courses Enrolled', icon: Icons.school, actionId: 'crs_enrl'),
    UserActions(
        name: 'Courses Completed', icon: Icons.check, actionId: 'crs_compl'),
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
          Expanded(
              flex: 2,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final action = userActions[index];

                    return ExpansionTile(
                      leading: Icon(action.icon),
                      title: Text(action.name!),
                      children: [
                        UserActionsDropdown(
                          customUserProvider: customUserProvider,
                          actionId: action.actionId!,
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}

class UserActionsDropdown extends StatelessWidget {
  UserActionsDropdown(
      {super.key, required this.customUserProvider, required this.actionId});
  CustomUserProvider customUserProvider;
  String actionId;
  @override
  Widget build(BuildContext context) {
    if (actionId == 'crs_enrl') {
      print('Hre');

      return UserEnrolledCoursesDropdown(
          customUserProvider: customUserProvider);
    } else if (actionId == 'crs_compl') {
      return Column(
        children: [
          FutureBuilder<List<dynamic>>(
              future: customUserProvider.getAllCompletedCoursesList(),
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
                      print('SnapshotData: ${snapshot.data![index]}');
                      return Text('${snapshot.data![index]['course_name']}');
                    },
                  );
                } else {
                  return Text('No data');
                }
              })
        ],
      );
    } else {
      return Column(
        children: [
          Text('No data to show!'),
        ],
      );
    }
  }
}

class UserEnrolledCoursesDropdown extends StatelessWidget {
  const UserEnrolledCoursesDropdown({
    super.key,
    required this.customUserProvider,
  });

  final CustomUserProvider customUserProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<dynamic>>(
            future: customUserProvider.getAllEnrolledCoursesList(),
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
                    print('SnapshotData: ${snapshot.data![index]}');
                    return Text('${snapshot.data![index]['course_name']}');
                  },
                );
              } else {
                return Text('No data');
              }
            })
      ],
    );
  }
}
