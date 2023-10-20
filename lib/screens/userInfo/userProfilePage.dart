import 'package:flutter/material.dart';
import 'package:isms/models/UserActions.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';
import 'package:isms/userManagement/userprofileHeaderWidget.dart';
import 'package:provider/provider.dart';

import '../../userManagement/userDataGetterMaster.dart';

List allEnrolledCourses = [];

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool hasCheckedForChangedDependencies = false;
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
  void initState() {
    super.initState();
    List allEnrolledCourses = [];
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasCheckedForChangedDependencies) {
      LoggedInUserProvider loggedInUserProvider =
          Provider.of<LoggedInUserProvider>(context, listen: true);
      if (mounted) {
        print(
            " I AM ${loggedInUserProvider.loggedInUser!.email} ,, ${loggedInUserProvider.isUserInfoUpdated}");
        await loggedInUserProvider.fetchAllCoursesUser();
        setState(() {
          allEnrolledCourses = loggedInUserProvider.allEnrolledCoursesGlobal;
          print("PRINTTTT ${loggedInUserProvider.allEnrolledCoursesGlobal}");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
  UserActionsDropdown({super.key, required this.actionId});
  String actionId;
  @override
  Widget build(BuildContext context) {
    if (actionId == 'crs_enrl') {
      print('Hre');

      return UserEnrolledCoursesDropdown();
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          itemCount: allEnrolledCourses.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            print('SnapshotData: ');
            return Text('${allEnrolledCourses![index]['course_name']}');
          },
        ),
      ],
    );
  }
}
