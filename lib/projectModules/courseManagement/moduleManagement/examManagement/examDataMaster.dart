import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import '../../coursesProvider.dart';

class ModuleExamDataMaster extends ModuleDataMaster {
  ModuleExamDataMaster({
    required super.coursesProvider,
    required super.course,
    required this.module,
  }) : super() {
    DocumentReference moduleRef = modulesRef.doc(module.title);
    _examsRef = moduleRef.collection("exams");
  }
  final Module module;
  late final CollectionReference _examsRef;

  Future<bool> createModuleExam(
      {required NewExam exam}) async {
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

      await _examsRef.doc(exam.title).set(examMap);

      module.addExam(exam);
      coursesProvider.notifyListeners();
      print("Module Exam creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<NewExam>> _fetchExams() async {
    //await Future.delayed(const Duration(milliseconds: 1000));

    QuerySnapshot examsListSnapshot =
      await _examsRef.orderBy("index").get();
    if (module.exams == null)
      module.exams = [];
    else
      module.exams!.clear();
    examsListSnapshot.docs.forEach((element) {
      NewExam exam = NewExam.fromMap(element.data() as Map<String, dynamic>);
      module.addExam(exam);
    });
    return module.exams!;
  }

  Future<List<NewExam>> get exams async {
    if (module.exams != null) {
      print("module exams in cache, no need to fetch them");
      return module.exams!;
    } else {
      print("module exams not in cache, trying to fetch them");
      try {
        return _fetchExams();
      } catch (e) {
        print("error while fetching module exams: ${e}");
        module.exams = null;
        return [];
      }
    }
  }
}
