// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String,
      courseDescription: json['courseDescription'] as String,
      courseSections: (json['courseSections'] as List<dynamic>)
          .map(
              (e) => CourseSection<dynamic>.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'courseId': instance.courseId,
      'courseTitle': instance.courseTitle,
      'courseDescription': instance.courseDescription,
      'courseSections': instance.courseSections.map((e) => e.toJson()).toList(),
    };
