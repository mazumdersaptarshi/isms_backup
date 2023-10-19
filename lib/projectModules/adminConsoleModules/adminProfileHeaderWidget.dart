import 'package:flutter/material.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

class AdminInfoWidget extends StatelessWidget {
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (userDataGetterMaster.currentUser?.photoURL != null)
          CircleAvatar(
            radius: 50,
            backgroundImage:
                NetworkImage(userDataGetterMaster.currentUser!.photoURL!),
          ),
        Text(
          ' ${userDataGetterMaster.userName}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          ' ${userDataGetterMaster.userEmail}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        if (userDataGetterMaster.userRole != null)
          Text(
            'Role: ${userDataGetterMaster.userRole}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
      ],
    );
    ;
  }
}
