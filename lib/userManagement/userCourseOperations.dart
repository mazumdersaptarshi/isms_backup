import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';

import '../projectModules/courseManagement/coursesProvider.dart';

setUserCourseStarted(
    {required LoggedInUserProvider customUserProvider,
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

    setAdminConsoleCourseMap(
        courseName: courseDetails["course_name"],
        courseMapFieldToUpdate: "course_started",
        username: customUserProvider.loggedInUser!.username,
        uid: customUserProvider.loggedInUser!.uid!);
  }
}

setUserCourseCompleted(
    {required LoggedInUserProvider customUserProvider,
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

    setAdminConsoleCourseMap(
        courseName: courseDetails["course_name"],
        courseMapFieldToUpdate: "course_completed",
        username: customUserProvider.loggedInUser!.username,
        uid: customUserProvider.loggedInUser!.uid!);
  }
}

setUserCourseModuleCompleted(
    {required LoggedInUserProvider customUserProvider,
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
