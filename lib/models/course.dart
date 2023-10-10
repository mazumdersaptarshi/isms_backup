import 'module.dart';
import 'exam.dart';

class Course {
  String id;
  String name;
  List<Module>? modules;
  List<Exam>? exams;

  Course({
    required this.id,
    required this.name,
    this.modules,
    this.exams,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      modules: map['modules'],
      exams: map['exams'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'modules': modules,
      'exams': exams,
    };
  }
}
