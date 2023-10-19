import 'package:flutter/material.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

class UserProfileHeaderWidget extends StatelessWidget {
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (userDataGetterMaster.currentUser?.photoURL != null)
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0), // Increased padding on the top
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(userDataGetterMaster.currentUser!.photoURL!),
              ),
            ),
          Text(
            ' ${userDataGetterMaster.userName}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' ${userDataGetterMaster.userEmail}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          if (userDataGetterMaster.userRole != null)
            Text(
              'Role: ${userDataGetterMaster.userRole}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
        ],
      ),
    );
  }
}
