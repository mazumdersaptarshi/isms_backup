import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:isms/screens/adminScreens/adminConsoleHomePage.dart';
import 'package:isms/screens/coursesListScreen.dart';
import 'package:isms/screens/createCourseScreen.dart';
import 'package:isms/screens/createModuleScreen.dart';
import 'package:isms/screens/examCreationScreen.dart';
import 'package:isms/screens/loginPage.dart';
import 'package:isms/screens/modulesListScreen.dart';
import 'package:isms/screens/userInfoScreen.dart';

import 'package:provider/provider.dart';

import '../UserManagement/userInfo.dart';
import '../courseManagement/coursesProvider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentSnapshot? currentUserSnapshot;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
  }

  Future<void> _loadUserInformation() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot? userSnapshot = await getUserDetails(currentUser);
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
  }

  Future<void> _handleSignOut() async {
    await FirebaseAuth.instance.signOut();

    print("User signed out");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _handleSignOut, icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminConsoleHomePage()),
              );
            },
            child: const Text('Admin Console'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoursesDisplayScreen()),
              );
            },
            child: const Text('All courses'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserInfoScreen()),
              );
            },
            child: const Text('User Info'),
          ),
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
  }
}
