// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

class UserProfileHeaderWidget extends StatelessWidget {
  const UserProfileHeaderWidget({super.key});

  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
  // LoggedInState loggedInState;
  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loggedInState.currentUser?.photoURL != null)
            const Padding(
              padding: EdgeInsets.only(
                  top: 25.0), // Increased padding on the top
              child: CircleAvatar(
                radius: 50,
                //backgroundImage:
                //    NetworkImage(loggedInState.currentUser!.photoURL!),
              ),
            ),
          Text(
            ' ${loggedInState.currentUserName}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' ${loggedInState.currentUserEmail}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          Text(
            'Role: ${loggedInState.currentUserRole}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                loggedInState.refreshUserCoursesData();
              },
              child: const Text("Refresh"))
        ],
      ),
    );
  }
}
