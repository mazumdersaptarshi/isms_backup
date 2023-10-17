import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isms/screens/homePage.dart';

import '../screens/adminScreens/userManageScreen.dart';
import '../userManagement/userInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdminConsoleApp());
}

class Actions {
  final String? name;
  final IconData? icon;

  Actions({this.name, this.icon});
}

class AdminConsoleApp extends StatefulWidget {
  @override
  _AdminConsoleAppState createState() => _AdminConsoleAppState();
}

class _AdminConsoleAppState extends State<AdminConsoleApp> {
  final List<Actions> adminActions = [
    Actions(name: 'Dashboard', icon: Icons.dashboard),
    Actions(name: 'Reports', icon: Icons.description),
    Actions(name: 'User Management', icon: Icons.group),
    Actions(name: 'Course Management', icon: Icons.school),
    Actions(name: 'Draft Courses', icon: Icons.edit),
    Actions(name: 'Exams', icon: Icons.assignment),
    Actions(name: 'Logout', icon: Icons.exit_to_app),
  ];

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Admin Console'),
        ),
        body: Column(
          children: [
            UserProfileWidget(userRole: userRole),
            Expanded(
              child: ListView.builder(
                itemCount: adminActions.length,
                itemBuilder: (context, index) {
                  final action = adminActions[index];
                  return ListTile(
                    leading: Icon(action.icon),
                    title: Text(action.name!),
                    onTap: () {
                      if (action.name == 'Dashboard') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardScreen()));
                      } else if (action.name == 'Reports') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportsScreen()));
                      } else if (action.name == 'User Management') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserManageScreen()),
                        );
                      } else if (action.name == 'Course Management') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else if (action.name == 'Draft Courses') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DraftCoursesScreen()));
                      } else if (action.name == 'Exams') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExamsScreen()));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  final String? userRole;

  UserProfileWidget({this.userRole});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          if (FirebaseAuth.instance.currentUser?.photoURL != null)
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
            ),
          SizedBox(height: 20.0), // Increased padding
          Text(
            ' ${getUserName()}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0), // Increased padding
          Text(
            ' ${getUserEmail()}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10.0), // Increased padding
          if (userRole != null)
            Text(
              'Role: $userRole',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          Divider(
            // Horizontal line
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text('Dashboard Screen Content'),
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Center(
        child: Text('Reports Screen Content'),
      ),
    );
  }
}

class DraftCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draft Courses'),
      ),
      body: Center(
        child: Text('Draft Courses Screen Content'),
      ),
    );
  }
}

class ExamsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exams'),
      ),
      body: Center(
        child: Text('Exams Screen Content'),
      ),
    );
  }
}
