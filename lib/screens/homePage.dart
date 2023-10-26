import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:isms/projectModules/courseManagement/coursesProvider.dart';


import 'package:isms/screens/adminScreens/AdminConsole/adminConsolePage.dart';

import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/userInfo/userProfilePage.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:provider/provider.dart';

import '../userManagement/userDataGetterMaster.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'learningModuleScreens/courseScreens/createCourseScreen.dart';
import 'login/loginScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentSnapshot? currentUserSnapshot;
  String? userRole;
  UserDataGetterMaster userInfoGetter = UserDataGetterMaster();

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
  }

  Future<void> _loadUserInformation() async {
    User? currentUser = userInfoGetter.currentUser;
    await userInfoGetter.getLoggedInUserInfoFromFirestore();
    DocumentSnapshot? userSnapshot = userInfoGetter.currentUserSnapshot;
    if (userSnapshot != null) {
      setState(() {
        currentUserSnapshot = userSnapshot;
      });
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      userRole = userData?['role'];
    } else {
      print('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.user == null) {
      return LoginPage();
    }

    return Consumer<CoursesProvider>(
        builder: (BuildContext context, CoursesProvider value, Widget? child) {
      return Scaffold(
        appBar: CustomAppBar(),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminConsolePage()),
                );
              },
              child: const Text('Admin Console'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoursesDisplayScreen()),
                );
              },
              child: const Text('All courses'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
              child: const Text('User profile'),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateCourseScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
