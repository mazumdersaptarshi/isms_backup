import 'package:isms/models/newExam.dart';
import 'package:isms/utilityFunctions/csvDataHandler.dart';

import 'module.dart';

class Course {
  String id;
  String name;
  String? description;
  int? modulesCount = 0;
  int? examsCount = 0;
  List<Module> modules = [];
  List<NewExam> exams = [];
  String? dateCreated;

  Course(
      {required this.id,
      required this.name,
      this.modulesCount,
      this.examsCount,
      this.description,
      this.dateCreated});

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
        id: map['id'],
        name: map['name'],
        description: map['description'] ?? "",
        modulesCount: map["modulesCount"] ?? 0,
        examsCount: map["examsCount"] ?? 0,
        dateCreated:
            CSVDataHandler.timestampToReadableDateInWords(map['createdAt']) ??
                '');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'exams': exams,
      'modulesCount': modulesCount,
      'examsCount': examsCount,
      'createdAt': dateCreated,
    };
  }
}
