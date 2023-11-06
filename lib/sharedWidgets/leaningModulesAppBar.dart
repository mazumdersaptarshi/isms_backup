import 'package:flutter/material.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/authUtils.dart';
import 'package:provider/provider.dart';

import '../screens/login/loginScreen.dart';

class LearningModulesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  LearningModulesAppBar({required this.leadingWidget, this.title = "ISMS"});
  String title;
  Widget leadingWidget;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // Define the preferred size

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(title),
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
      leading: leadingWidget,
      elevation: 4,
      surfaceTintColor: Colors.white,
      backgroundColor: bgColor,
      titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme:
          Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
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
              //backgroundImage:
              //    NetworkImage(loggedInState.currentUser!.photoURL!),
            )
          : const Icon(
              Icons.account_circle,
            ),
    );
  }
}
