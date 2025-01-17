// ignore_for_file: file_names

import 'package:logging/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';

class ModuleExamDataMaster extends ModuleDataMaster {
  ModuleExamDataMaster({
    required super.coursesProvider,
    required super.course,
    required this.module,
  }) : super() {
    _moduleRef = modulesRef.doc(module.title);
    _examsRef = _moduleRef.collection("exams");
  }
  final Module module;
  late final DocumentReference _moduleRef;
  late final CollectionReference _examsRef;

  final Logger logger = Logger("Module exams");

  Future<bool> createModuleExam({required NewExam exam}) async {
    // TODO fail if there is already an exam with this title
    try {
      //exam.index = module.examsCount + 1;
      // TODO replace the following line with the previous line, once
      // the field `examsCount` has been added to Module
      exam.index = (module.exams?.length ?? 0) + 1;

      // add the new exam into the database
      Map<String, dynamic> examMap = exam.toMap();
      examMap['createdAt'] = DateTime.now();
      await _examsRef.doc(exam.title).set(examMap);
      //await _moduleRef.update({'examsCount': exam.index});

      // add the new exam in the local cache
      module.addExam(exam);
      //module.examsCount = exam.index;

      coursesProvider.notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<NewExam>> _fetchExams() async {
    // this delay can be enabled to test the loading code
    //await Future.delayed(const Duration(milliseconds: 1000));

    QuerySnapshot examsListSnapshot = await _examsRef.orderBy("index").get();
    if (module.exams == null) {
      module.exams = [];
    } else {
      module.exams!.clear();
    }
    for (var element in examsListSnapshot.docs) {
      NewExam exam = NewExam.fromMap(element.data() as Map<String, dynamic>);
      module.addExam(exam);
    }
    //if (module.exams!.length != module.examsCount) {
    //  logger.warning ("fetched ${module.exams!.length} module exams, was expecting ${module.examsCount}");
    //}
    return module.exams!;
  }

  Future<List<NewExam>> get exams async {
    //the second part of the if check if all the question list have been load to reload them when a test has been newly created
    if (module.exams != null &&
        (module.exams!.where((element) => element.questionAnswerSet.isEmpty))
            .isEmpty) {
      logger.info("module exams in cache, no need to fetch them");
      return module.exams!;
    } else {
      logger.info(
          "module exams not in cache or missing data, trying to fetch them");
      try {
        return _fetchExams();
      } catch (e) {
        logger.severe("error while fetching module exams", e);
        module.exams = null;
        return [];
      }
    }
  }
}
