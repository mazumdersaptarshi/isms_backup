import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isms/models/customUser.dart';

class UserDataGetterMaster {
  //private user variables, accessible only to the Master Script internally
  static User? _currentUser;
  static DocumentReference? userRef;
  static DocumentSnapshot? _currentUserSnapshot;
  static String? _userRole;
  static CustomUser? _customUserObject;

  UserDataGetterMaster() {
    print('Entered_userInfogetter');
  }
  //Getters
  User? get currentUser => _currentUser;
  String? get currentUserName => _currentUser?.displayName;
  String? get currentUserEmail => _currentUser?.email;
  String? get currentUserRole => _userRole;
  String? get currentUserUid => _currentUser?.uid;
  DocumentSnapshot? get currentUserSnapshot => _currentUserSnapshot;

  Future<DocumentSnapshot<Object?>?> get newCurrentUserSnapshot async =>
      await FirebaseFirestore.instance.collection('users').doc('${_currentUser?.uid}').get();
  CustomUser? get loggedInUser => _customUserObject;

  //Function called during constructor invoke, to get all required logged in user data from Firestore
  Future<void> getLoggedInUserInfoFromFirestore() async {
    print('Entered getLoggedInUserInfoFromFirestore');
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser == null) {
      print('no user currently signed into Firebase');
      return;
    }
    User user = _currentUser!;

    print('user ${user.email} currently signed into Firebase');
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot? userSnapshot = await userRef.get();
    if (userSnapshot != null) {
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _userRole = userData?['role'];
      CustomUser loggedInUserObject = CustomUser.fromMap(userData!);

      print('loggedInUserObject: ${loggedInUserObject.courses_completed}');
      _customUserObject = loggedInUserObject;
    } else {
      print('user ${user.email} not found in Firestore');
    }
  }
}
