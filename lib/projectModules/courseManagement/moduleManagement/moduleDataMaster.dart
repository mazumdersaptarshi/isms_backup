// ignore_for_file: file_names

import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';

class ModuleDataMaster extends CoursesDataMaster {
  ModuleDataMaster({
    required super.coursesProvider,
    required this.course,
  }) {
    _courseRef = coursesRef.doc(course.name);
    _modulesRef = _courseRef.collection("modules");
  }
  final Course course;
  late final DocumentReference _courseRef;
  late final CollectionReference _modulesRef;

  final Logger logger = Logger("Modules");

  CollectionReference get modulesRef => _modulesRef;

  Future<bool> createModule({required Module module}) async {
    // TODO fail if there is already a module with this name
    try {
      module.index = course.modulesCount + 1;

      // add the new module into the database
      Map<String, dynamic> moduleMap = module.toMap();
      moduleMap['createdAt'] = DateTime.now();
      await _modulesRef.doc(module.title).set(moduleMap);
      await _courseRef.update({'modulesCount': module.index!});

      // add the new module in the local cache
      course.addModule(module);
      course.modulesCount = module.index!;

      coursesProvider.notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Module>> _fetchModules() async {
    // this delay can be enabled to test the loading code
    //await Future.delayed(const Duration(milliseconds: 1000));

    QuerySnapshot modulesListSnapshot =
        await _modulesRef.orderBy("index").get();
    if (course.modules == null) {
      course.modules = [];
    } else {
      course.modules!.clear();
    }
    for (var element in modulesListSnapshot.docs) {
      Module module = Module.fromMap(element.data() as Map<String, dynamic>);
      course.addModule(module);
    }
    if (course.modules!.length != course.modulesCount) {
      logger.warning("fetched ${course.modules!.length} modules, was expecting ${course.modulesCount}");
    }
    return course.modules!;
  }

  Future<List<Module>> get modules async {
    if (course.modules != null) {
      logger.info("modules in cache, no need to fetch them");
      return course.modules!;
    } else {
      logger.info("modules not in cache, trying to fetch them");
      try {
        return _fetchModules();
      } catch (e) {
        logger.severe("error while fetching modules", e);
        course.modules = null;
        return [];
      }
    }
  }
}
