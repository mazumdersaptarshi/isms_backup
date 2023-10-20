import 'package:isms/models/newExam.dart';

import 'module.dart';

class Course {
  String id;
  String name;
  int? modulesCount;
  List<Module> modules = [];
  List<NewExam>? exams;

  Course({required this.id, required this.name, this.exams, this.modulesCount});

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
        id: map['id'],
        name: map['name'],
        exams: map['exams'],
        modulesCount: map["modulesCount"] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exams': exams,
      'modulesCount': modulesCount
    };
  }
}
