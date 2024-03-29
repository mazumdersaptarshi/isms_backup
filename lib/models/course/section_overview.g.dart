// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionOverview _$SectionOverviewFromJson(Map<String, dynamic> json) =>
    SectionOverview(
      sectionId: json['sectionId'] as String,
      sectionTitle: json['sectionTitle'] as String,
      sectionSummary: json['sectionSummary'] as String,
      sectionCompleted: json['sectionCompleted'] as bool,
    );

Map<String, dynamic> _$SectionOverviewToJson(SectionOverview instance) =>
    <String, dynamic>{
      'sectionId': instance.sectionId,
      'sectionTitle': instance.sectionTitle,
      'sectionSummary': instance.sectionSummary,
      'sectionCompleted': instance.sectionCompleted,
    };
