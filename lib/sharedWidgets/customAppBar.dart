import 'package:flutter/material.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';
import 'package:isms/utilityFunctions/authUtils.dart';

import '../screens/login/loginScreen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // Define the preferred size

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Text('ISMS'),
          const Spacer(),
          buildUserAvatar(context),
          IconButton(
              onPressed: () {
                AuthUtils.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }

  Widget buildUserAvatar(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(right: 5.0),
      onPressed: () {},
      icon: userDataGetterMaster.currentUser?.photoURL != null
          ? CircleAvatar(
              radius: 18,
              backgroundImage:
                  NetworkImage(userDataGetterMaster.currentUser!.photoURL!),
            )
          : const Icon(
              Icons.account_circle,
            ),
    );
  }
}
