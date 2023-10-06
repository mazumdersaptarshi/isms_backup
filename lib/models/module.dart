import 'slide.dart';

class Module {
  String title;
  String id;
  List<Slide>? slides;
  Module({required this.title, required this.id, this.slides});

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
      id: map['id'],
      title: map['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slides': slides,
    };
  }
}
