import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../userManagement/loggedInState.dart';

class AdminInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    return Column(
      children: [
        if (loggedInState.currentUser?.photoURL != null)
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage(loggedInState.currentUser!.photoURL!),
            ),
          ),
        if (loggedInState.currentUserRole != null)
          Text(
            ' ${loggedInState.currentUserName}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        Text(
          ' ${loggedInState.currentUserEmail}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        if (loggedInState.currentUserRole != null)
          Text(
            'Role: ${loggedInState.currentUserRole}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
      ],
    );
  }
}
