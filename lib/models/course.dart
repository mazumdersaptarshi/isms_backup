
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/utilityFunctions/csvDataHandler.dart';

class Course {
  // these fields match Firestore fields
  final String id;
  final String name;
  int modulesCount;
  int examsCount;
  final String description;
  String dateCreated; // TODO make this a DateTime

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
    this.dateCreated = '', //DateTime.now().toString(),
    this.modules = const [],
    this.exams = const [],
  });

  // shallow-import a course from Firestore (skip subcollections)
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      modulesCount: map["modulesCount"],
      examsCount: map["examsCount"],
      description: map['description'] ?? "",
      modules: null,
      exams: null,
      dateCreated:
          // TODO store a Timestamp
          CSVDataHandler.timestampToReadableDateInWords(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'modulesCount': modulesCount,
      'examsCount': examsCount,
      'createdAt': dateCreated,
    };
  }

  addModule(Module module) {
    if (modules != null) {
      modules!.add(module);
    }
  }

  addExam(NewExam exam) {
    if (exams != null) {
      exams!.add(exam);
    }
  }
}
