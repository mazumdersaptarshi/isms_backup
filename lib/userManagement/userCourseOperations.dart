import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

import '../projectModules/courseManagement/coursesProvider.dart';

setUserCourseStarted(
    {required LoggedInUserProvider customUserProvider,
    required Map<String, dynamic> courseDetails}) async {
  bool flag = false;
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
  if (userDataGetterMaster.loggedInUser!.courses_started.isNotEmpty) {
    userDataGetterMaster.loggedInUser!.courses_started.forEach((course) {
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
        .where("username",
            isEqualTo: userDataGetterMaster.loggedInUser!.username)
        .get();

    var uid = querySnapshot.docs.first.id;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userDataGetterMaster.loggedInUser!.uid)
        .set(userDataGetterMaster.loggedInUser!.toMap());

    setAdminConsoleCourseMap(
        courseName: courseDetails["course_name"],
        courseMapFieldToUpdate: "course_started",
        username: userDataGetterMaster.loggedInUser!.username,
        uid: userDataGetterMaster.loggedInUser!.uid!);
  }
}

setUserCourseCompleted(
    {required LoggedInUserProvider customUserProvider,
    required Map<String, dynamic> courseDetails}) async {
  bool flag = false;
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  if (userDataGetterMaster.loggedInUser!.courses_completed.isNotEmpty) {
    userDataGetterMaster.loggedInUser!.courses_completed.forEach((course) {
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
        .where("username",
            isEqualTo: userDataGetterMaster.loggedInUser!.username)
        .get();

    var uid = querySnapshot.docs.first.id;
    print(
        "MUST SET COURSE COMPLETED ${userDataGetterMaster.loggedInUser!.toMap()} at $uid");
    FirebaseFirestore.instance
        .collection("users")
        .doc(userDataGetterMaster.loggedInUser!.uid)
        .set(userDataGetterMaster.loggedInUser!.toMap());

    setAdminConsoleCourseMap(
        courseName: courseDetails["course_name"],
        courseMapFieldToUpdate: "course_completed",
        username: userDataGetterMaster.loggedInUser!.username,
        uid: userDataGetterMaster.loggedInUser!.uid!);
  }
}

setUserCourseExamCompleted(
    {required CoursesProvider coursesProvider,
    required int courseIndex,
    required LoggedInUserProvider customUserProvider,
    required Map<String, dynamic> courseDetails,
    required int examIndex}) async {
  int noOfExamsCompleted = 0;
  bool flag = false;
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
  print('rdcf: ${userDataGetterMaster.loggedInUser}');
  if (userDataGetterMaster.loggedInUser!.courses_started.isNotEmpty) {
    userDataGetterMaster.loggedInUser!.courses_started.forEach((course) {
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
    customUserProvider.setUserCourseExamCompleted(
      courseDetails: courseDetails,
      coursesProvider: coursesProvider,
      courseIndex: courseIndex,
      examIndex: examIndex,
    );
    noOfExamsCompleted++;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userDataGetterMaster.loggedInUser!.uid)
        .set(userDataGetterMaster.loggedInUser!.toMap());
  }

  int noOfExams = coursesProvider.allCourses[courseIndex].exams!.length;
  print("noOfExamsCompleted ${noOfExamsCompleted},, ${noOfExams}");
  if (noOfExamsCompleted >= noOfExams) {
    setUserCourseCompleted(
        customUserProvider: customUserProvider, courseDetails: courseDetails);
  }
}

setUserCourseModuleCompleted(
    {required LoggedInUserProvider customUserProvider,
    required Map<String, dynamic> courseDetails,
    required CoursesProvider coursesProvider,
    required int courseIndex,
    required int moduleIndex}) async {
  bool flag = false;
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  if (userDataGetterMaster.loggedInUser!.courses_started.isNotEmpty) {
    userDataGetterMaster.loggedInUser!.courses_started.forEach((course) {
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
    customUserProvider.setUserCourseModuleCompleted(
        courseDetails: courseDetails,
        coursesProvider: coursesProvider,
        courseIndex: courseIndex,
        moduleIndex: moduleIndex);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username",
            isEqualTo: userDataGetterMaster.loggedInUser!.username)
        .get();

    var uid = querySnapshot.docs.first.id;

    print(
        "MUST UPDATE COURSE MODULE ${userDataGetterMaster.loggedInUser!.courses_started}");
    FirebaseFirestore.instance
        .collection("users")
        .doc(userDataGetterMaster.loggedInUser!.uid)
        .set(userDataGetterMaster.loggedInUser!.toMap());
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
