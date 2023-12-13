import 'package:hive/hive.dart';

part 'user_course_progress.g.dart';

@HiveType(typeId: 1)
class UserCourseProgressHive {
  UserCourseProgressHive(
      {this.courseId,
      this.courseName,
      this.completionStatus,
      this.currentSectionId,
      this.sectionProgressList,
      this.attempts,
      this.scores,
      this.currentSection});

  @HiveField(0)
  String? courseId;

  @HiveField(1)
  String? courseName;

  @HiveField(2)
  String? completionStatus;

  @HiveField(3)
  String? currentSectionId;

  @HiveField(4)
  List? sectionProgressList;

  @HiveField(5)
  List? attempts;

  @HiveField(6)
  List? scores;

  @HiveField(7)
  Map<String, dynamic>? currentSection;
}
