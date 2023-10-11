import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';

Future fetchSlides({required Course course, required Module module}) async {
  if (module.slides != null && module.slides!.isNotEmpty) {
    print("Slides for $module already fetched! See ${module.slides}");
    return;
  } else {
    QuerySnapshot slidesListSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection('modules')
        .doc(module.title)
        .collection("slides")
        .get();
    course.modules = [];
    slidesListSnapshot.docs.forEach((element) {
      // print(element.data());
      Slide s = Slide.fromMap(element.data() as Map<String, dynamic>);
      // print("${m.title}, ${m.contentDescription}");
      if (module.slides == null) module.slides = [];
      module.slides?.add(s);
    });
    print("FCN Slides for ${module.slides}, slides: ${module.slides}");
  }
}
