import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';
import 'package:isms/models/course.dart';

Future<bool> createCourse({required Course course}) async {
  try {
    Map<String, dynamic> courseMap = course.toMap();

    courseMap['createdAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .set(courseMap);

    print("Course creation successful");
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> createCourseAdminConsole(
    {required CoursesDetails coursesDetails}) async {
  try {
    Map<String, dynamic> courseMap = coursesDetails.toMap();

    courseMap['createdAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allcourses')
        .collection("allCourseItems")
        .doc(coursesDetails.course_name)
        .set(courseMap);

    print("Course creation successful");
    return true;
  } catch (e) {
    return false;
  }
}