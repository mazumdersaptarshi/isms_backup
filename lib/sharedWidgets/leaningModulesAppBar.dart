// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../screens/login/loginScreen.dart';

class LearningModulesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const LearningModulesAppBar({super.key, required this.leadingWidget, this.title = "ISMS"});
  final String title;
  final Widget leadingWidget;

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Define the preferred size

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
                LoggedInState.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(Icons.logout))
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
          ? const CircleAvatar(
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
