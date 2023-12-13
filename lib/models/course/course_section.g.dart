// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseSection<T> _$CourseSectionFromJson<T>(Map<String, dynamic> json) =>
    CourseSection<T>(
      sectionType: json['sectionType'] as String,
      sectionTitle: json['sectionTitle'] as String? ?? '',
      sectionContent:
          ModelConverter<T>().fromJson(json['sectionContent'] as Object),
    );

Map<String, dynamic> _$CourseSectionToJson<T>(CourseSection<T> instance) =>
    <String, dynamic>{
      'sectionType': instance.sectionType,
      'sectionTitle': instance.sectionTitle,
      'sectionContent': ModelConverter<T>().toJson(instance.sectionContent),
    };
