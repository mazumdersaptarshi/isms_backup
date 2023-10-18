import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/utilityWidgets/logoutUtility.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
      onPressed: () => AuthUtils.logout(context),
      icon: FirebaseAuth.instance.currentUser?.photoURL != null
          ? CircleAvatar(
              radius: 18,
              backgroundImage:
                  NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
            )
          : const Icon(
              Icons.account_circle,
            ),
    );
  }
}
