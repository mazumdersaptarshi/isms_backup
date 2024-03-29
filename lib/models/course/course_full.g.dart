// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_full.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseFull _$CourseFullFromJson(Map<String, dynamic> json) => CourseFull(
      courseTitle: json['courseTitle'] as String,
      courseSummary: json['courseSummary'] as String,
      courseDescription: json['courseDescription'] as String,
      courseSections: (json['courseSections'] as List<dynamic>)
          .map((e) => SectionFull.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseFullToJson(CourseFull instance) =>
    <String, dynamic>{
      'courseTitle': instance.courseTitle,
      'courseSummary': instance.courseSummary,
      'courseDescription': instance.courseDescription,
      'courseSections': instance.courseSections.map((e) => e.toJson()).toList(),
    };
