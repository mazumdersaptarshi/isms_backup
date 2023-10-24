import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataGetterMaster {
  //private user variables, accessible only to the Master Script internally
  static User? _currentUser;
  static DocumentReference? userRef;
  static DocumentSnapshot? _currentUserSnapshot;
  static String? _userRole;

  UserDataGetterMaster() {
    print('Entered_userInfogetter');
    getLoggedInUserInfoFromFirestore();
  }
  //Getters
  User? get currentUser => _currentUser;
  String? get currentUserName => _currentUser?.displayName;
  String? get currentUserEmail => _currentUser?.email;
  String? get currentUserRole => _userRole;
  DocumentSnapshot? get currentUserSnapshot => _currentUserSnapshot;

  //Function called during constructor invoke, to get all required logged in user data from Firestore
  Future<void> getLoggedInUserInfoFromFirestore() async {
    print('Entered getLoggedInUserInfoFromFirestore');
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser == null) {
      print('no user currently signed into Firebase');
      return;
    }

    print('user ${_currentUser!.email} currently signed into Firebase');
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid);
    DocumentSnapshot? userSnapshot = await userRef.get();
    if (userSnapshot != null) {
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _userRole = userData?['role'];
    } else {
      print('user ${_currentUser!.email} not found in Firestore');
    }
  }
}
