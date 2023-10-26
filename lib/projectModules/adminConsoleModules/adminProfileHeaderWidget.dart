import 'package:flutter/material.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

class AdminInfoWidget extends StatelessWidget {
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (userDataGetterMaster.currentUser?.photoURL != null)
            CircleAvatar(
              radius: 30,
              backgroundImage:
                  NetworkImage(userDataGetterMaster.currentUser!.photoURL!),
            ),
          Text(
            ' ${userDataGetterMaster.currentUserName}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' ${userDataGetterMaster.currentUserEmail}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          if (userDataGetterMaster.currentUserRole != null)
            Text(
              'Role: ${userDataGetterMaster.currentUserRole}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
        ],
      ),
    );
    ;
  }
}
