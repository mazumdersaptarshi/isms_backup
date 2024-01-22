import 'package:json_annotation/json_annotation.dart';

import 'package:isms/utilities/serializable.dart';
import 'package:isms/models/enums.dart';
import 'package:isms/models/course/flip_card.dart';
import 'package:isms/models/course/question.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'element.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class Element<T> {
  final String elementId;
  final String elementType;
  final String elementTitle;

  /// The type of `elementContent` in the JSON will vary depending on `elementType`,
  /// so we need to make the variable [elementContent] generic.
  /// This necessitates specifying a converter helper class `ModelConverter`
  /// with this annotation to handle the de/serialisation of each individual type.
  @ModelConverter()
  final T elementContent;

  Element(
      {required this.elementId, required this.elementType, required this.elementTitle, required this.elementContent});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory Element.fromJson(Map<String, dynamic> json) => _$ElementFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$ElementToJson(this);
}

/// This converter helper class determines the required Dart object to create for each type of data returned
/// in the JSON field `elementContent`.
///
/// Possible JSON `elementType` values with their corresponding type in Dart are:
///  - `html` -> [String]
///  - `question` -> [List<Question>]
///  - `flipCard` -> [List<FlipCard>]
///
/// Note that the [String] returned in JSON field `elementType` is necessary for conditional logic when
/// displaying the element **only in Dart**; here we need to inspect the keys present in the returned JSON map(s)
/// to identify the type.
class ModelConverter<T> implements JsonConverter<T, Object> {
  const ModelConverter();

  /// `fromJson` takes [Object] instead of [Map<String,dynamic>] so as to handle both
  /// a single JSON map or a [List] of JSON maps.
  @override
  T fromJson(Object json) {
    if (json is List) {
      if (json.isEmpty) return [] as T;

      /// We need to inspect the first element of the List of JSON to determine its type.
      Map<String, dynamic> first = json.first as Map<String, dynamic>;

      /// Identify the serialised JSON object by checking for the existence of keys which are unique to each.
      if (first.containsKey(QuestionKeys.questionId.name)) {
        return json.map((mapJson) => Question.fromJson(mapJson)).toList() as T;
      } else if (first.containsKey(FlipCardKeys.flipCardId.name)) {
        return json.map((mapJson) => FlipCard.fromJson(mapJson)).toList() as T;
      }
    } else if (json is String) {
      /// Return the String as-is since we do not need to deserialise it.
      return json as T;
    }

    /// We didn't recognise this JSON map as one of our model classes, so we throw an error to flag that
    /// the missing handler needs to be added.
    throw ArgumentError.value(
        json,
        'json',
        'OperationResult._fromJson cannot handle'
            ' this JSON payload. Please add a handler to _fromJson.');
  }

  /// Since we want to handle both JSON [String]s and [List]s of JSON in our [toJson()] method,
  /// our return type will be [Object].
  ///
  /// Below, [Serializable] is an abstract class/interface we created to allow us to check whether
  /// a concrete class of type T has a [toJson()] method.
  /// Maybe there's a better way to do this?
  ///
  /// Our JsonConverter uses a type variable of T, rather than `T extends Serializable`,
  /// since if T is a [List], it won't have a [toJson()] method and it's not a class under our control.
  /// Thus, we impose no narrower scope so as to handle both cases:
  ///  - An object which has a [toJson()] method
  ///  - A [List] of such objects
  @override
  Object toJson(T object) {
    /// First we'll check if the object is [Serializable].
    /// Testing for the [Serializable] type (our custom interface of a class signature that has a [toJson()] method)
    /// allows us to call [toJson()] directly on it.
    if (object is Serializable) {
      return object.toJson();
    }

    /// Otherwise, check if it's a [List] & not empty & elements are [Serializable].
    else if (object is List) {
      if (object.isEmpty) return [];

      if (object.first is Serializable) {
        return object.map((t) => t.toJson()).toList();
      }
    }

    /// It's not a [List] & it's not [Serializable]; this is a design issue.
    throw ArgumentError.value(
        object,
        'Cannot serialize to JSON',
        'OperationResult._toJson this object or List either is not '
            'Serializable or is unrecognized.');
  }
}
