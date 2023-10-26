import 'package:flutter/material.dart';
import 'package:isms/utilityFunctions/authUtils.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

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
        ],
      ),
    );
  }

  Widget buildUserAvatar(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(right: 5.0),
      onPressed: () => AuthUtils.logout(),
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
