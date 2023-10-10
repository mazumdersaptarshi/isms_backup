import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';

Future fetchModules({required Course course}) async {
  if (course.modules != null && course.modules!.isNotEmpty) {
    print("Modules for $course already fetched! See ${course.modules}");
    return;
  } else {
    QuerySnapshot modulesListSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection('modules')
        .get();
    course.modules = [];
    modulesListSnapshot.docs.forEach((element) {
      // print(element.data());
      Module m = Module.fromMap(element.data() as Map<String, dynamic>);
      // print("${m.title}, ${m.contentDescription}");

      course.modules?.add(m);
      print("FCN Courses ${course.hashCode}, ${course.modules}");
    });
  }
}
