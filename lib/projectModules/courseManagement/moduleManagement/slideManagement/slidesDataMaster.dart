import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import '../../coursesProvider.dart';

class SlidesDataMaster extends ModuleDataMaster {
  SlidesDataMaster(
      {required super.course,
      required super.coursesProvider,
      required this.module})
      : super() {
    _slidesRef = modulesRef!.doc(module.title).collection("slides");
  }
  Module module;
  CollectionReference? _slidesRef;
  CollectionReference? get slidesRef => _slidesRef;

  //Future<bool> createSlides({required List<Slide> slides}) async {
  //  List<Map<String, dynamic>> slidesMapList = [];
  //  int startingIndex = 0;
  //  try {
  //    startingIndex = module.slides!.length;
  //  } catch (e) {
  //    startingIndex = 0;
  //  }
  //  try {
  //    slides.forEach((slideItem) {
  //      startingIndex++;
  //      slideItem.index = startingIndex;
  //      Map<String, dynamic> slideMap = slideItem.toMap();
  //      slideMap['createdAt'] = DateTime.now();
  //      slidesMapList.add(slideMap);
  //    });
  //    slidesMapList.forEach((slideMap) async {
  //      await slidesRef!.doc(slideMap['id']).set(slideMap);
  //      print("Created slide ${slideMap}");
  //    });
  //    coursesProvider.addSlidesToModules(module, slides);
  //    print("Slides creation successful");
  //    return true;
  //  } catch (e) {
  //    return false;
  //  }
  //}

  Future fetchSlides() async {
    if (module.slides != null && module.slides!.isNotEmpty) {
      print("Slides for $module already fetched! See ${module.slides}");
      return;
    } else {
      QuerySnapshot slidesListSnapshot =
          await slidesRef!.orderBy("index").get();
      List<Slide> slides = [];
      if (slidesListSnapshot.size == 0) return;
      slidesListSnapshot.docs.forEach((element) {
        Slide s = Slide.fromMap(element.data() as Map<String, dynamic>);

        slides.add(s);
      });
      coursesProvider.addSlidesToModules(module, slides);
      print("FCN Slides for ${module.slides}, slides: ${module.slides}");
    }
  }
}
