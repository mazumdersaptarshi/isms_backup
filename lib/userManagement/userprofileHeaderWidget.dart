// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

class UserProfileHeaderWidget extends StatelessWidget {
  UserProfileHeaderWidget(
      {super.key, this.view = 'user', this.refreshCallback});
  final String view;
  Function? refreshCallback;

  @override
  Widget build(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loggedInState.currentUserPhotoURL != null)
            Padding(
                padding: const EdgeInsets.only(
                    top: 25.0), // Increased padding on the top
                child: (view == 'admin')
                    ? Icon(
                        Icons.supervisor_account_rounded,
                        size: 100,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      )
                // CircleAvatar(
                //   radius: 50,
                //   backgroundImage:
                //       NetworkImage(loggedInState.currentUser!.photoURL!),
                // ),
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
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
          Text(
            ' ${loggedInState.currentUserEmail}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            '${loggedInState.currentUserRole}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (view == 'user')
            ElevatedButton(
                onPressed: () async {
                  loggedInState.refreshUserCoursesData().then((value) {
                    if (refreshCallback != null) refreshCallback!();
                  });
                },
                child: Row(
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
