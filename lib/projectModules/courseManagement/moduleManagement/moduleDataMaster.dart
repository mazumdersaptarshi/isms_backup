import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';

import '../coursesProvider.dart';

class ModuleDataMaster extends CoursesDataMaster {
  ModuleDataMaster({required this.course, required this.coursesProvider}) {
    _modulesRef =
        CoursesDataMaster.coursesRef.doc(course.name).collection("modules");
  }
  Course course;
  CollectionReference? _modulesRef;
  CollectionReference? get modulesRef => _modulesRef;
  CoursesProvider coursesProvider;
  Future<bool> createModule({required Module module}) async {
    try {
      int index = 1;
      try {
        index = course.modules!.length + 1;
      } catch (e) {
        index = 1;
      }
      module.index = index;
      Map<String, dynamic> moduleMap = module.toMap();

      moduleMap['createdAt'] = DateTime.now();

      await modulesRef?.doc(module.title).set(moduleMap);

      await FirebaseFirestore.instance
          .collection('courses')
          .doc(course.name)
          .update({'modulesCount': index});
      coursesProvider.addModulesToCourse(course, [module]);
      print("Module creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future fetchModules() async {
    if (course.modules != null && course.modules!.isNotEmpty) {
      print("NO NEEED  TO FETCH MODULESSS ${course.modules}");
      return;
    } else {
      try {
        print("TRY TO FETCH MODULESSS ${course.modules}");
        QuerySnapshot modulesListSnapshot =
            await modulesRef!.orderBy("index").get();
        course.modules = [];
        modulesListSnapshot.docs.forEach((element) {
          Module m = Module.fromMap(element.data() as Map<String, dynamic>);
          course.modules?.add(m);
        });
        // coursesProvider.addModulesToCourse(courseIndex, course.modules!);
      } catch (e) {
        print("FETCCHHH MODULESS ERRORR: ${e}");
      }
    }
  }
}
