import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';
import '../coursesProvider.dart';

class ExamDataMaster extends CoursesDataMaster {
  ExamDataMaster({required this.course, required this.coursesProvider})
      : super() {
    _examsRef =
        CoursesDataMaster.coursesRef.doc(course.name).collection("exams");
  }
  Course course;
  CoursesProvider coursesProvider;

  CollectionReference? _examsRef;
  CollectionReference? get examsRef => _examsRef;

  Future<bool> createCourseExam({required NewExam exam}) async {
    try {
      int index = course.exams.length + 1;

      exam.index = index;
      Map<String, dynamic> examMap = exam.toMap();

      examMap['createdAt'] = DateTime.now();

      await examsRef!.doc(exam.title).set(examMap);

      coursesProvider.addExamsToCourse(course, [exam]);

      await FirebaseFirestore.instance
          .collection('courses')
          .doc(course.name)
          .update({'examsCount': index});

      print("Exam creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createModuleExam(
      {required Module module, required NewExam exam}) async {
    try {
      int index = 1;
      try {
        index = module.exams!.length + 1;
      } catch (e) {
        index = 1;
      }
      exam.index = index;
      Map<String, dynamic> examMap = exam.toMap();

      examMap['createdAt'] = DateTime.now();

      await CoursesDataMaster.coursesRef
          .doc(course.name)
          .collection("modules")
          .doc(module.title)
          .collection("exams")
          .doc(exam.title)
          .set(examMap);

      coursesProvider.addExamsToCourseModule(module, [exam]);
      print("Module Exam creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future fetchExams() async {
    if (course.exams != null && course.exams!.isNotEmpty) {
      return;
    } else {
      QuerySnapshot examsListSnapshot = await examsRef!.orderBy("index").get();
      course.exams = [];
      examsListSnapshot.docs.forEach((element) {
        // print(element.data());
        NewExam exam = NewExam.fromMap(element.data() as Map<String, dynamic>);

        course.exams?.add(exam);
      });
      // coursesProvider.fetchExamsToCourse(courseIndex, course.exams!);
      print("FCN Courses ${course.hashCode}, has exams: ${course.exams}");
    }
  }

  Future fetchModuleExams({required Module module}) async {
    if (module.exams != null && module.exams!.isNotEmpty) {
      return;
    } else {
      QuerySnapshot examsListSnapshot = await CoursesDataMaster.coursesRef
          .doc(course.name)
          .collection('modules')
          .doc(module.title)
          .collection('exams')
          .orderBy("index")
          .get();
      module.exams = [];
      examsListSnapshot.docs.forEach((element) {
        // print(element.data());
        NewExam exam = NewExam.fromMap(element.data() as Map<String, dynamic>);

        module.exams?.add(exam);
      });
      // coursesProvider.addExamsToCourseModule(
      //     courseIndex, moduleIndex, module.exams!);
      print("FCN Module ${module.hashCode}, has exams: ${module.exams}");
    }
  }
}
