import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:isms/userManagement/userDataGetterMaster.dart';

import '../models/course.dart';
import '../models/customUser.dart';
import '../models/userCoursesDetails.dart';
import '../projectModules/courseManagement/coursesProvider.dart';

class LoggedInState with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDataGetterMaster _userDataGetterMaster = UserDataGetterMaster();
  // CustomUser? get getCurrentUser => _userDataGetterMaster.loggedInUser;

  // User? get user => _userDataGetterMaster.currentUser;

  List<dynamic> allEnrolledCoursesGlobal =
      []; //Global List to hold all enrolled courses for User

  List<dynamic> allCompletedCoursesGlobal =
      []; //Global List to hold all completed courses for User
  bool authStateChanged = false;

  LoggedInState() {
    _auth.authStateChanges().listen((User? user) {
      authStateChanged = true;
      if (user == null) {
        print(
            "auth state changed: no account is currently signed into Firebase");
        _userDataGetterMaster.currentUser = null;
        notifyListeners();
      } else {
        print(
            "auth state changed: account ${user!.email} is currently signed into Firebase");

        _userDataGetterMaster.getLoggedInUserInfoFromFirestore().then((_value) {
          print("account ${user!.email}'s data was fetched from Firestore");
          // this is used as source of truth in the app, so it has to
          // occur after getLoggedInUserInfoFromFirestore() to ensure all
          // the user-related data is available
          _userDataGetterMaster.currentUser = user;
          notifyListeners();
        });
      }
    });
    listenToChanges();
  }

  //Getters from the State management provider, all classes can get the data about logged in User using these getters
  User? get currentUser => _userDataGetterMaster.currentUser;
  String? get currentUserName => _userDataGetterMaster.currentUserName;
  String? get currentUserEmail => _userDataGetterMaster.currentUserEmail;
  String? get currentUserRole => _userDataGetterMaster.currentUserRole;
  String? get currentUserUid => _userDataGetterMaster.currentUserUid;
  CustomUser? get loggedInUser => _userDataGetterMaster.loggedInUser;
  DocumentReference? get currentUserDocumentReference =>
      _userDataGetterMaster.currentUserDocumentReference;
  Future<DocumentSnapshot<Object?>?>
      get getNewCurrentUserDocumentSnapshot async =>
          await _userDataGetterMaster.newCurrentUserSnapshot;

  void listenToChanges() {
    currentUserDocumentReference?.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        print('user document was modified: storing new content');
        storeUserCoursesData(snapshot);
        notifyListeners();
      } else {
        print('user document was deleted');
      }
    });
  }

  void storeUserCoursesData(DocumentSnapshot snapshot) {
    if (snapshot!.exists) {
      Map<String, dynamic> mapData =
        snapshot.data() as Map<String, dynamic>;
      UserCoursesDetails data = UserCoursesDetails.fromMap(mapData);
      allEnrolledCoursesGlobal = data.courses_started!;
      allCompletedCoursesGlobal = data.courses_completed!;
    } else {
      print('user document was deleted');
    }
  }

  //Getter function for all course related info from users collection, for the logged in User
  //Basically populates the two static global variables allEnrolledCoursesGlobal and allCompletedCoursesGlobal
  Future<void> fetchUserCoursesData() async {
    print('Current value of authStateChanged: $authStateChanged');

    if (authStateChanged) {
      print(
          "Fetching fresh data because authStateChanged = $authStateChanged");

      print('Inside fetch courses user provider ${currentUserUid}');
      DocumentSnapshot? newCurrentUserDocumentSnapshot =
          await getNewCurrentUserDocumentSnapshot;

      storeUserCoursesData(newCurrentUserDocumentSnapshot!);
      print('890io: ${allEnrolledCoursesGlobal}');
      authStateChanged = false;
    } else {
      print(
          "Using cached data because authStateChanged = $authStateChanged");
    }
  }

  Future<List> getUserCoursesData(String actionId) async {
    await fetchUserCoursesData();
    if (actionId == 'crs_enrl') {
      return allEnrolledCoursesGlobal;
    }
    if (actionId == 'crs_compl') {
      return allCompletedCoursesGlobal;
    }
    return [];
  }

  Future<void> refreshUserCoursesData() async {
    authStateChanged = true;
    await fetchUserCoursesData();
  }

  setUserCourseStarted({required Map<String, dynamic> courseDetails}) {
    bool flag = false;
    if (loggedInUser!.courses_started.isNotEmpty) {
      loggedInUser!.courses_started.forEach((course) {
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            flag = true;
          }
        } catch (e) {}
      });
    }
    if (flag == false) {
      loggedInUser?.courses_started.add(courseDetails);
      _userDataGetterMaster.setUserData();
      setAdminConsoleCourseMap(
          courseName: courseDetails["course_name"],
          courseMapFieldToUpdate: "course_started",
          username: loggedInUser!.username,
          uid: loggedInUser!.uid!);
    }
    notifyListeners();
  }

  setUserCourseCompleted({required Map<String, dynamic> courseDetails}) {
    bool flag = false;
    if (loggedInUser!.courses_completed.isNotEmpty) {
      loggedInUser!.courses_completed.forEach((course) {
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            flag = true;
          }
        } catch (e) {}
      });
    }
    if (flag == false) {
      loggedInUser?.courses_completed.add(courseDetails);
      _userDataGetterMaster.setUserData();
      setAdminConsoleCourseMap(
          courseName: courseDetails["course_name"],
          courseMapFieldToUpdate: "course_completed",
          username: loggedInUser!.username,
          uid: loggedInUser!.uid!);
    }
    notifyListeners();
  }

  setUserCourseExamCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required int courseIndex,
      required int examIndex}) {
    int noOfExamsCompleted = 0;
    bool flag = false;
    print('rdcf: ${loggedInUser}');
    if (loggedInUser!.courses_started.isNotEmpty) {
      loggedInUser!.courses_started.forEach((course) {
        try {
          if (course['course_name'] == courseDetails['course_name']) {
            course['exams_completed'].forEach((exam_completed) {
              noOfExamsCompleted++;
              print("INCREMENTING noOfExamsCompleted: ${noOfExamsCompleted}");
              if (exam_completed == examIndex) {
                flag = true;
              }
            });
          }
        } catch (e) {}
      });
    }
    if (flag == false) {
      examIndex--;
      Course course = coursesProvider.allCourses[courseIndex];
      loggedInUser?.courses_started.forEach((course_started) {
        if (course_started['courseID'] == course.id) {
          if (course_started['exams_completed'] != null &&
              course_started['exams_completed'].isEmpty) {
            course_started['exams_completed']
                .add(course.exams![examIndex].index);
            print(
                "COMPLETED EXAM was empty ${course_started['exams_completed']}");
          } else if (course_started['exams_completed'] != null) {
            bool isExamPresentInList = false;
            for (int i = 0; i < course_started['exams_completed'].length; i++) {
              var element = course_started['exams_completed'][i];
              if (element == course.exams![examIndex].index) {
                isExamPresentInList = true;
              }
            }
            if (isExamPresentInList == false) {
              course_started['exams_completed']
                  .add(course.exams![examIndex].index);
              print("ADDING EXAM ${course.exams![examIndex].index}");
              print("COMPLETED EXAM ${course_started['exams_completed']}");
            }
          } else {
            print("COMPLETED MODULE IS NULL< SO HERE");
            course_started['exams_completed'] = [];
            course_started['exams_completed']
                .add(course.exams![examIndex].index);
          }
        }
      });
      print(loggedInUser!.courses_started);
      noOfExamsCompleted++;
      _userDataGetterMaster.setUserData();
    }
    int noOfExams = coursesProvider.allCourses[courseIndex].exams!.length;
    print("noOfExamsCompleted ${noOfExamsCompleted},, ${noOfExams}");
    if (noOfExamsCompleted >= noOfExams) {
      setUserCourseCompleted(courseDetails: courseDetails);
    }
    notifyListeners();
  }

  setUserCourseModuleCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required int courseIndex,
      required int moduleIndex}) {
    bool flag = false;
    if (loggedInUser!.courses_started.isNotEmpty) {
      loggedInUser!.courses_started.forEach((course) {
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            course["modules_completed"].forEach((element) {
              if (element ==
                  coursesProvider
                      .allCourses[courseIndex].modules![moduleIndex].title) {
                print("SETTING FLAG TRUE coz ${element}");
                flag = true;
              }
            });
          }
        } catch (e) {}
      });
    }
    if (flag == false) {
      print("FLAG IS FALSE ${courseDetails}");
      Course course = coursesProvider.allCourses[courseIndex];
      _userDataGetterMaster.loggedInUser?.courses_started
          .forEach((course_started) {
        if (course_started['courseID'] == course.id) {
          print("COMPLETED MODULEE ${course_started['modules_completed']}");
          bool flag = false;
          if (course_started['modules_completed'] != null) {
            for (int i = 0;
                i < course_started['modules_completed'].length;
                i++) {
              var element = course_started['modules_completed'][i];
              if (element == course.modules![moduleIndex].title) {
                flag = true;
              }
            }
            if (flag == false) {
              course_started['modules_completed']
                  .add(course.modules![moduleIndex].title);
            }
          } else {
            print("COMPLETED MODULE IS NULL< SO HERE");
            course_started['modules_completed'] = [];
            course_started['modules_completed']
                .add(course.modules![moduleIndex].title);
          }
        }
      });
      print(_userDataGetterMaster.loggedInUser!.courses_started);
      _userDataGetterMaster.setUserData();
    }
    notifyListeners();
  }

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
      if (courseMap[courseMapFieldToUpdate] == null)
        courseMap[courseMapFieldToUpdate] = [];
      courseMap[courseMapFieldToUpdate].add({"username": username, "uid": uid});
      await FirebaseFirestore.instance
          .collection("adminconsole")
          .doc("allcourses")
          .collection("allCourseItems")
          .doc(courseName)
          .set(courseMap);
    }
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
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // ensure the app has a user entry for this account
    UserDataGetterMaster.ensureUserDataExists(
        FirebaseAuth.instance.currentUser);
  }

  static Future<void> logout() async {
    // sign the Firebase account out of the Firebase app
    await FirebaseAuth.instance.signOut();
    // sign the Google account out of the underlying GCP app
    await GoogleSignIn().signOut();
  }
}
