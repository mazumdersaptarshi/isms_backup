import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';
import '../coursesProvider.dart';

class ExamDataMaster extends CoursesDataMaster {
  ExamDataMaster({
    required this.coursesProvider,
    required this.course,
  }) : super() {
    _courseRef = CoursesDataMaster.coursesRef.doc(course.name);
    _examsRef = _courseRef.collection("exams");
  }
  final CoursesProvider coursesProvider;
  final Course course;
  late final DocumentReference _courseRef;
  late final CollectionReference _examsRef;

  Future<bool> createCourseExam({required NewExam exam}) async {
    try {
      int index = course.examsCount + 1;

      exam.index = index;
      Map<String, dynamic> examMap = exam.toMap();

      examMap['createdAt'] = DateTime.now();

      await _examsRef.doc(exam.title).set(examMap);

      course.addExam(exam);
      coursesProvider.notifyListeners();

      await _courseRef.update({'examsCount': index});

      print("Exam creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<NewExam>> _fetchExams() async {
    //await Future.delayed(const Duration(milliseconds: 1000));

    QuerySnapshot examsListSnapshot =
      await _examsRef.orderBy("index").get();
    if (course.exams == null)
      course.exams = [];
    else
      course.exams!.clear();
    examsListSnapshot.docs.forEach((element) {
      NewExam exam = NewExam.fromMap(element.data() as Map<String, dynamic>);
      course.addExam(exam);
    });
    return course.exams!;
  }

  Future<List<NewExam>> get exams async {
    if (course.exams != null) {
      print("course exams in cache, no need to fetch them");
      return course.exams!;
    } else {
      print("course exams not in cache, trying to fetch them");
      try {
        return _fetchExams();
      } catch (e) {
        print("error while fetching course exams: ${e}");
        course.exams = null;
        return [];
      }
    }
  }
}
