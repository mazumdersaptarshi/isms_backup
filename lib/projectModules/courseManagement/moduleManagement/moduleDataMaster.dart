
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
        index = course.modules.length + 1;
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
      debugPrint("Module creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future fetchModules() async {
    if (course.modules.isNotEmpty) {
      debugPrint("NO NEEED  TO FETCH MODULESSS ${course.modules}");
      return;
    } else {
      try {
        debugPrint("TRY TO FETCH MODULESSS ${course.modules}");
        QuerySnapshot modulesListSnapshot =
            await modulesRef!.orderBy("index").get();
        course.modules = [];
        for (var element in modulesListSnapshot.docs) {
          Module m = Module.fromMap(element.data() as Map<String, dynamic>);
          course.modules.add(m);
        }
        // coursesProvider.addModulesToCourse(courseIndex, course.modules!);
      } catch (e) {
        debugPrint("FETCCHHH MODULESS ERRORR: $e");
      }
    }
  }
}
