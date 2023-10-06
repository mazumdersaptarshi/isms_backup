import 'slide.dart';

class Module {
  String title;
  String id;
  String contentDescription;

  List<Slide>? slides;
  Module(
      {required this.title,
      required this.id,
      required this.contentDescription,
      this.slides});

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
        id: map['id'],
        title: map['title'],
        contentDescription: map['contentDescription'],
        slides: map['slides']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slides': slides,
      'contentDescription': contentDescription
    };
  }
}
