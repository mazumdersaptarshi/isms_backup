// ignore_for_file: file_names

import 'package:logging/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:isms/adminManagement/createUserReferenceForAdmin.dart';
import 'package:isms/models/newExam.dart';

import '../models/course.dart';
import '../models/customUser.dart';
import '../models/module.dart';
import '../models/userCoursesDetails.dart';
import '../projectModules/courseManagement/coursesProvider.dart';

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
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        logger.info(
            "auth state changed: no account currently signed into Firebase");
        clear();
        // this needs to be called at the end og this branch, because we
        // should only refresh the fisplay after `clear()` has
        // completed,
        notifyListeners();
      } else {
        logger.info(
            "auth state changed: ${user.email} currently signed into Firebase");
        _fetchFromFirestore(user).then((value) {
          if (currentUserSnapshot != null) {
            storeUserCoursesData(currentUserSnapshot!);
          }
          // this needs to be called in `then()`, because we should only
          // refresh the fisplay after `storeUserCoursesData()` has
          // completed,
          notifyListeners();
        });
      }
    });
    listenToChanges();
  }

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

    // ensure the app has a user entry for this account
    _UserDataGetterMaster.ensureUserDataExists(
        FirebaseAuth.instance.currentUser);
  }

  static Future<void> logout() async {
    // sign the Firebase account out of the Firebase app
    await FirebaseAuth.instance.signOut();
    // sign the Google account out of the underlying GCP app
    await GoogleSignIn().signOut();
  }
}

class _UserDataGetterMaster with ChangeNotifier {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static User? _currentUser;
  static DocumentReference? _userRef;
  static DocumentSnapshot? _currentUserSnapshot;
  static CustomUser? _customUserObject;
  List<dynamic> allEnrolledCoursesGlobal =
      []; //Global List to hold all enrolled courses for User

  List<dynamic> allCompletedCoursesGlobal =
      []; //Global List to hold all completed courses for User

  final Logger logger = Logger('Account');

  static Future<void> createUserData(CustomUser customUser) async {
    Map<String, dynamic> userJson = customUser.toMap();
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

  // fetch data from Firestore and store it in the app
  Future<void> _fetchFromFirestore(User user) async {
    _userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot userSnapshot = await _userRef!.get();
    if (userSnapshot.exists) {
      logger.info('data fetched from Firestore for user ${user.email}');
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _customUserObject = CustomUser.fromMap(userData!);

      // last step: now that the user data is available, allow the app
      // to access it by setting _currentUser
      _currentUser = user;
    } else {
      logger.warning('user ${user.email} not found in Firestore');
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

  void listenToChanges() {
    currentUserDocumentReference?.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        logger.info('user document was modified: storing new content');
        storeUserCoursesData(snapshot);
        notifyListeners();
      } else {
        logger.warning('user document was deleted');
      }
    });
  }

