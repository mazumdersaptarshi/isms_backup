// ignore_for_file: file_names

import 'package:logging/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';

class SlidesDataMaster extends ModuleDataMaster {
  SlidesDataMaster({
    required super.coursesProvider,
    required super.course,
    required this.module,
  }) : super() {
    _moduleRef = modulesRef.doc(module.title);
    _slidesRef = _moduleRef.collection("slides");
  }
  final Module module;
  late DocumentReference _moduleRef;
  late final CollectionReference _slidesRef;

  final Logger logger = Logger("Slides");

  Future<bool> createSlides({required List<Slide> slides}) async {
    try {
      //int index = module.slidesCount;
      // TODO replace the following line with the previous line, once
      // the field `slidesCount` has been added to Module
      int index = module.slides?.length ?? 0;

      for (Slide slide in slides) {
        index++;
        slide.index = index;

        // add the new slide into the database
        Map<String, dynamic> slideMap = slide.toMap();
        slideMap['createdAt'] = DateTime.now();
        await _slidesRef.doc(slideMap['id']).set(slideMap);
      }
      //await _moduleRef.update({'slidesCount': index});

      // add the new slides in the local cache
      module.addSlides(slides);
      //module.slidesCount = index;

      coursesProvider.notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Slide>> _fetchSlides() async {
    // this delay can be enabled to test the loading code
    //await Future.delayed(const Duration(milliseconds: 1000));

    QuerySnapshot slidesListSnapshot = await _slidesRef.orderBy("index").get();
    if (module.slides == null) {
      module.slides = [];
    } else {
      module.slides!.clear();
    }
    for (var element in slidesListSnapshot.docs) {
      Slide slide = Slide.fromMap(element.data() as Map<String, dynamic>);
      module.addSlide(slide);
      coursesProvider.notifyListeners();
    }
    //if (module.slides!.length != module.slidesCount) {
    //  logger.warning ("fetched ${module.slides!.length} slides, was expecting ${module.slidesCount}");
    //}
    return module.slides!;
  }

  Future<List<Slide>> get slides async {
    if (module.slides != null) {
      logger.info("slides in cache, no need to fetch them");
      return module.slides!;
    } else {
      logger.info("slides not in cache, trying to fetch them");
      try {
        return _fetchSlides();
      } catch (e) {
        logger.severe("error while fetching slides", e);
        module.slides = null;
        return [];
      }
    }
  }
}
