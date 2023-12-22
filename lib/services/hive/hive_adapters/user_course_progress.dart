import 'package:hive/hive.dart';

part 'user_course_progress.g.dart';

@HiveType(typeId: 1)
class UserCourseProgressHive {
  UserCourseProgressHive(
      {this.courseId,
      this.completionStatus,
      this.currentSection,
      this.completedSections});

  UserCourseProgressHive.fromMap(Map<String, dynamic> data) {
    courseId = data['courseId'] as String?;
    completionStatus = data['completionStatus'] as String?;
    currentSection = data['currentSection'] as String?;
    completedSections = data['completedSections'] as List?;
  }

  @HiveField(0)
  String? courseId;

  @HiveField(1)
  String? completionStatus;

  @HiveField(2)
  String? currentSection;

  @HiveField(3)
  List? completedSections;
}
