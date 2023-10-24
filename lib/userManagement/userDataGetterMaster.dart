import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isms/models/customUser.dart';

class UserDataGetterMaster {
  //private user variables, accessible only to the Master Script internally
  static User? _currentUser;
  static DocumentReference? userRef;
  static DocumentSnapshot? _currentUserSnapshot;
  static String? _userRole;
  static String? _uid;
  static CustomUser? _customUserObject;

  UserDataGetterMaster() {
    print('Entered_userInfogetter');
  }
  //Getters
  User? get currentUser => _currentUser;
  String? get currentUserName => _currentUser?.displayName;
  String? get currentUserEmail => _currentUser?.email;
  String? get currentUserRole => _userRole;
  String? get currentUserUid => _uid;
  DocumentSnapshot? get currentUserSnapshot => _currentUserSnapshot;
  CustomUser? get loggedInUser => _customUserObject;

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
      _uid = user?.uid;
    }
    if (userSnapshot != null) {
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _userRole = userData?['role'];
      CustomUser loggedInUserObject = CustomUser.fromMap(userData!);

      print('loggedInUserObject: ${loggedInUserObject.courses_completed}');
      _customUserObject = loggedInUserObject;
    } else {
      print('User not found');
    }
  }
}
