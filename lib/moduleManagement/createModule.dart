import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';

Future<bool> createModule(
    {required CoursesProvider coursesProvider,
    required int courseIndex,
    required Module module}) async {
  try {
    Course course = coursesProvider.allCourses[courseIndex];
    Map<String, dynamic> moduleMap = module.toMap();

    moduleMap['createdAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection("modules")
        .doc(module.title)
        .set(moduleMap);

    coursesProvider.addModulesToCourse(courseIndex, [module]);
    print("Module creation successful");
    return true;
  } catch (e) {
    return false;
  }
}
