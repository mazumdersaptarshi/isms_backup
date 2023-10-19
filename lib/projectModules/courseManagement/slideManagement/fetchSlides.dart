import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';

import '../coursesProvider.dart';

Future fetchSlides(
    {required CoursesProvider coursesProvider,
    required int courseIndex,
    required int moduleIndex}) async {
  Course course = coursesProvider.allCourses[courseIndex];
  Module module = course.modules![moduleIndex];
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
        .orderBy("index")
        .get();
    List<Slide> slides = [];
    if (slidesListSnapshot.size == 0) return;
    slidesListSnapshot.docs.forEach((element) {
      Slide s = Slide.fromMap(element.data() as Map<String, dynamic>);

      slides.add(s);
    });
    coursesProvider.addSlidesToModules(courseIndex, moduleIndex, slides);
    print("FCN Slides for ${module.slides}, slides: ${module.slides}");
  }
}
