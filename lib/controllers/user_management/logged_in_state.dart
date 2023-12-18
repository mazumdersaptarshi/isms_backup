// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/models/enums.dart';
// import 'package:isms/projectModules/domain_management/domain_provider.dart';
import 'package:logging/logging.dart';

import '../../models/custom_user.dart';
import '../admin_management/create_user_reference_for_admin.dart';
import '../domain_management/domain_provider.dart';

/// This class handles user connections
/// It extends the private class _UserDataGetterMaster so all
/// connections to user data are done with an authentified customer

class LoggedInState extends _UserDataGetterMaster {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Constructor of the class LoggedInState.
  /// This constructor sets a listener that fires immediately, then each
  /// time a user connects or disconnects
  /// If a user disconnects, the user data in memory is cleared and the
  /// user is sent back to the connection screen by a signal sent to the home
  /// page
  /// Input : None
  LoggedInState() {
    // for testing purposes
    //_auth.setPersistence(Persistence.NONE);
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        _logger.info(
            "auth state changed: no account currently signed into Firebase");
        clear();
        // this needs to be called at the end og this branch, because we
        // should only refresh the fisplay after `clear()` has
        // completed,
        notifyListeners();
      } else {
        _logger.info(
            "auth state changed: ${user.email} currently signed into Firebase");
        // ensure the app has a user entry for this account
        await _UserDataGetterMaster.ensureUserDataExists(
            FirebaseAuth.instance.currentUser);
        _fetchFromFirestore(user).then((value) {
          // this needs to be called in `then()`, because we should only
          // refresh the fisplay after `storeUserCoursesData()` has
          // completed,
          notifyListeners();
        });
      }
    });
    listenToChanges();
  }

  ///This function handles the connection from a user to the database
  ///
  ///The login automatically trigger the change of states monitored by the constructor
  ///input : none
  ///return: none
  static Future<void> login() async {
    // get a signed-into Google account (authentication),
    // and sign it into the app (authorisation)
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // only provide accessToken (the result of authorisation),
    // as idToken is the result of authentication and is null in data
    // returned by GoogleSignIn
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
    );
    // sign into the corresponding Firebase account
    // ignore: unused_local_variable
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
  }

  ///This function logout a user from the database and from the GCP authentication
  ///
  ///This change of states automatically trigger the authStateChanges monitored by the constructor.
  ///input : the user object created by the authentication
  ///return: null
  static Future<void> logout() async {
    // sign the Firebase account out of the Firebase app
    await FirebaseAuth.instance.signOut();
    // sign the Google account out of the underlying GCP app
    await GoogleSignIn().signOut();
  }
}

/////-------------------------------/////
// Class handling the user's data
// This class is private to be only accessed though the LoggedInState class that handles the authentication.
/////-------------------------------/////
class _UserDataGetterMaster with ChangeNotifier {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static User? _currentUser;
  static DocumentReference? _userRef;
  static DocumentSnapshot? _currentUserSnapshot;
  static CustomUser? _customUserObject;

  final Logger _logger = Logger('Account');

  ///This function saves a new user in the DB
  ///
  ///input : A custom user object filled with the information received from the authentication process
  ///return: null
  static Future<void> createUserData(CustomUser customUser) async {
    Map<String, dynamic> userJson = customUser.toMap();
    await db.collection('users').doc(customUser.uid).set(userJson);
    //Also creating a reference to the user on Admin side
    CreateUserReferenceForAdmin userRefForAdmin = CreateUserReferenceForAdmin();
    userRefForAdmin.createUserRef(customUser.uid);
  }

  ///This function checks if a user exists in the database
  ///
  ///If a user does not exist in the database this function redirect to the user creation function.
  ///input : the user object created by the authentication
  ///return: null
  static Future<void> ensureUserDataExists(User? user) async {
    if (user == null) return;

    final DocumentSnapshot userSnapshot =
        await db.collection('users').doc(user.uid).get();

    if (userSnapshot.exists) {
      DomainProvider domainProvider = DomainProvider();

      await HiveService.ensureUserLocalDataExists(
          user); //function call to check if local user data exists or not
    }

    if (!userSnapshot.exists) {
      DomainProvider domainProvider = DomainProvider();
      String domain = await domainProvider.getUserDomain(user.uid);

      await createUserData(CustomUser(
          username: user!.displayName!,
          email: user!.email!,
          role: 'user',
          uid: user.uid,
          domain: domain!));
      await HiveService.ensureUserLocalDataExists(user);
    }
  }

