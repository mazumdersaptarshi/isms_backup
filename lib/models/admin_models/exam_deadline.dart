import 'package:json_annotation/json_annotation.dart';

part 'exam_deadline.g.dart'; // This file is generated automatically

@JsonSerializable()
class ExamDeadline {
  final String examId;
  final String courseId;
  final int usersPassed;
  final int allUsersCount;
  final String examTitle;
  final String courseTitle;
  final String contentLanguage;
  final String nearestCompletionDeadline;

  ExamDeadline({
    required this.examId,
    required this.courseId,
    required this.usersPassed,
    required this.allUsersCount,
    required this.examTitle,
    required this.courseTitle,
    required this.contentLanguage,
    required this.nearestCompletionDeadline,
  });

  // Factory constructor for creating a new ExamDeadline instance from a map
  factory ExamDeadline.fromJson(Map<String, dynamic> json) => _$ExamDeadlineFromJson(json);

  // Method to convert ExamDeadline instance to a map
  Map<String, dynamic> toJson() => _$ExamDeadlineToJson(this);
}
