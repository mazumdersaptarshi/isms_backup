import 'module.dart';
import 'exam.dart';

class CustomCategory {
  String id;
  String name;
  List<Module>? modules;
  List<Exam>? exams;

  CustomCategory({
    required this.id,
    required this.name,
    this.modules,
    this.exams,
  });

  factory CustomCategory.fromMap(Map<String, dynamic> map) {
    return CustomCategory(
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
