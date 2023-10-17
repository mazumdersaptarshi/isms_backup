import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/userManagement/customUserProvider.dart';

setUserCourseStarted(
    {required CustomUserProvider customUserProvider,
    required Map<String, dynamic> courseDetails}) async {
  bool flag = false;
  if (customUserProvider.loggedInUser!.courses_started.isNotEmpty) {
    customUserProvider.loggedInUser!.courses_started.forEach((course) {
      try {
        if (course['courseID'] == courseDetails['courseID']) {
          flag = true;
        }
      } catch (e) {}
    });
  }
  if (flag == false) {
    customUserProvider.setUserCourseStarted(courseDetails);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: customUserProvider.loggedInUser!.username)
        .get();

    var uid = querySnapshot.docs.first.id;
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(customUserProvider.loggedInUser!.toMap());
  }
}

setUserCourseCompleted(
    {required CustomUserProvider customUserProvider,
    required Map<String, dynamic> courseDetails}) async {
  bool flag = false;
  if (customUserProvider.loggedInUser!.courses_completed.isNotEmpty) {
    customUserProvider.loggedInUser!.courses_completed.forEach((course) {
      try {
        if (course['courseID'] == courseDetails['courseID']) {
          flag = true;
        }
      } catch (e) {}
    });
  }
  if (flag == false) {
    customUserProvider.setUserCourseCompleted(courseDetails);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: customUserProvider.loggedInUser!.username)
        .get();

    var uid = querySnapshot.docs.first.id;
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(customUserProvider.loggedInUser!.toMap());
  }
}

setUserCourseModuleCompleted(
    {required CustomUserProvider customUserProvider,
    required Map<String, dynamic> courseDetails,
    required CoursesProvider coursesProvider,
    required int courseIndex,
    required int moduleIndex}) async {
  bool flag = false;
  if (customUserProvider.loggedInUser!.courses_started.isNotEmpty) {
    customUserProvider.loggedInUser!.courses_started.forEach((course) {
      try {
        if (course['courseID'] == courseDetails['courseID']) {
          courseDetails['modules_completed'].forEach((element) {
            if (element ==
                coursesProvider
                    .allCourses[courseIndex].modules![moduleIndex].title) {
              flag = true;
            }
          });
        }
      } catch (e) {}
    });
  }
  if (flag == false) {
    customUserProvider.setUserCourseModuleCompleted(
        courseDetails: courseDetails,
        coursesProvider: coursesProvider,
        courseIndex: courseIndex,
        moduleIndex: moduleIndex);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: customUserProvider.loggedInUser!.username)
        .get();

    var uid = querySnapshot.docs.first.id;
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(customUserProvider.loggedInUser!.toMap());
  }
}
