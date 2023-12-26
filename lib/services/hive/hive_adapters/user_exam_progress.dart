import 'package:hive/hive.dart';

part 'user_exam_progress.g.dart';

@HiveType(typeId: 2)
class UserExamProgressHive {
  UserExamProgressHive({
    this.courseId,
    this.examId,
    this.attempts,
    this.completionStatus,
  });

  UserExamProgressHive.fromMap(Map<String, dynamic> data) {
    courseId = data['courseId'] as String?;
    examId = data['examId'] as String?;
    attempts = data['attempts'] as Map<String, dynamic>?;
    completionStatus = data['completionStatus'] as String?;
  }

  @HiveField(0)
  String? courseId;

  @HiveField(1)
  String? examId;

  @HiveField(2)
  Map<String, dynamic>? attempts;

  @HiveField(3)
  String? completionStatus;
}
