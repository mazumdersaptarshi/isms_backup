
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';

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

  Future<bool> createSlides({required List<Slide> slides}) async {
    List<Map<String, dynamic>> slidesMapList = [];
    int startingIndex = 0;
    try {
      startingIndex = module.slides!.length;
    } catch (e) {
      startingIndex = 0;
    }

    try {
      for (var slideItem in slides) {
        startingIndex++;
        slideItem.index = startingIndex;
        Map<String, dynamic> slideMap = slideItem.toMap();
        slideMap['createdAt'] = DateTime.now();
        slidesMapList.add(slideMap);
      }

      for(Map<String, dynamic> slideMap in slidesMapList) {
        await slidesRef!.doc(slideMap['id']).set(slideMap);
        debugPrint("Created slide $slideMap");
      }

      coursesProvider.addSlidesToModules(module, slides);
      debugPrint("Slides creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future fetchSlides() async {
    if (module.slides != null && module.slides!.isNotEmpty) {
      debugPrint("Slides for $module already fetched! See ${module.slides}");
      return;
    } else {
      QuerySnapshot slidesListSnapshot =
          await slidesRef!.orderBy("index").get();
      List<Slide> slides = [];
      if (slidesListSnapshot.size == 0) return;
      for (var element in slidesListSnapshot.docs) {
        Slide s = Slide.fromMap(element.data() as Map<String, dynamic>);

        slides.add(s);
      }
      coursesProvider.addSlidesToModules(module, slides);
      debugPrint("FCN Slides for ${module.slides}, slides: ${module.slides}");
    }
  }
}
