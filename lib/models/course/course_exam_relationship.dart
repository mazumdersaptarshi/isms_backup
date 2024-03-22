import 'package:isms/models/course/exam.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';

import 'course.dart';

class CourseExamRelationship implements SelectableItem {
  String courseId;

  String? courseTitle;

  // List<dynamic>? exams;

  CourseExamRelationship({
    required this.courseId,
    this.courseTitle,
  });

  @override
  String get itemId => courseId;

  @override
  String get itemName => courseTitle ?? 'n/a';
}
