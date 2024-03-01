import 'user_exam_attempt.dart';

enum ExamStatus { completed, not_completed }

class UserExamProgress {
  final String userId;
  final String courseId;

  final String examId;

  final String? examTitle;

  final ExamStatus examStatus;

  final List<UserExamAttempt>? examAttempts;

  UserExamProgress(
      {required this.userId,
      required this.courseId,
      required this.examId,
      this.examAttempts,
      this.examTitle,
      required this.examStatus});
}
