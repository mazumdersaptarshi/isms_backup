import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/screens/createSlideScreen.dart';

Future<bool> createSlides(
    {required Module module,
    required Course course,
    required List<Slide> slides}) async {
  List<Map<String, dynamic>> slidesMapList = [];
  try {
    slides.forEach((slideItem) {
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

    if (module.slides == null) module.slides = [];

    module.slides?.addAll(slides);
    print("Slides creation successful");
    return true;
  } catch (e) {
    return false;
  }
}
