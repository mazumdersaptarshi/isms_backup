import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createSlideScreen.dart';

import '../../coursesProvider.dart';

Future<bool> createSlides(
    {required int courseIndex,
    required int moduleIndex,
    required CoursesProvider coursesProvider,
    required List<Slide> slides}) async {
  Course course = coursesProvider.allCourses[courseIndex];
  Module module = course.modules![moduleIndex];

  List<Map<String, dynamic>> slidesMapList = [];
  int startingIndex = 0;
  try {
    startingIndex = course.modules![moduleIndex].slides!.length;
  } catch (e) {
    startingIndex = 0;
  }

  try {
    slides.forEach((slideItem) {
      startingIndex++;
      slideItem.index = startingIndex;
      Map<String, dynamic> slideMap = slideItem.toMap();
      slideMap['createdAt'] = DateTime.now();
      slidesMapList.add(slideMap);
    });

    slidesMapList.forEach((slideMap) async {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(course.name)
          .collection("modules")
          .doc(module.title)
          .collection('slides')
          .doc(slideMap['id'])
          .set(slideMap);
      print("Created slide ${slideMap}");
    });

    coursesProvider.addSlidesToModules(courseIndex, moduleIndex, slides);
    print("Slides creation successful");
    return true;
  } catch (e) {
    return false;
  }
}
