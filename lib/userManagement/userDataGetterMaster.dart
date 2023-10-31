import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isms/adminManagement/createUserReferenceForAdmin.dart';
import 'package:isms/models/customUser.dart';

class UserDataGetterMaster {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static User? _currentUser;
  static DocumentReference? _userRef;
  static DocumentSnapshot? _currentUserSnapshot;
  static String? _userRole;
  static CustomUser? _customUserObject;

  static Future<void> createUserData(CustomUser customUser) async {
    Map<String, dynamic> userJson = customUser.toMap();
    print("creating the user ${userJson}");
    await db.collection('users').doc(customUser.uid).set(userJson);

    //Also creating a reference to the user on Admin side
    CreateUserReferenceForAdmin userRefForAdmin = CreateUserReferenceForAdmin();
    userRefForAdmin.createUserRef(customUser.uid);
  }

  static Future<void> ensureUserDataExists(User? user) async {
    if (user == null) return;

    final DocumentSnapshot userSnapshot =
        await db.collection('users').doc(user.uid).get();

    if (!userSnapshot.exists) {
      await createUserData(CustomUser(
          username: user.displayName!,
          email: user.email!,
          role: 'user',
          courses_started: [],
          courses_completed: [],
          uid: user.uid));
    }
  }

  //Getters
  User? get currentUser => _currentUser;
  String? get currentUserName => _currentUser?.displayName;
  String? get currentUserEmail => _currentUser?.email;
  String? get currentUserRole => _userRole;
  String? get currentUserUid => _currentUser?.uid;
  DocumentReference? get currentUserDocumentReference => _userRef;
  DocumentSnapshot? get currentUserSnapshot => _currentUserSnapshot;

  Future<DocumentSnapshot<Object?>?> get newCurrentUserSnapshot async {
    _currentUserSnapshot = await _userRef!.get();
    return _currentUserSnapshot;
  }
  CustomUser? get loggedInUser => _customUserObject;

  // fetch data from Firestore and store it in the app
  Future<void> fetchFromFirestore(User user) async {
    _userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot userSnapshot = await _userRef!.get();
    if (userSnapshot.exists) {
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _userRole = userData?['role'];
      CustomUser loggedInUserObject = CustomUser.fromMap(userData!);

      print('data fetched from Firestore for user ${user.email}');
      _customUserObject = loggedInUserObject;
    } else {
      print('user ${user.email} not found in Firestore');
    }

    // last step: set _currentUser, so the app knows that it is signed
    // in and can now access user data
    _currentUser = user;
  }

  // clear user data upon sign-out
  void clear() {
    // first step: unset _currentUser, so the app knows it is signed out
    // and won't attempt to read any user data
    _currentUser = null;
  }

  set currentUserRole(String? role) {
    _userRole = role;
  }

  setUserData() async {
    print(
        "MUST SET COURSE STARTED ${loggedInUser!.toMap()} at ${loggedInUser?.uid}");
    FirebaseFirestore.instance
        .collection("users")
        .doc(loggedInUser!.uid)
        .set(loggedInUser!.toMap());
  }
}
