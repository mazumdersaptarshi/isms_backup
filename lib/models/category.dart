import 'module.dart';
import 'exam.dart';

class Category {
  String id;
  String name;
  List<Module>? modules;
  List<Exam>? exams;

  Category({
    required this.id,
    required this.name,
    this.modules,
    this.exams,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
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
      'exam': exams,
    };
  }
}
