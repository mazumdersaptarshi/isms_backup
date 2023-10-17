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

    DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
        .collection("adminconsole")
        .doc("allcourses")
        .collection("allCourseItems")
        .doc(courseDetails["course_name"])
        .get();

    if (courseSnapshot.exists) {
      Map<String, dynamic> courseMap =
          courseSnapshot.data() as Map<String, dynamic>;

      if (courseMap["course_started"] == null) courseMap["course_started"] = [];
      courseMap["course_started"]
          .add({"username": customUserProvider.loggedInUser!.username});

      await FirebaseFirestore.instance
          .collection("adminconsole")
          .doc("allcourses")
          .collection("allCourseItems")
          .doc(courseDetails["course_name"])
          .set(courseMap);
    }
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

    DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
        .collection("adminconsole")
        .doc("allcourses")
        .collection("allCourseItems")
        .doc(courseDetails["course_name"])
        .get();

    if (courseSnapshot.exists) {
      Map<String, dynamic> courseMap =
          courseSnapshot.data() as Map<String, dynamic>;

      if (courseMap["course_completed"] == null)
        courseMap["course_completed"] = [];
      courseMap["course_completed"]
          .add({"username": customUserProvider.loggedInUser!.username});

      await FirebaseFirestore.instance
          .collection("adminconsole")
          .doc("allcourses")
          .collection("allCourseItems")
          .doc(courseDetails["course_name"])
          .set(courseMap);
    }
  }
}
