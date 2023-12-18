// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flipcard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlipCard _$FlipCardFromJson(Map<String, dynamic> json) => FlipCard(
      flipCardId: json['flipCardId'] as String,
      flipCardFront: json['flipCardFront'] as String,
      flipCardBack: json['flipCardBack'] as String,
    );

Map<String, dynamic> _$FlipCardToJson(FlipCard instance) => <String, dynamic>{
      'flipCardId': instance.flipCardId,
      'flipCardFront': instance.flipCardFront,
      'flipCardBack': instance.flipCardBack,
    };
