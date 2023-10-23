import 'package:isms/models/newExam.dart';

import 'module.dart';

class Course {
  String id;
  String name;
  int? modulesCount = 0;
  int? examsCount = 0;
  List<Module> modules = [];
  List<NewExam> exams = [];

  Course(
      {required this.id,
      required this.name,
      this.modulesCount,
      this.examsCount});

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
        id: map['id'],
        name: map['name'],
        modulesCount: map["modulesCount"] ?? 0,
        examsCount: map["examsCount"] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exams': exams,
      'modulesCount': modulesCount,
      'examsCount': examsCount
    };
  }
}