  setUserData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(loggedInUser.uid)
        .set(loggedInUser.toMap());
  }

  void storeUserCoursesData(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
      UserCoursesDetails data = UserCoursesDetails.fromMap(mapData);
      // TODO check why this is cleared then set
      allEnrolledCoursesGlobal.clear();
      allCompletedCoursesGlobal.clear();
      allEnrolledCoursesGlobal = data.courses_started!;
      // allCompletedCoursesGlobal = data.courses_completed!;
      // TODO check first that these lists aren't null
      for (var courseInStarted in data.courses_started!) {
        for (var courseInCompleted in data.courses_completed!) {
          if (courseInCompleted['courseID'] == courseInStarted['courseID']) {
            allCompletedCoursesGlobal.add(courseInStarted);
          }
        }
      }
    } else {
      logger.warning('user document was deleted');
    }
  }

  //Getter function for all course related info from users collection, for the logged in User
  //Basically populates the two static global variables allEnrolledCoursesGlobal and allCompletedCoursesGlobal
  Future<void> refreshUserCoursesData() async {
    DocumentSnapshot? newCurrentUserDocumentSnapshot =
        await newCurrentUserSnapshot;

    storeUserCoursesData(newCurrentUserDocumentSnapshot!);
  }

  Future<List> getUserCoursesData(String actionId) async {
    if (actionId == 'crs_enrl') {
      return allEnrolledCoursesGlobal;
    }
    if (actionId == 'crs_compl') {
      return allCompletedCoursesGlobal;
    }
    return [];
  }

  setUserCourseStarted({required Map<String, dynamic> courseDetails}) async {
    bool flag = false;
    if (loggedInUser.courses_started.isNotEmpty) {
      for (var course in loggedInUser.courses_started) {
        if (course['courseID'] == courseDetails['courseID']) {
          flag = true;
        }
      }
    }
    if (flag == false) {
      loggedInUser.courses_started.add(courseDetails);
      await setUserData();
      await setAdminConsoleCourseMap(
          courseName: courseDetails["course_name"],
          courseMapFieldToUpdate: "course_started",
          username: loggedInUser.username,
          uid: loggedInUser.uid);
    }
    notifyListeners();
  }

  setUserCourseCompleted({required Map<String, dynamic> courseDetails}) async {
    bool flag = false;
    if (loggedInUser.courses_completed.isNotEmpty) {
      for (var course in loggedInUser.courses_completed) {
        if (course['courseID'] == courseDetails['courseID']) {
          flag = true;
        }
      }
    }
    if (flag == false) {
      loggedInUser.courses_completed.add(courseDetails);
      await setUserData();
      await setAdminConsoleCourseMap(
          courseName: courseDetails["course_name"],
          courseMapFieldToUpdate: "course_completed",
          username: loggedInUser.username,
          uid: loggedInUser.uid);
    }
    notifyListeners();
  }

  Future<bool> setUserCourseExamCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required int examIndex}) async {
    bool courseExamCompleted = false;
    if (loggedInUser.courses_started.isNotEmpty) {
      int courseIndex = loggedInUser.courses_started
          .indexWhere((element) => element['courseID'] == course.id);
      if (courseIndex > -1) {
        Map<String, dynamic> courseStarted =
            loggedInUser.courses_started[courseIndex];
        if (!courseStarted.containsKey('exams_completed')) {
          courseStarted["exams_completed"] = [];
        }
        int examPassed = -1;
        if (courseStarted["exams_completed"].isNotEmpty) {
          examPassed = courseStarted["exams_completed"]
              .indexWhere((element) => element["exam_index"] == examIndex);
        }
        if (examPassed == -1) {
          // FIXME: we should add an exam with this index, not just the
          // index
          courseStarted["exams_completed"].add(examIndex);
          loggedInUser.courses_started[courseIndex] = courseStarted;
          await setUserData();
          notifyListeners();
        }
        // TODO make sure the exams are feched
        List<NewExam> remainingExams = List.from(course.exams!);
        courseStarted["exams_completed"].forEach((examIndex) =>
            {remainingExams.removeWhere((exam) => exam.index == examIndex)});
        courseExamCompleted = remainingExams.isEmpty;
      }
    }
    return courseExamCompleted;
  }

  setUserCourseModuleCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required Module module}) async {
    if (loggedInUser.courses_started.isNotEmpty) {
      int courseIndex = loggedInUser.courses_started
          .indexWhere((element) => element['courseID'] == course.id);
      if (courseIndex > -1) {
        Map<String, dynamic> courseStarted =
            loggedInUser.courses_started[courseIndex];
        if (!courseStarted.containsKey('modules_completed')) {
          courseStarted['modules_completed'] =
              courseStarted['modules_completed'] = [];
        }
        int moduleIndex = -1;
        if (courseStarted['modules_completed'].isNotEmpty) {
          courseStarted['modules_completed']
              .indexWhere((element) => element['module_id'] == module.id);
        }
        if (moduleIndex == -1) {
          courseStarted['modules_completed']
              .add({"module_name": module.title, "module_id": module.id});
          loggedInUser.courses_started[courseIndex] = courseStarted;
          await setUserData();
          notifyListeners();
        }
      }
    }
  }

  setUserCourseModuleStarted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required Module module}) async {
    int courseIndex = loggedInUser.courses_started.indexWhere((courseInList) =>
        courseInList["courseID"] == courseDetails["courseID"]);
    int moduleIndex = -1;
    if (courseIndex > -1) {
      if (!loggedInUser.courses_started[courseIndex]
          .containsKey("modules_started")) {
        loggedInUser.courses_started[courseIndex]["modules_started"] = [];
      }
      if (loggedInUser
          .courses_started[courseIndex]["modules_started"].isNotEmpty) {
        moduleIndex = loggedInUser.courses_started[courseIndex]
                ["modules_started"]
            .indexWhere(
                (moduleStarted) => moduleStarted["module_id"] == module.id);
      }
      Map<String, dynamic> moduleStartedMap = {
        "module_id": module.id,
        "module_name": module.title
      };
      if (moduleIndex == -1) {
        loggedInUser.courses_started[courseIndex]["modules_started"]
            .add(moduleStartedMap);
        await setUserData();
        notifyListeners();
      }
    }
  }

  setUserModuleExamCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required Module module,
      required int examIndex}) async {
    int courseIndex = loggedInUser.courses_started.indexWhere(
        (courseInList) =>
            courseInList["courseID"] == courseDetails["courseID"]);
    if (courseIndex > -1) {
      int moduleIndex = loggedInUser.courses_started[courseIndex]
              ["modules_started"]
          .indexWhere(
              (moduleInList) => moduleInList["module_name"] == module.title);
      if (moduleIndex > -1) {
        Map<String, dynamic> startedModule = loggedInUser
            .courses_started[courseIndex]["modules_started"][moduleIndex];
        if (!startedModule.containsKey("exams_completed")) {
          startedModule.addAll({"exams_completed": []});
        }
        if (!startedModule["exams_completed"].contains(examIndex)) {
          startedModule["exams_completed"].add(examIndex);
          loggedInUser.courses_started[courseIndex]["modules_started"]
              [moduleIndex] = startedModule;
          await setUserData();
          if (startedModule["exams_completed"].length >=
              module.exams?.length) {
            await setUserCourseModuleCompleted(
                courseDetails: courseDetails,
                coursesProvider: coursesProvider,
                course: course,
                module: module);
          }
        }
      }
    }
    //moduleStartedIndex++;*/
  }
  //notifyListeners();

  setAdminConsoleCourseMap(
      {required String courseName,
      required String username,
      required String uid,
      required String courseMapFieldToUpdate}) async {
    DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
        .collection("adminconsole")
        .doc("allcourses")
        .collection("allCourseItems")
        .doc(courseName)
        .get();
    if (courseSnapshot.exists) {
      Map<String, dynamic> courseMap =
          courseSnapshot.data() as Map<String, dynamic>;
      if (!courseMap.containsKey(courseMapFieldToUpdate)) {
        courseMap[courseMapFieldToUpdate] = [];
      }
      if (courseMap[courseMapFieldToUpdate]
              .indexWhere((course) => course["uid"] == uid) ==
          -1) {
        courseMap[courseMapFieldToUpdate]
            .add({"username": username, "uid": uid});
        await FirebaseFirestore.instance
            .collection("adminconsole")
            .doc("allcourses")
            .collection("allCourseItems")
            .doc(courseName)
            .set(courseMap);
      }
    }
  }
}
