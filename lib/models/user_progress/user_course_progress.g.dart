// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_course_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCourseProgress _$UserCourseProgressFromJson(Map<String, dynamic> json) =>
    UserCourseProgress(
      userId: json['userId'] as String,
      courseId: json['courseId'] as String,
      courseCompleted: json['courseCompleted'] as bool,
      currentSection: json['currentSection'] as String,
      completedSections: (json['completedSections'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      completedExams: (json['completedExams'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserCourseProgressToJson(UserCourseProgress instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'courseId': instance.courseId,
      'courseCompleted': instance.courseCompleted,
      'currentSection': instance.currentSection,
      'completedSections': instance.completedSections,
      'completedExams': instance.completedExams,
    };
