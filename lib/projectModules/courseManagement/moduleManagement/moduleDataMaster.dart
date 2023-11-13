// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';

import '../coursesProvider.dart';

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
      Map<String, dynamic> moduleMap = module.toMap();

      moduleMap['createdAt'] = DateTime.now();

      await _modulesRef.doc(module.title).set(moduleMap);

      await _courseRef.update({'modulesCount': module.index});
      course.addModule(module);
      coursesProvider.notifyListeners();
      debugPrint("Module creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Module>> _fetchModules() async {
    //await Future.delayed(const Duration(milliseconds: 1000));

    QuerySnapshot modulesListSnapshot =
      await _modulesRef.orderBy("index").get();
    if (course.modules == null)
      course.modules = [];
    else
      course.modules!.clear();
    for (var element in modulesListSnapshot.docs) {
      Module module = Module.fromMap(element.data() as Map<String, dynamic>);
      course.addModule(module);
    }
    return course.modules!;
  }

  Future<List<Module>> get modules async {
    if (course.modules != null) {
      debugPrint("modules in cache, no need to fetch them");
      return course.modules!;
    } else {
      debugPrint("modules not in cache, trying to fetch them");
      try {
        return _fetchModules();
      } catch (e) {
        debugPrint("error while fetching modules: ${e}");
        course.modules = null;
        return [];
      }
    }
  }
}
