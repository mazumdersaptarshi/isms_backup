import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/userManagement/customUserProvider.dart';

import '../models/module.dart';

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
          course["modules_completed"].forEach((element) {
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
    print("FLAG IS FALSE ${courseDetails['modules_completed']}");
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

  updateAdminConsoleCourses(
      coursesProvider: coursesProvider,
      moduleIndex: moduleIndex,
      courseIndex: courseIndex,
      courseDetails: courseDetails,
      customUserProvider: customUserProvider);
}

Future updateAdminConsoleCourses(
    {required CustomUserProvider customUserProvider,
    required Map<String, dynamic> courseDetails,
    required CoursesProvider coursesProvider,
    required int courseIndex,
    required int moduleIndex}) async {
  DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
      .collection("adminconsole")
      .doc("allcourses")
      .collection("allCourseItems")
      .doc(courseDetails["course_name"])
      .get();

  String loggedInUser = customUserProvider.loggedInUser!.username;
  Module module = coursesProvider.allCourses[courseIndex].modules![moduleIndex];
  if (courseSnapshot.exists) {
    Map<String, dynamic> courseMap =
        courseSnapshot.data() as Map<String, dynamic>;

    if (courseMap["course_started"] == null ||
        courseMap["course_started"].isEmpty) {
      courseMap["course_started"] = [];

      List modulesCompleted = [];
      customUserProvider.loggedInUser!.courses_started.forEach((element) {
        if (element["course_name"] == courseDetails["course_name"]) {
          modulesCompleted = element["modules_completed"];
        }
      });

      courseMap["course_started"].add(
          {"username": loggedInUser, "modules_completed": modulesCompleted});
    }
    // course_started is null

    else {
      // for loop
      for (int i = 0; i < courseMap["course_started"].length; i++) {
        if (courseMap["course_started"][i]['username'] == loggedInUser) {
          // if user exists in course_started
          if (courseMap["course_started"][i]["modules_completed"] == null) {
            // if user modules_completed is null
            courseMap["course_started"][i]["modules_completed"] = [];

            courseMap["course_started"][i]["modules_completed"]
                .add(module.title);
          } else if (courseMap["course_started"][i]["modules_completed"] !=
              null) {
            // if user modules_completed is not null

            List tempModulesCompleted = [
              ...courseMap["course_started"][i]["modules_completed"]
            ];

            bool isModulePresent = false;
            for (int k = 0; k < tempModulesCompleted.length; k++) {
              if (tempModulesCompleted[k] == module.title) {
                isModulePresent = true;
              }
            }
            if (isModulePresent == false) {
              courseMap["course_started"][i]["modules_completed"]
                  .add(module.title);
            }
            print(
                "WE ARE HERE ${courseMap["course_started"][i]["modules_completed"]}");
          }
        } else {
          courseMap["course_started"][i]["modules_completed"] = [
            {
              "username": loggedInUser,
              "modules_completed": [module.title]
            }
          ];
        }
      }
    }

    await FirebaseFirestore.instance
        .collection("adminconsole")
        .doc("allcourses")
        .collection("allCourseItems")
        .doc(courseDetails["course_name"])
        .set(courseMap);
  }
}
