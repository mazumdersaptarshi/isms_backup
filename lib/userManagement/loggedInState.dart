import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

import '../models/course.dart';
import '../models/customUser.dart';
import '../models/module.dart';
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
  bool _hasnewData = false;
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
  DocumentSnapshot? get currentUserSnapshot =>
      _userDataGetterMaster.currentUserSnapshot;
  Future<DocumentSnapshot<Object?>?>
      get getNewCurrentUserDocumentSnapshot async =>
          await _userDataGetterMaster.newCurrentUserSnapshot;

  void listenToChanges() {
    currentUserDocumentReference?.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        _hasnewData = true;
        notifyListeners();
      } else {
        print('No existing document');
      }
    });
  }

  //Getter function for all course related info from users collection, for the logged in User
  //Basically populates the two static global variables allEnrolledCoursesGlobal and allCompletedCoursesGlobal
  Future<List> getUserCoursesData(String? actionId) async {
    print('Current value of authStateChanged: $authStateChanged');
    print('Current value of _hasnewData: $_hasnewData');
    bool isRefreshAction = false;
    if (actionId == 'ref') isRefreshAction = true;

    if (authStateChanged || _hasnewData || isRefreshAction) {
      print(
          "Fetching fresh data because authStateChanged = $authStateChanged and _hasnewData = $_hasnewData");

      print('Inside fetch courses user provider ${currentUserUid}');
      try {
        DocumentSnapshot? newCurrentUserDocumentSnapshot =
            await getNewCurrentUserDocumentSnapshot;

        if (newCurrentUserDocumentSnapshot!.exists) {
          Map<String, dynamic> mapdata =
              newCurrentUserDocumentSnapshot.data() as Map<String, dynamic>;
          UserCoursesDetails data = UserCoursesDetails.fromMap(mapdata);
          // Access specific fields from the document

          print('Field 1: ${data.courses_started}');
          allEnrolledCoursesGlobal = data.courses_started!;
          allCompletedCoursesGlobal = data.courses_completed!;
        } else {
          print('Document does not exist');
        }
        print('890io: ${allEnrolledCoursesGlobal}');
        if (actionId == 'crs_enrl') {
          authStateChanged = false;
          _hasnewData = false;

          print('changes detected, fetching new data');
          return allEnrolledCoursesGlobal;
        } else if (actionId == 'crs_compl') {
          authStateChanged = false;
          _hasnewData = false;

          print('changes detected, fetching new data');
          return allCompletedCoursesGlobal;
        }
      } catch (e) {
        return [];
      }
    }
    print(
        "Using cached data because authStateChanged = $authStateChanged and _hasnewData = $_hasnewData");

    print('No chnages detected, fetching cached data');
    if (actionId == 'crs_enrl') {
      return allEnrolledCoursesGlobal;
    }
    if (actionId == 'crs_enrl') {
      return allCompletedCoursesGlobal;
    }
    return [];
  }

  setUserCourseStarted({required Map<String, dynamic> courseDetails}) async {
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
      await _userDataGetterMaster.setUserData();
      await setAdminConsoleCourseMap(
          courseName: courseDetails["course_name"],
          courseMapFieldToUpdate: "course_started",
          username: loggedInUser!.username,
          uid: loggedInUser!.uid!);
    }
    notifyListeners();
  }

  setUserCourseCompleted({required Map<String, dynamic> courseDetails}) async {
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
      await _userDataGetterMaster.setUserData();
      await setAdminConsoleCourseMap(
          courseName: courseDetails["course_name"],
          courseMapFieldToUpdate: "course_completed",
          username: loggedInUser!.username,
          uid: loggedInUser!.uid!);
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
      await _userDataGetterMaster.setUserData();
    }
    int noOfExams = course.exams!.length;
    print("noOfExamsCompleted ${noOfExamsCompleted},, ${noOfExams}");
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
    print("HERRRRRRRRRRREEEEEEE");
    if (loggedInUser!.courses_started.isNotEmpty) {
      loggedInUser!.courses_started.forEach((course) {
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            course["modules_completed"].forEach((element) async {
              if (element["module_name"] == module.title) {
                print("SETTING FLAG TRUE coz ${element}");
                flag = true;
                await _userDataGetterMaster.setUserData();
              }
            });
          }
        } catch (e) {}
      });
    }
    if (flag == false) {
      _userDataGetterMaster.loggedInUser?.courses_started
          .forEach((course_started) {
        if (course_started['courseID'] == course.id) {
          bool flag = false;
          if (course_started['modules_completed'] != null) {
            for (int i = 0;
                i < course_started['modules_completed'].length;
                i++) {
              var element = course_started['modules_completed'][i];
              if (element == module.title) {
                flag = true;
              }
            }
            if (flag == false) {
              course_started['modules_completed']
                  .add({"module_name": module.title, "module_id": module.id});
            }
          } else {
            print("COMPLETED MODULE IS NULL< SO HERE");
            course_started['modules_completed'] = [];
            course_started['modules_completed']
                .add({"module_name": module.title, "module_id": module.id});
          }
        }
      });
      print(_userDataGetterMaster.loggedInUser!.courses_started);
      await _userDataGetterMaster.setUserData();
    }
    notifyListeners();
  }

  setUserCourseModuleStarted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required Module module}) async {
    bool flag = false;
    if (loggedInUser!.courses_started.isNotEmpty) {
      loggedInUser!.courses_started.forEach((course) {
        try {
          if (course['courseID'] == courseDetails['courseID']) {
            course["modules_started"].forEach((element) {
              if (element["module_name"] == module.title) {
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

      _userDataGetterMaster.loggedInUser?.courses_started
          .forEach((course_started) {
        if (course_started['courseID'] == course.id) {
          print("STARTED MODULEE ${course_started['modules_started']}");
          bool flag_2 = false;
          if (course_started['modules_started'] != null) {
            for (int i = 0; i < course_started['modules_started'].length; i++) {
              var element = course_started['modules_started'][i];
              if (element["module_name"] == module.title) {
                flag_2 = true;
              }
            }
            if (flag_2 == false) {
              course_started['modules_started']
                  .add({"module_name": module.title});
            }
          } else {
            print("COMPLETED MODULE IS NULL< SO HERE");
            course_started['modules_started'] = [];
            course_started['modules_started']
                .add({"module_name": module.title});
          }
        }
      });
      print(_userDataGetterMaster.loggedInUser!.courses_started);
      await _userDataGetterMaster.setUserData();
    }
    notifyListeners();
  }

  setUserModuleExamCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required Course course,
      required Module module,
      required int examIndex}) async {
    if (loggedInUser!.courses_started.isNotEmpty) {
      var course_started;

      for (int i = 0; i < loggedInUser!.courses_started.length; i++) {
        course_started = loggedInUser!.courses_started[i];
        try {
          if (course_started['courseID'] == courseDetails['courseID']) {
            course_started["modules_started"].forEach((course_module) {
              if (course_module["module_name"] == module.title) {
                if (course_started["modules_started"] != null) {
                  int moduleStartedIndex = 0;
                  course_started["modules_started"]
                      .forEach((started_module) async {
                    started_module = started_module as Map<String, dynamic>;

                    if (started_module["module_name"] == module.title) {
                      bool examFlag = false;

                      if (started_module["exams_completed"] == null) {
                        started_module = {
                          ...started_module,
                          ...{"exams_completed": []}
                        };
                      }

                      started_module["exams_completed"]
                          .forEach((exam_completed) {
                        if (exam_completed == examIndex) examFlag = true;
                        print(
                            "PPPPRINTTT ${started_module["exams_completed"].length},,${module.exams?.length} ");
                      });

                      if (examFlag == false) {
                        started_module["exams_completed"].add(examIndex);

                        List modules_started_copy = List.from(loggedInUser!
                            .courses_started[i]["modules_started"]);
                        int modules_started_index = 0;
                        modules_started_copy.forEach((m) {
                          if (m["module_name"] ==
                              started_module["module_name"]) {
                            m = started_module;
                            loggedInUser!.courses_started[i]["modules_started"]
                                [modules_started_index] = m;
                            print("MMMMMMMM ${m}");
                          }
                          modules_started_index++;
                        });
                      }
                      await _userDataGetterMaster.setUserData();
                      if (started_module["exams_completed"].length >=
                          module.exams?.length) {
                        await setUserCourseModuleCompleted(
                            courseDetails: courseDetails,
                            coursesProvider: coursesProvider,
                            course: course,
                            module: module);
                      } else
                        print("PRINT BEFORE SET ${course_started}");
                    }
                    moduleStartedIndex++;
                  });
                } else
                  course_started["modules_started"] = [];
              }
            });
          }
        } catch (e) {}
      }
    }

    notifyListeners();
  }

  setAdminConsoleCourseMap(
      {required String courseName,
      required String username,
      required String uid,
      required String courseMapFieldToUpdate}) async {
    print("ENTERED setAdminConsoleCourseMap");
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
}
