// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_course_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCourseProgress _$UserCourseProgressFromJson(Map<String, dynamic> json) =>
    UserCourseProgress(
      courseId: json['courseId'] as String?,
      completionStatus: json['completionStatus'] as String?,
      currentSection: json['currentSection'] as String?,
      completedSections: json['completedSections'] as List<dynamic>?,
      completedExams: json['completedExams'] as List<dynamic>?,
    );

Map<String, dynamic> _$UserCourseProgressToJson(UserCourseProgress instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'completionStatus': instance.completionStatus,
      'currentSection': instance.currentSection,
      'completedSections': instance.completedSections,
      'completedExams': instance.completedExams,
    };
