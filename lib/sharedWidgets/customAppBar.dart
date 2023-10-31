import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../screens/login/loginScreen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

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
                LoggedInState.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }

  Widget buildUserAvatar(BuildContext context) {
    var loggedInState = context.watch<LoggedInState>();
    return IconButton(
      padding: const EdgeInsets.only(right: 5.0),
      onPressed: () {},
      icon: loggedInState.currentUser?.photoURL != null
          ? CircleAvatar(
              radius: 18,
              backgroundImage:
                  NetworkImage(loggedInState.currentUser!.photoURL!),
            )
          : const Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
    );
  }
}
