import 'slide.dart';

class Module {
  String title;
  String id;
  String contentDescription;
  int index;
  List<Slide>? slides;
  Module(
      {required this.title,
      required this.id,
      required this.contentDescription,
      this.slides,
      this.index = 0});

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
        id: map['id'],
        index: map['index'] ?? 0,
        title: map['title'],
        contentDescription: map['contentDescription'],
        slides: map['slides']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slides': slides,
      'contentDescription': contentDescription,
      'index': index ?? 0
    };
  }
}
