import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../userManagement/userInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(UserManageScreen());
}

class Users {
  final String name;
  final String currentCourse;

  Users(this.name, this.currentCourse);
}

class UserManageScreen extends StatefulWidget {
  @override
  _UserManageScreenState createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  final List<Users> users = [
    Users('John Doe', 'Introduction to Flutter'),
    Users('Jane Doe', 'Advanced Dart Programming'),
    Users('Alex Smith', 'UI/UX Design Fundamentals'),
    Users('Emma Johnson', 'Data Structures and Algorithms'),
    Users('Michael Brown', 'Mobile App Development'),
  ];

  DocumentSnapshot? currentUserSnapshot;

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
      } else {
        print('User not found');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(users[index].name),
              subtitle: Text('Current Course: ${users[index].currentCourse}'),
            );
          },
        ),
      ),
    );
  }
}
