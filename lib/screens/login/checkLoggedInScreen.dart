import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/login/loginScreen.dart';

import 'package:isms/userManagement/customUserProvider.dart';
import 'package:provider/provider.dart';
import 'package:isms/databaseOperations/databaseManager.dart';

class CheckLoggedIn extends StatefulWidget {
  CheckLoggedIn({super.key});

  @override
  State<CheckLoggedIn> createState() => _CheckLoggedInState();
}

class _CheckLoggedInState extends State<CheckLoggedIn> {
  String? loggedInUser;
  bool hasCheckedForChangedDependencies = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasCheckedForChangedDependencies &&
        DatabaseManager.auth.currentUser != null) {
      hasCheckedForChangedDependencies = true;
      if (mounted) {
        await setLoggedInUser(
            customUserProvider: Provider.of<CustomUserProvider>(context));

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      }
    } else if (DatabaseManager.auth.currentUser == null) {
      if (mounted) {
        await setLoggedInUser(
            customUserProvider: Provider.of<CustomUserProvider>(context));

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      }
    }
  }

  setLoggedInUser({required CustomUserProvider customUserProvider}) async {
    await customUserProvider.fetchUsers();
    customUserProvider.users.forEach((element) {
      print(element.username);
      if (element.email == DatabaseManager.auth.currentUser?.email)
        customUserProvider.setLoggedInUser(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: const AlertDialog(
            title: Text("Checking logged in user"),
            content: SizedBox(
                width: 30,
                height: 30,
                child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }
}
