import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';

import '../coursesProvider.dart';

Future fetchModules(
    {required int courseIndex,
    required CoursesProvider coursesProvider}) async {
  Course course = coursesProvider.allCourses[courseIndex];
  if (course.modules != null && course.modules!.isNotEmpty) {
    // print("Modules for $course already fetched! See ${course.modules}");
    return;
  } else {
    QuerySnapshot modulesListSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection('modules')
        .orderBy("index")
        .get();
    course.modules = [];
    modulesListSnapshot.docs.forEach((element) {
      // print(element.data());
      Module m = Module.fromMap(element.data() as Map<String, dynamic>);
      // print("${m.title}, ${m.contentDescription}");

      course.modules?.add(m);
    });
    coursesProvider.addModulesToCourse(courseIndex, course.modules!);
    print("FCN Courses ${course.hashCode}, has modules: ${course.modules}");
  }
}
