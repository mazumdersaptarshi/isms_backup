// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Section _$SectionFromJson(Map<String, dynamic> json) => Section(
      sectionId: json['sectionId'] as String,
      sectionTitle: json['sectionTitle'] as String,
      sectionSummary: json['sectionSummary'] as String,
      sectionElements: (json['sectionElements'] as List<dynamic>)
          .map((e) => Element<dynamic>.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'sectionId': instance.sectionId,
      'sectionTitle': instance.sectionTitle,
      'sectionSummary': instance.sectionSummary,
      'sectionElements':
          instance.sectionElements.map((e) => e.toJson()).toList(),
    };
