import 'package:hive/hive.dart';

part 'user_course_progress.g.dart';

@HiveType(typeId: 1)
class UserCourseProgressHive {
  UserCourseProgressHive(
      {this.courseId,
      this.courseTitle,
      this.startStatus,
      this.completionStatus,
      this.currentSectionId,
      this.sections,
      this.attempts,
      this.scores,
      this.currentSection});

  @HiveField(0)
  String? courseId;

  @HiveField(1)
  String? courseTitle;

  @HiveField(2)
  String? completionStatus;

  @HiveField(3)
  String? currentSectionId;

  @HiveField(4)
  Map? sections;

  @HiveField(5)
  List? attempts;

  @HiveField(6)
  List? scores;

  @HiveField(7)
  Map<String, dynamic>? currentSection = {};

  @HiveField(8)
  String? startStatus;
}
