import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/customUser.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

import '../models/course.dart';
import '../models/userCoursesDetails.dart';
import '../projectModules/courseManagement/coursesProvider.dart';

class LoggedInUserProvider with ChangeNotifier {
  late String userUID = '';
  // CustomUser? loggedInUser;
  bool isUserInfoUpdated = false;
  List<CustomUser> users = []; // Main list should remain immutable

  static List<dynamic> allEnrolledCoursesGlobal =
      []; //Global List to hold all enrolled courses for User

  static List<dynamic> allCompletedCoursesGlobal =
      []; //Global List to hold all completed courses for User

  CustomUser? get getCurrentUser => userDataGetterMaster.loggedInUser;
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  //Getter function for all course related info from users collection, for the logged in User
  //Basically populates the two static global variables allEnrolledCoursesGlobal and allCompletedCoursesGlobal
  Future<List> getUserCoursesData(String? actionId) async {
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

  setUserCourseStarted(Map<String, dynamic> courseDetails) {
    // loggedInUser?.courses_started.add(courseDetails);
    userDataGetterMaster.loggedInUser?.courses_started.add(courseDetails);
    notifyListeners();
  }

  setUserCourseCompleted(Map<String, dynamic> courseDetails) {
    // loggedInUser?.courses_completed.add(courseDetails);
    userDataGetterMaster.loggedInUser?.courses_completed.add(courseDetails);
    notifyListeners();
  }

  setUserCourseExamCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required int courseIndex,
      required int examIndex}) {
    examIndex--;
    Course course = coursesProvider.allCourses[courseIndex];
    // loggedInUser?.courses_started.forEach((course_started) {
    userDataGetterMaster.loggedInUser?.courses_started
        .forEach((course_started) {
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
    print(userDataGetterMaster.loggedInUser!.courses_started);
    notifyListeners();
  }

  setUserCourseModuleCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required int courseIndex,
      required int moduleIndex}) {
    Course course = coursesProvider.allCourses[courseIndex];
    // loggedInUser?.courses_started.forEach((course_started) {
    userDataGetterMaster.loggedInUser?.courses_started
        .forEach((course_started) {
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
    print(userDataGetterMaster.loggedInUser!.courses_started);
    notifyListeners();
  }
}
