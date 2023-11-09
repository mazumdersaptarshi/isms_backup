import 'module.dart';
import 'newExam.dart';

class Course {
  // these fields match Firestore fields
  String id;
  String name;
  int modulesCount;
  int examsCount;
  String description;

  // these fields match Firestore subcollections,
  // so they are nullable
  List<Module>? modules;
  List<NewExam>? exams;

  // create a course locally
  Course({
    required this.id,
    required this.name,
    this.modulesCount = 0,
    this.examsCount = 0,
    this.description = "",
    this.modules = const [],
    this.exams = const [],
  });

  // shallow-import a course from Firestore (skip subcollections)
  factory Course.fromMap(Map<String, dynamic> map) {
    print("map: ${map}");
    return Course(
        id: map['id'],
        name: map['name'],
        modulesCount: map["modulesCount"],
        examsCount: map["examsCount"],
        description: map['description'] ?? "",
        modules: null,
        exams: null);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'modulesCount': modulesCount,
      'examsCount': examsCount
    };
  }

  addModule(Module module) {
    if (modules != null) {
      modules!.add(module);
    } else {
      print("not adding the module locally, as there is no cache");
    }
  }

  addExam(NewExam exam) {
    if (exams != null) {
      exams!.add(exam);
    } else {
      print("not adding the course exam locally, as there is no cache");
    }
  }
}
