// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';

class ModuleDataMaster extends CoursesDataMaster {
  ModuleDataMaster({
    required this.coursesProvider,
    required this.course,
  }) {
    _courseRef = CoursesDataMaster.coursesRef.doc(course.name);
    _modulesRef = _courseRef.collection("modules");
  }
  final CoursesProvider coursesProvider;
  final Course course;
  late final DocumentReference _courseRef;
  late final CollectionReference _modulesRef;

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
      log("fetched ${course.modules!.length} modules, was expecting ${course.modulesCount}");
    }
    return course.modules!;
  }

  Future<List<Module>> get modules async {
    if (course.modules != null) {
      return course.modules!;
    } else {
      try {
        return _fetchModules();
      } catch (e) {
        log("error while fetching modules: $e");
        course.modules = null;
        return [];
      }
    }
  }
}
