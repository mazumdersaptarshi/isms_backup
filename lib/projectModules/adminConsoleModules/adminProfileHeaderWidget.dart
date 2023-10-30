import 'package:flutter/material.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

class AdminInfoWidget extends StatelessWidget {
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        if (userDataGetterMaster.currentUser?.photoURL != null)
          CircleAvatar(
            radius: 40,
            backgroundImage:
                NetworkImage(userDataGetterMaster.currentUser!.photoURL!),
          ),
        Text(
          ' ${userDataGetterMaster.currentUserEmail}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        if (userDataGetterMaster.currentUserRole != null)
          Text(
            ' ${userDataGetterMaster.currentUserName}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
    );
  }
}
