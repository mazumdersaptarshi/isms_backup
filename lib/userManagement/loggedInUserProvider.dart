import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/customUser.dart';
import 'package:isms/userManagement/createUser.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

import '../models/course.dart';
import '../models/userCoursesDetails.dart';
import '../projectModules/courseManagement/coursesProvider.dart';

class LoggedInUserProvider with ChangeNotifier {
  final _dbUserOperations = CreateUserDataOperations();
  late String userUID = '';
  CustomUser? loggedInUser;
  bool isUserInfoUpdated = false;
  List<CustomUser> users = []; // Main list should remain immutable

  static List<dynamic> allEnrolledCoursesGlobal =
      []; //Global List to hold all enrolled courses for User

  static List<dynamic> allCompletedCoursesGlobal =
      []; //Global List to hold all completed courses for User

  CustomUser? get getCurrentUser => loggedInUser;
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  LoggedInUserProvider() {
    print('InsideLoggedInUserProviderInvoke');
    fetchUserDetails();
    fetchAllCoursesUser();
    notifyListeners();
  }

  void setLoggedInUser(CustomUser user) {
    loggedInUser = user;
    userUID = loggedInUser!.uid!;
    print("SETTING LOGGEED IN USER ${loggedInUser},, $userUID");
    isUserInfoUpdated = false;
    notifyListeners();
  }

  Future<void> createUser(CustomUser user) async {
    String? uid = userDataGetterMaster.currentUser?.uid;
    if (uid != null) {
      await _dbUserOperations.createUser(uid, user);
    } else {
      print('No authenticated user.');
    }
  }

  Future<String?> fetchCurrentUsername() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    // String? email = userDataGetterMaster.currentUserEmail;
    if (email == null) {
      print('No authenticated user.');
      return null;
    }

