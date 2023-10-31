import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

class UserProfileHeaderWidget extends StatelessWidget {
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
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0), // Increased padding on the top
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(loggedInState.currentUser!.photoURL!),
              ),
            ),
          Text(
            ' ${loggedInState.currentUserName}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' ${loggedInState.currentUserEmail}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          if (loggedInState.currentUserRole != null)
            Text(
              'Role: ${loggedInState.currentUserRole}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ElevatedButton(
              onPressed: () {
                loggedInState.getUserCoursesData("ref");
              },
              child: Text("Refresh"))
        ],
      ),
    );
  }
}
