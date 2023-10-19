import 'package:flutter/material.dart';
import 'package:isms/models/UserActions.dart';
import 'package:isms/userManagement/customUserProvider.dart';
import 'package:isms/userManagement/userprofileHeaderWidget.dart';
import 'package:provider/provider.dart';

import '../../userManagement/userDataGetterMaster.dart';

class UserProfilePage extends StatelessWidget {
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

  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    CustomUserProvider customUserProvider =
        Provider.of<CustomUserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        children: [
          Expanded(child: UserProfileHeaderWidget()),
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
