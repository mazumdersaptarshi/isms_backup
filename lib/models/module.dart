import 'package:logging/logging.dart';

import 'newExam.dart';
import 'slide.dart';

class Module {
  // these fields match Firestore fields
  final String title;
  final String id;
  final String contentDescription;
  String additionalInfo;
  int? index;
  // TODO add an examCount field, similar to Course

  // these fields match Firestore subcollections,
  // so they are nullable
  List<Slide>? slides;
  List<NewExam>? exams;

  final log = Logger("Module");

  Module(
      {required this.title,
      required this.id,
      required this.contentDescription,
      required this.additionalInfo,
      this.slides,
      this.exams,
      this.index});

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
      id: map['id'],
      index: map['index'],
      title: map['title'],
      contentDescription: map['contentDescription'],
      additionalInfo: map['additionalInfo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'contentDescription': contentDescription,
      'additionalInfo': additionalInfo,
      'index': index,
    };
  }

  addSlides(List<Slide> newSlides) {
    if (slides != null) {
      slides!.addAll(newSlides);
    } else {
      log.info("not adding the course exam locally, as there is no cache");
    }
  }

  addSlide(Slide slide) {
    if (slides != null) {
      slides!.add(slide);
    } else {
      log.info("not adding the slide locally, as there is no cache");
    }
  }

  addExam(NewExam exam) {
    if (exams != null) {
      exams!.add(exam);
    } else {
      log.info("not adding the module exam locally, as there is no cache");
    }
  }
}
