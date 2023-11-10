// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

class UserProfileHeaderWidget extends StatelessWidget {
  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
  // LoggedInState loggedInState;
  const UserProfileHeaderWidget({super.key, this.view = 'user'});
  final String? view;
  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loggedInState.currentUser?.photoURL != null)
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0), // Increased padding on the top
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(loggedInState.currentUser!.photoURL!),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          Text(
            ' ${loggedInState.currentUserName}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
          Text(
            ' ${loggedInState.currentUserEmail}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            loggedInState.currentUserRole,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (view == 'user')
            ElevatedButton(
                onPressed: () {
                  loggedInState.refreshUserCoursesData();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Refresh"),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(CupertinoIcons.refresh_bold),
                  ],
                ))
        ],
      ),
    );
  }
}