  //Getters
  User? get currentUser => _currentUser;
  String? get currentUserName => _currentUser?.displayName;
  String? get currentUserEmail => _currentUser?.email;
  String? get currentUserUid => _currentUser?.uid;
  DocumentReference? get currentUserDocumentReference => _userRef;
  DocumentSnapshot? get currentUserSnapshot => _currentUserSnapshot;
  String? get currentUserPhotoURL => currentUser?.photoURL;

  Future<DocumentSnapshot<Object?>?> get newCurrentUserSnapshot async {
    _currentUserSnapshot = await _userRef!.get();
    return _currentUserSnapshot;
  }

  // TODO consider making this nullable again, using it as criterion for
  // being signed-in, and pushing _currentUser inside as a non-nullable
  // field
  CustomUser get loggedInUser => _customUserObject!;
  String get currentUserRole =>
      _customUserObject != null ? _customUserObject!.role : "";

  ///This function fetch the current user's information from the app and store it in the current user variable accessed with the getter
  ///
  ///input : the user object created by the authentication
  ///return: null
  Future<void> _fetchFromFirestore(User user) async {
    _userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot userSnapshot = await _userRef!.get();
    if (userSnapshot.exists) {
      _logger.info('data fetched from Firestore for user ${user.email}');
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _customUserObject = CustomUser.fromMap(userData!);
      //correction for domain
      if ((!userData.containsKey("domain")) || (userData["domain"] == "")) {
        CreateUserReferenceForAdmin userRefForAdmin =
            CreateUserReferenceForAdmin();
        userRefForAdmin.updateUserRef(user.uid);
        DomainProvider domainProvider = DomainProvider();
        String domain = await domainProvider.getUserDomain(loggedInUser.uid);
        loggedInUser.domain = domain;
        setUserData();
      }
      // last step: now that the user data is available, allow the app
      // to access it by setting _currentUser
      _currentUser = user;
    } else {
      _logger.warning('user ${user.email} not found in Firestore');
      // no data was found in Firestore for this user, so something went
      // wrong during the account creation and we cannot proceed with
      // the sign-in, therefore we sign out
      clear();

      // NOTE: if the user is siging in for the first time, the creation
      // of the user record in Firestore might be ongoing; in this case
      // we could consider a retry strategy
    }
  }

  /// clear user data upon sign-out
  /// inputs: none
  /// return: none
  void clear() {
    // first step: unset _currentUser, so the app knows it is signed out
    // and won't attempt to read any user data
    _currentUser = null;
  }

  /// Updates the current progress to the course by looking it up by courseId, if userCourseProgress object exists
  /// for user then the progress is updated with the new details, if not exists then new userCourseProgress object is created
  Future<void> updateCourseProgress({
    String? courseId,
    String? courseTitle,
    String? startStatus,
    String? completionStatus,
    String? currentSectionId,
    Map<String, dynamic>? currentSection,
  }) async {
    _logger.info(
        await HiveService.getExistingUserCourseLocalData(currentUserUid!));
    /*
    Creating a map of the latest progress data received by the function, and
    Sending it to be updated in the storage
     */
    Map<String, dynamic> latestProgressDataMap = {
      CourseKeys.courseId.name: courseId!,
      CourseKeys.courseTitle.name: courseTitle,
      "startStatus": startStatus,
      "completionStatus": completionStatus,
      "currentSectionId": currentSectionId,
      "currentSection": currentSection,
    };

//Calling Hive function to update Local progress data for the course for current User
    await HiveService.updateCourseWithNewProgressLocal(
        latestProgressDataMap, _currentUser!);
  }

  ///This function creates a listener that monitor any change to the user's data in the DB
  ///
  ///input : the user object created by the authentication
  ///return: null
  void listenToChanges() {
    currentUserDocumentReference?.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        _logger.info('user document was modified: storing new content');
        notifyListeners();
      } else {
        _logger.warning('user document was deleted');
      }
    });
  }

  ///This function encapuslate the methods to gather the user's data from database and map them to the NewUser object
  ///
  ///input : none
  ///return: null
  setUserData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(loggedInUser.uid)
        .set(loggedInUser.toMap());
  }
}
