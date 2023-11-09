// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/course.dart';
import '../models/customUser.dart';
import '../models/module.dart';
import '../models/userCoursesDetails.dart';
import '../projectModules/courseManagement/coursesProvider.dart';

import 'package:isms/adminManagement/createUserReferenceForAdmin.dart';

/// This class handles user connections
/// It extends the private class _UserDataGetterMaster so all
/// connections to user data are done with an authentified customer

class LoggedInState extends _UserDataGetterMaster {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Constructor of the class LoggedInState.
  /// This constructor checks if the user is connected
  /// If the user is not connected the user data in memory are cleared and the
  /// user is sent back to the connection screen by a signal sent to the home
  /// page
  /// Input : None
  LoggedInState() {
    // for testing purposes
    //_auth.setPersistence(Persistence.NONE);
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint(
            "auth state changed: no account currently signed into Firebase");
        clear();
      } else {
        debugPrint(
            "auth state changed: ${user.email} currently signed into Firebase");
        _fetchFromFirestore(user).then((value) {
          storeUserCoursesData(currentUserSnapshot!);
        });
      }
      notifyListeners();
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

  static Future<void> createUserData(CustomUser customUser) async {
    Map<String, dynamic> userJson = customUser.toMap();
    debugPrint("creating the user $userJson");
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
    _currentUser = user;
    _userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot userSnapshot = await _userRef!.get();
    if (userSnapshot.exists) {
      debugPrint('data fetched from Firestore for user ${user.email}');
      _currentUserSnapshot = userSnapshot;
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      _customUserObject = CustomUser.fromMap(userData!);

      // last step: set _currentUser, so the app knows that it is signed
      // in and can now access user data
    } else {
      debugPrint('user ${user.email} not found in Firestore');
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
        debugPrint('user document was modified: storing new content');
        storeUserCoursesData(snapshot);
        notifyListeners();
      } else {
        debugPrint('user document was deleted');
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
      allEnrolledCoursesGlobal = data.courses_started!;
      allCompletedCoursesGlobal = data.courses_completed!;
    } else {
      debugPrint('user document was deleted');
    }
  }

