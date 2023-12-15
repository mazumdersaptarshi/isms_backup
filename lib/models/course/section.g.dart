// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Section<T> _$SectionFromJson<T>(Map<String, dynamic> json) => Section<T>(
      sectionId: json['sectionId'] as String,
      sectionType: json['sectionType'] as String,
      sectionTitle: json['sectionTitle'] as String? ?? '',
      sectionContent:
          ModelConverter<T>().fromJson(json['sectionContent'] as Object),
    );

Map<String, dynamic> _$SectionToJson<T>(Section<T> instance) =>
    <String, dynamic>{
      'sectionId': instance.sectionId,
      'sectionType': instance.sectionType,
      'sectionTitle': instance.sectionTitle,
      'sectionContent': ModelConverter<T>().toJson(instance.sectionContent),
    };