    // Query the 'users' collection where 'email' field matches the authenticated user's email.
    QuerySnapshot userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // Check if a document was found.
    if (userDocs.docs.isNotEmpty) {
      Map<String, dynamic> data =
          userDocs.docs.first.data() as Map<String, dynamic>;
      return data['username'] as String?;
    } else {
      print('No matching user document found for email $email.');
      return null;
    }
  }

  Future<String?> fetchCurrentUserEmail() async {
    return FirebaseAuth.instance.currentUser?.email;
  }

  Future<List<CustomUser>> fetchUsers() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _dbUserOperations.fetchAllUsers();

      users = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        var data = doc.data();
        data["uid"] = doc.id;
        return CustomUser.fromMap(data);
      }).toList();
      notifyListeners();
      return users;
    } catch (e) {
      // Handle any errors that might occur during the fetching process
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  bool findUserByEmail(String userEmail) {
    return users.any((user) => user.email == userEmail);
  }

  CustomUser getUserByEmail(String userEmail) {
    CustomUser userFound;
    userFound = users.firstWhere((user) => user.email == userEmail);
    return userFound;
  }

  Future<CustomUser?> fetchUserDetails() async {
    print('fetchingUserDetails');
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    userUID = uid!;
    print(userUID);
    if (uid == null) {
      print('No authenticated user.');
      return null;
    }

    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      var docData = userDoc.data()!;
      docData["uid"] = userDoc.id;
      return CustomUser.fromMap(docData);
    } else {
      print('No matching user document found for UID $uid.');
      return null;
    }
  }

  setUserCourseStarted(Map<String, dynamic> courseDetails) {
    loggedInUser?.courses_started.add(courseDetails);
    notifyListeners();
  }

  fetchAllCoursesUser({bool isNotifyListener = true}) async {
    List<dynamic>? allEnrolledCoursesLocal = [];
    List<dynamic>? allCompletedCoursesLocal = [];
    UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
    print('Inside fetch courses user provider');

    Stream<DocumentSnapshot>? userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userDataGetterMaster.currentUserUid)
        .snapshots();
    // userStream = userDataGetterMaster.currentUserSnapshot
    //     as Stream<DocumentSnapshot<Object?>>?;
    print('userStream:  ${userStream}');
    userStream?.listen((snapshot) async {
      print('snapshotData: ${snapshot.data()}');
      UserCoursesDetails data =
          UserCoursesDetails.fromMap(snapshot.data() as Map<String, dynamic>);

      allEnrolledCoursesLocal = data.courses_started;

      allCompletedCoursesLocal = data.courses_completed;

      allEnrolledCoursesGlobal.clear();

      allEnrolledCoursesGlobal = allEnrolledCoursesLocal!;
      allCompletedCoursesGlobal = allCompletedCoursesLocal!;
      print('allEnrolledCoursesGlobal: $allEnrolledCoursesGlobal');
      if (isNotifyListener) notifyListeners();
    });
  }

  //Adding a new function with improved logic
  Future<List> currentUserCoursesGetter(String? actionId) async {
    List<dynamic>? allEnrolledCoursesLocal = [];
    List<dynamic>? allCompletedCoursesLocal = [];
    UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
    print(
        'Inside fetch courses user provider ${userDataGetterMaster.currentUserUid}');
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('${userDataGetterMaster.currentUserUid}')
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> mapdata =
            documentSnapshot.data() as Map<String, dynamic>;
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
        return allEnrolledCoursesGlobal;
      } else if (actionId == 'crs_compl') {
        return allCompletedCoursesGlobal;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  List<dynamic> getAllEnrolledCoursesCurrentUser() {
    List<dynamic>? allEnrolledCoursesLocal = [];
    List<dynamic>? allCompletedCoursesLocal = [];
    print('Inside fetch courses user provider');
    if (userUID != '') {
      Stream<DocumentSnapshot>? userStream = FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .snapshots();
      // userStream = userDataGetterMaster.currentUserSnapshot
      //     as Stream<DocumentSnapshot<Object?>>?;
      print('userStream:  ${userStream}');
      userStream?.listen((snapshot) async {
        print('snapshotData: ${snapshot.data()}');
        UserCoursesDetails data =
            UserCoursesDetails.fromMap(snapshot.data() as Map<String, dynamic>);

        allEnrolledCoursesLocal = data.courses_started;

        allCompletedCoursesLocal = data.courses_completed;

        notifyListeners();
        allEnrolledCoursesGlobal.clear();

        allEnrolledCoursesGlobal = allEnrolledCoursesLocal!;
        allCompletedCoursesGlobal = allCompletedCoursesLocal!;
        print('allEnrolledCoursesGlobal: $allEnrolledCoursesGlobal');
      });
    }
    return allEnrolledCoursesGlobal;
  }

  Future<List> getAllEnrolledCoursesList() async {
    print('entered futurebuilder allEnrolledCoursesGlobal');
    await Future.delayed(Duration(seconds: 2));

    print('function return value allUsersGlobal: $allEnrolledCoursesGlobal');
    return allEnrolledCoursesGlobal;
  }

  Future<List> getAllCompletedCoursesList() async {
    print('entered futurebuilder allCompletedCoursesGlobal');
    await Future.delayed(Duration(seconds: 2));

    print('function return value allUsersGlobal: $allCompletedCoursesGlobal');
    return allCompletedCoursesGlobal;
  }

  setUserCourseCompleted(Map<String, dynamic> courseDetails) {
    loggedInUser?.courses_completed.add(courseDetails);
    notifyListeners();
  }

  setUserCourseExamCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required int courseIndex,
      required int examIndex}) {
    examIndex--;
    Course course = coursesProvider.allCourses[courseIndex];
    loggedInUser?.courses_started.forEach((course_started) {
      if (course_started['courseID'] == course.id) {
        if (course_started['exams_completed'] != null &&
            course_started['exams_completed'].isEmpty) {
          course_started['exams_completed'].add(course.exams![examIndex].index);
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
          course_started['exams_completed'].add(course.exams![examIndex].index);
        }
      }
    });
    print(loggedInUser!.courses_started);
    notifyListeners();
  }

  setUserCourseModuleCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required int courseIndex,
      required int moduleIndex}) {
    Course course = coursesProvider.allCourses[courseIndex];
    loggedInUser?.courses_started.forEach((course_started) {
      if (course_started['courseID'] == course.id) {
        print("COMPLETED MODULEE ${course_started['modules_completed']}");

        if (course_started['modules_completed'] != null) {
          for (int i = 0; i < course_started['modules_completed'].length; i++) {
            var element = course_started['modules_completed'][i];
            if (element != course.modules![moduleIndex].title) {
              course_started['modules_completed']
                  .add(course.modules![moduleIndex].title);
            }
          }
        } else {
          print("COMPLETED MODULE IS NULL< SO HERE");
          course_started['modules_completed'] = [];
          course_started['modules_completed']
              .add(course.modules![moduleIndex].title);
        }
      }
    });
    print(loggedInUser!.courses_started);
    notifyListeners();
  }
}