  //Getter function for all course related info from users collection, for the logged in User
  //Basically populates the two static global variables allEnrolledCoursesGlobal and allCompletedCoursesGlobal
  Future<void> refreshUserCoursesData() async {
    debugPrint("Fetching fresh data");

    DocumentSnapshot? newCurrentUserDocumentSnapshot =
        await newCurrentUserSnapshot;

    storeUserCoursesData(newCurrentUserDocumentSnapshot!);
    debugPrint('890io: $allEnrolledCoursesGlobal');
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
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            flag = true;
          }
        } catch (e) {
          log(e.toString());
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
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            flag = true;
          }
        } catch (e) {
          log(e.toString());
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
    int noOfExamsCompleted = 0;
    bool flag = false;
    debugPrint('rdcf: $loggedInUser');
    if (loggedInUser.courses_started.isNotEmpty) {
      for (var course in loggedInUser.courses_started) {
        try {
          if (course['course_name'] == courseDetails['course_name']) {
            course['exams_completed'].forEach((examCompleted) {
              noOfExamsCompleted++;
              debugPrint(
                  "INCREMENTING noOfExamsCompleted: $noOfExamsCompleted");
              if (examCompleted == examIndex) {
                flag = true;
              }
            });
          }
        } catch (e) {
          log(e.toString());
        }
      }
    }
    if (flag == false) {
      examIndex--;

      for (var courseStarted in loggedInUser.courses_started) {
        if (courseStarted['courseID'] == course.id) {
          if (courseStarted['exams_completed'] != null &&
              courseStarted['exams_completed'].isEmpty) {
            courseStarted['exams_completed'].add(course.exams[examIndex].index);
            debugPrint(
                "COMPLETED EXAM was empty ${courseStarted['exams_completed']}");
          } else if (courseStarted['exams_completed'] != null) {
            bool isExamPresentInList = false;
            for (int i = 0; i < courseStarted['exams_completed'].length; i++) {
              var element = courseStarted['exams_completed'][i];
              if (element == course.exams[examIndex].index) {
                isExamPresentInList = true;
              }
            }
            if (isExamPresentInList == false) {
              courseStarted['exams_completed']
                  .add(course.exams[examIndex].index);
              debugPrint("ADDING EXAM ${course.exams[examIndex].index}");
              debugPrint("COMPLETED EXAM ${courseStarted['exams_completed']}");
            }
          } else {
            debugPrint("COMPLETED MODULE IS NULL< SO HERE");
            courseStarted['exams_completed'] = [];
            courseStarted['exams_completed'].add(course.exams[examIndex].index);
          }
        }
      }
      if (kDebugMode) {
        print(loggedInUser.courses_started);
      }
      noOfExamsCompleted++;
      await setUserData();
    }
    int noOfExams = course.exams.length;
    debugPrint("noOfExamsCompleted $noOfExamsCompleted,, $noOfExams");
    // if (noOfExamsCompleted >= noOfExams) {
    //   await setUserCourseCompleted(courseDetails: courseDetails);
    // }
    notifyListeners();
    return noOfExamsCompleted >= noOfExams;
  }

  setUserCourseModuleCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required Module module}) async {
    bool flag = false;
    if (loggedInUser.courses_started.isNotEmpty) {
      for (var course in loggedInUser.courses_started) {
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            course["modules_completed"].forEach((element) async {
              if (element["module_name"] == module.title) {
                debugPrint("SETTING FLAG TRUE coz $element");
                flag = true;
                await setUserData();
              }
            });
          }
        } catch (e) {
          log(e.toString());
        }
      }
    }
    if (flag == false) {
      for (var courseStarted in loggedInUser.courses_started) {
        if (courseStarted['courseID'] == course.id) {
          bool flag = false;
          if (courseStarted['modules_completed'] != null) {
            for (int i = 0;
                i < courseStarted['modules_completed'].length;
                i++) {
              var element = courseStarted['modules_completed'][i];
              if (element == module.title) {
                flag = true;
              }
            }
            if (flag == false) {
              courseStarted['modules_completed']
                  .add({"module_name": module.title, "module_id": module.id});
            }
          } else {
            debugPrint("COMPLETED MODULE IS NULL< SO HERE");
            courseStarted['modules_completed'] = [];
            courseStarted['modules_completed']
                .add({"module_name": module.title, "module_id": module.id});
          }
        }
      }
      if (kDebugMode) {
        print(loggedInUser.courses_started);
      }
      await setUserData();
    }
    notifyListeners();
  }

  setUserCourseModuleStarted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required Module module}) async {
    bool flag = false;
    if (loggedInUser.courses_started.isNotEmpty) {
      for (Map<String, dynamic> course in loggedInUser.courses_started) {
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            course["modules_started"].forEach((element) {
              if (element == module.title) {
                debugPrint("SETTING FLAG TRUE coz $element");
                flag = true;
              }
            });
          }
        } catch (e) {
          log(e.toString());
        }
      }
    }
    if (flag == false) {
      debugPrint("FLAG IS FALSE $courseDetails");

      for (var courseStarted in loggedInUser.courses_started) {
        if (courseStarted['courseID'] == course.id) {
          debugPrint("STARTED MODULEE ${courseStarted['modules_started']}");
          bool flag_2 = false;
          if (courseStarted['modules_started'] != null) {
            for (int i = 0; i < courseStarted['modules_started'].length; i++) {
              String element = courseStarted['modules_started'][i];
              if (element == module.title) {
                flag_2 = true;
              }
            }
            if (flag_2 == false) {
              courseStarted['modules_started']
                  .add({"module_name": module.title});
            }
          } else {
            debugPrint("COMPLETED MODULE IS NULL< SO HERE");
            courseStarted['modules_started'] = [];
            courseStarted['modules_started'].add({"module_name": module.title});
          }
        }
      }
      if (kDebugMode) {
        print(loggedInUser.courses_started);
      }
      await setUserData();
    }
    notifyListeners();
  }

  setUserModuleExamCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required Module module,
      required int examIndex}) async {
    if (loggedInUser.courses_started.isNotEmpty) {
      Map<String, dynamic> courseStarted;

      for (int i = 0; i < loggedInUser.courses_started.length; i++) {
        courseStarted = loggedInUser.courses_started[i];
        try {
          if (courseStarted['courseID'] == courseDetails['courseID']) {
            courseStarted["modules_started"].forEach((courseModule) {
              if (courseModule["module_name"] == module.title) {
                if (courseStarted["modules_started"] != null) {
                  //int moduleStartedIndex = 0;
                  courseStarted["modules_started"]
                      .forEach((startedModule) async {
                    startedModule = startedModule as Map<String, dynamic>;

                    if (startedModule["module_name"] == module.title) {
                      bool examFlag = false;

                      if (startedModule["exams_completed"] == null) {
                        startedModule = {
                          ...startedModule,
                          ...{"exams_completed": []}
                        };
                      }

                      startedModule["exams_completed"].forEach((examCompleted) {
                        if (examCompleted == examIndex) examFlag = true;
                        debugPrint(
                            "PPPPRINTTT ${startedModule["exams_completed"].length},,${module.exams?.length} ");
                      });

                      if (examFlag == false) {
                        startedModule["exams_completed"].add(examIndex);

                        List modulesStartedCopy = List.from(
                            loggedInUser.courses_started[i]["modules_started"]);
                        int modulesStartedIndex = 0;
                        for (var m in modulesStartedCopy) {
                          if (m["module_name"] ==
                              startedModule["module_name"]) {
                            m = startedModule;
                            loggedInUser.courses_started[i]["modules_started"]
                                [modulesStartedIndex] = m;
                            debugPrint("MMMMMMMM $m");
                          }
                          modulesStartedIndex++;
                        }
                      }
                      await setUserData();
                      if (startedModule["exams_completed"].length >=
                          module.exams?.length) {
                        await setUserCourseModuleCompleted(
                            courseDetails: courseDetails,
                            coursesProvider: coursesProvider,
                            course: course,
                            module: module);
                      } else {
                        debugPrint("PRINT BEFORE SET $courseStarted");
                      }
                    }
                    //moduleStartedIndex++;
                  });
                } else {
                  courseStarted["modules_started"] = [];
                }
              }
            });
          }
        } catch (e) {
          log(e.toString());
        }
      }
    }

    notifyListeners();
  }

  setAdminConsoleCourseMap(
      {required String courseName,
      required String username,
      required String uid,
      required String courseMapFieldToUpdate}) async {
    debugPrint("ENTERED setAdminConsoleCourseMap");
    DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
        .collection("adminconsole")
        .doc("allcourses")
        .collection("allCourseItems")
        .doc(courseName)
        .get();
    if (courseSnapshot.exists) {
      Map<String, dynamic> courseMap =
          courseSnapshot.data() as Map<String, dynamic>;
      if (courseMap[courseMapFieldToUpdate] == null) {
        courseMap[courseMapFieldToUpdate] = [];
      }
      courseMap[courseMapFieldToUpdate].add({"username": username, "uid": uid});
      await FirebaseFirestore.instance
          .collection("adminconsole")
          .doc("allcourses")
          .collection("allCourseItems")
          .doc(courseName)
          .set(courseMap);
    }
  }
}
