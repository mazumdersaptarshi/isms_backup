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
    print('${FirebaseAuth.instance.currentUser}');
    print('getting new logged iN uSer: ${FirebaseAuth.instance.currentUser!}');
    _currentUser = FirebaseAuth.instance.currentUser!;
    User? user = _currentUser;
    DocumentSnapshot? userSnapshot;

    if (_currentUser != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user?.uid);
      userSnapshot = await userRef.get();
    }
    if (userSnapshot != null) {
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _userRole = userData?['role'];
    } else {
      print('User not found');
    }
  }
}
