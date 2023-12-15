// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Element<T> _$ElementFromJson<T>(Map<String, dynamic> json) => Element<T>(
      elementId: json['elementId'] as String,
      elementType: json['elementType'] as String,
      elementTitle: json['elementTitle'] as String,
      elementContent:
          ModelConverter<T>().fromJson(json['elementContent'] as Object),
    );

Map<String, dynamic> _$ElementToJson<T>(Element<T> instance) =>
    <String, dynamic>{
      'elementId': instance.elementId,
      'elementType': instance.elementType,
      'elementTitle': instance.elementTitle,
      'elementContent': ModelConverter<T>().toJson(instance.elementContent),
    };
