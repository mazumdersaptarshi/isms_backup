// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseOverview _$CourseOverviewFromJson(Map<String, dynamic> json) =>
    CourseOverview(
      courseId: json['courseId'] as String,
      courseVersion: (json['courseVersion'] as num).toDouble(),
      courseTitle: json['courseTitle'] as String,
      courseSummary: json['courseSummary'] as String,
      courseDescription: json['courseDescription'] as String,
      courseSections: (json['courseSections'] as List<dynamic>)
          .map((e) => SectionOverview.fromJson(e as Map<String, dynamic>))
          .toList(),
      courseExams: (json['courseExams'] as List<dynamic>)
          .map((e) => ExamOverview.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseOverviewToJson(CourseOverview instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'courseVersion': instance.courseVersion,
      'courseTitle': instance.courseTitle,
      'courseSummary': instance.courseSummary,
      'courseDescription': instance.courseDescription,
      'courseSections': instance.courseSections.map((e) => e.toJson()).toList(),
      'courseExams': instance.courseExams.map((e) => e.toJson()).toList(),
    };
