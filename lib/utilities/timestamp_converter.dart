import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Utility class enabling conversion between Firestore's [Timestamp] and Dart's [DateTime].
///
/// When fetching [Timestamp] fields from Firebase documents, custom classes which de/serialise JSON will need to
/// convert these values to a [DateTime] object for use in Dart code.
/// This can be done by passing this class to the `converters` argument in the `@JsonSerializable()` annotation
/// for the custom JSON de/serialisation classes:
/// ```
/// @JsonSerializable(converters: [TimestampConverter()])
/// ```
///
/// Note that we cannot declare the type of [Timestamp] within the `JsonConverter<>` class extension declaration
/// or the `fromJson()` parameter calls and need to instead use `dynamic`.
/// This is because the generated code of any custom JSON de/serialisation classes using this converter will insert
/// the type cast `as Timestamp` for relevant [DateTime] fields.
/// As the required package import is not also added, lines such as the example below will cause a compilation failure:
/// ```
/// startTime: const TimestampConverter().fromJson(json['startTime'] as Timestamp),
/// ```
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  /// Returns a Dart [DateTime] object from a Firestore [Timestamp]
  @override
  DateTime fromJson(dynamic timestamp) => timestamp.toDate();

  /// Returns a Firestore [Timestamp] from a Dart [DateTime] object
  @override
  Timestamp toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}
