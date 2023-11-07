import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isms/adminManagement/createUserReferenceForAdmin.dart';
import 'package:isms/models/customUser.dart';

class UserDataGetterMaster {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static User? _currentUser;
  static DocumentReference? _userRef;
  static DocumentSnapshot? _currentUserSnapshot;
  static late CustomUser _customUserObject;

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
  String? get currentUserUid => _currentUser?.uid;
  DocumentReference? get currentUserDocumentReference => _userRef;
  DocumentSnapshot? get currentUserSnapshot => _currentUserSnapshot;

  Future<DocumentSnapshot<Object?>?> get newCurrentUserSnapshot async {
    _currentUserSnapshot = await _userRef!.get();
    return _currentUserSnapshot;
  }

  // TODO consider making this nullable again, using it as criterion for
  // being signed-in, and pushing _currentUser inside as a non-nullable
  // field
  CustomUser get loggedInUser => _customUserObject;
  String get currentUserRole => _customUserObject.role;

  // fetch data from Firestore and store it in the app
  Future<void> fetchFromFirestore(User user) async {
    _userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot userSnapshot = await _userRef!.get();
    if (userSnapshot.exists) {
      print('data fetched from Firestore for user ${user.email}');
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _customUserObject = CustomUser.fromMap(userData!);

      // last step: set _currentUser, so the app knows that it is signed
      // in and can now access user data
      _currentUser = user;
    } else {
      print('user ${user.email} not found in Firestore');
      // no data was found in Firestore for this user, so something went
      // wrong during the account creation and we cannot proceed with
      // the sign-in, therefore we sign out
      clear();

      // NOTE: if the user is siging in for the first time, the creation
      // of the user record in Firestore might be ongoing; in this case
      // we could consider a retry strategy
    }
  }

  // clear user data upon sign-out
  void clear() {
    // first step: unset _currentUser, so the app knows it is signed out
    // and won't attempt to read any user data
    _currentUser = null;
  }

  setUserData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(loggedInUser.uid)
        .set(loggedInUser.toMap());
  }
}
