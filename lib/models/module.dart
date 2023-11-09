import 'newExam.dart';
import 'slide.dart';

class Module {
  String title;
  String id;
  String contentDescription;
  int? index;
  List<Slide>? slides;
  List<NewExam>? exams;

  Module(
      {required this.title,
      required this.id,
      required this.contentDescription,
      this.slides,
      this.exams,
      this.index});

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
        id: map['id'],
        index: map['index'],
        title: map['title'],
        contentDescription: map['contentDescription']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'contentDescription': contentDescription,
      'index': index,
    };
  }

  addSlide(Slide slide) {
    if (slides != null) {
      slides!.add(slide);
    } else {
      print("not adding the slide locally, as there is no cache");
    }
  }

  addExam(NewExam exam) {
    if (exams != null) {
      exams!.add(exam);
    } else {
      print("not adding the module exam locally, as there is no cache");
    }
  }
}
