import 'package:hive/hive.dart';

part 'user_course_progress.g.dart';

@HiveType(typeId: 1)
class UserCourseProgressHive {
  UserCourseProgressHive(
      {this.courseId, this.completionStatus, this.currentSection, this.completedSections, this.completedExams});

  UserCourseProgressHive.fromMap(Map<String, dynamic> data) {
    courseId = data['courseId'] as String?;
    completionStatus = data['completionStatus'] as String?;
    currentSection = data['currentSection'] as String?;
    completedSections = data['completedSections'] as List?;
    completedExams = data['completedExams'] as List?;
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'completionStatus': completionStatus,
      'currentSection': currentSection,
      'completedSections': completedSections,
      'completedExams': completedExams,
    };
  }

  @HiveField(0)
  String? courseId;

  @HiveField(1)
  String? completionStatus;

  @HiveField(2)
  String? currentSection;

  @HiveField(3)
  List? completedSections;

  @HiveField(4)
  List? completedExams;
}
