import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdminInfoWidget());
}

User? get currentUser => FirebaseAuth.instance.currentUser;

String get _userName => currentUser?.displayName ?? 'No Name';
String get _userEmail => currentUser?.email ?? 'No Email';

class AdminInfoWidget extends StatefulWidget {
  @override
  State<AdminInfoWidget> createState() => _AdminInfoWidgetState();
}

class _AdminInfoWidgetState extends State<AdminInfoWidget> {
  late DocumentSnapshot?
      _currentUserSnapshot; //Declaring Document snapshot to be used later
  String _userRole = 'n/a'; //Declaring User role to be used later

  @override
  Future<DocumentSnapshot?> getAdminUserDetails(User? user) async {
    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      print('User Reference: $userRef');
      return userRef.get();
    } else {
      return null;
    }
  }

  Future<void> _loadUserInformation() async {
    // User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _currentUserSnapshot = await getAdminUserDetails(
          currentUser); //Getting Document snapshot for user when the function is called

      if (_currentUserSnapshot != null) {
        Map<String, dynamic>? userData =
            _currentUserSnapshot?.data() as Map<String, dynamic>?;
        print('userData: $userData');
        _userRole = userData?['role'];
      } else {
        print('User not found');
      }
    }
  }

  void initState() {
    super.initState();
    _loadUserInformation();
  }

  Widget build(BuildContext context) {
    print(_userName);
    return Column(
      children: [
        if (currentUser?.photoURL != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(currentUser!.photoURL!),
          ),
        Text(
          ' ${_userName}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          ' ${_userEmail}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        if (_userRole != null)
          Text(
            'Role: $_userRole',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
      ],
    );
    ;
  }
}
