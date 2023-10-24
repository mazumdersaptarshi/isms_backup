import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';

import '../coursesProvider.dart';

Future fetchModules(
    {required int courseIndex,
    required CoursesProvider coursesProvider}) async {
  Course course = coursesProvider.allCourses[courseIndex];
  if (course.modules != null && course.modules!.isNotEmpty) {
    print("NO NEEED  TO FETCH MODULESSS ${course.modules}");
    return;
  } else {
    try {
      print("TRY TO FETCH MODULESSS ${course.modules}");
      QuerySnapshot modulesListSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course.name)
          .collection('modules')
          .orderBy("index")
          .get();
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
