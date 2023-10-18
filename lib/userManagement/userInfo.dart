import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(UserProfileApp());
}

String getUserName() {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.displayName ?? 'No Name';
  } else {
    return 'Not logged in';
  }
}

String getUserEmail() {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.email ?? 'No Email';
  } else {
    return 'Not logged in';
  }
}

Future<DocumentSnapshot?> getUserDetails(User? user) async {
  if (user != null) {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    print('User Reference: $userRef');
    return userRef.get();
  } else {
    return null;
  }
}

class UserProfileApp extends StatelessWidget {
  const UserProfileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfileScreen(),
    );
  }
}

const int totalCourses = 10;

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late DocumentSnapshot? currentUserSnapshot;
  late String? userRole;

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
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;
          userRole = userData?['role'];
        });
      } else {
        print('User not found');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      body: UserProfileWidget(userRole: userRole),
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  final String? userRole;

  const UserProfileWidget({Key? key, this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (FirebaseAuth.instance.currentUser?.photoURL != null)
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0), // Increased padding on the top
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
              ),
            ),
          Text(
            ' ${getUserName()}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' ${getUserEmail()}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          if (userRole != null)
            Text(
              'Role: $userRole',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot?>(
              future: getUserDetails(FirebaseAuth.instance.currentUser),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Map<String, dynamic>? userData =
                      snapshot.data?.data() as Map<String, dynamic>?;

                  if (userData == null) {
                    // Handle missing data gracefully
                    return ListTile(
                      title: Text('Missing Data'),
                      subtitle: Text('No name or email found'),
                      leading: CircularPercentIndicator(
                        radius: 25.0,
                        lineWidth: 2.0,
                        percent: 0.0,
                        center: Text('0%'),
                        progressColor: Colors.red,
                      ),
                    );
                  }

                  return Text('');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
