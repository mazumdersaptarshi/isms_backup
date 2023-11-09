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
  SlidesDataMaster({
    required super.coursesProvider,
    required super.course,
    required this.module,
  }) : super() {
    DocumentReference moduleRef = modulesRef.doc(module.title);
    _slidesRef = moduleRef.collection("slides");
  }
  final Module module;
  late final CollectionReference _slidesRef;

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
  //      await _slidesRef.doc(slideMap['id']).set(slideMap);
  //      print("Created slide ${slideMap}");
  //    });
  //    coursesProvider.addSlidesToModules(module, slides);
  //    print("Slides creation successful");
  //    return true;
  //  } catch (e) {
  //    return false;
  //  }
  //}

  Future<List<Slide>> _fetchSlides() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    QuerySnapshot slidesListSnapshot =
      await _slidesRef.orderBy("index").get();
    if (module.slides == null)
      module.slides = [];
    else
      module.slides!.clear();
    slidesListSnapshot.docs.forEach((element) {
      Slide slide = Slide.fromMap(element.data() as Map<String, dynamic>);
      module.addSlide(slide);
      coursesProvider.notifyListeners();
    });
    return module.slides!;
  }

  Future<List<Slide>> get slides async {
    if (module.slides != null) {
      print("slides in cache, no need to fetch them");
      return module.slides!;
    } else {
      print("slides not in cache, trying to fetch them");
      try {
        return _fetchSlides();
      } catch (e) {
        print("error while fetching slides: ${e}");
        module.slides = null;
        return [];
      }
    }
  }
}
