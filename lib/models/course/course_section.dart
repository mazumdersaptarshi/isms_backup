import 'package:json_annotation/json_annotation.dart';

import 'package:isms/interfaces/serializable.dart';
import 'package:isms/models/course/flipcard.dart';
import 'package:isms/models/course/question.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'course_section.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class CourseSection<T> {
  final String sectionType;
  final String sectionTitle;

  /// The type of `sectionContent` in the JSON will vary depending on `sectionType`
  /// so we need to make this variable generic for the `sectionContent` variable.
  /// This necessitates specifying a converter helper class `ModelConverter`
  /// with this annotation to handle the de/serialisation of each individual type.
  @ModelConverter()
  final T sectionContent;

  CourseSection({
      required this.sectionType,
      this.sectionTitle = '',
      required this.sectionContent});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory CourseSection.fromJson(Map<String, dynamic> json) => _$CourseSectionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation
  /// to JSON. The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$CourseSectionToJson(this);
}

/// This converter helper class determines the required Dart object to create
/// for each type of data returned in the JSON field `sectionContent`.
///
/// Possible JSON `sectionType` values with their corresponding type in Dart are:
///  - `Html` -> `String`
///  - `SingleSelectionQuestion` -> `Question`
///  - `MultipleSelectionQuestion` -> `Question`
///  - `FlipCard` -> `List<FlipCard>`
///  - `NextSectionButton` -> `String`
///
/// Note that the `String` returned in JSON field `sectionType` is necessary for
/// conditional logic when displaying the section **only in Dart**; here we need to
/// inspect the keys present in the returned JSON map(s) to identify the type.
class ModelConverter<T> implements JsonConverter<T, Object> {
  const ModelConverter();

  /// `fromJson` takes Object instead of Map<String,dynamic> so as to handle both
  /// a JSON map or a List of JSON maps.  If List is not used, you could specify
  /// Map<String,dynamic> as the S type variable and use it as
  /// the json argument type for fromJson() & return type of toJson().
  /// S can be any Dart supported JSON type
  /// https://pub.dev/packages/json_serializable/versions/6.0.0#supported-types
  /// In this example we only care about Object and List<Object> serialization
  @override
  T fromJson(Object json) {
    /// Start by checking if json is just a single JSON map, not a List.
    if (json is Map<String,dynamic>) {
      /// If it is a `Map`, we then identify the serialised JSON object by
      /// checking for the existence of keys which are unique to each.
      if (json.containsKey('questionText')) {
        return Question.fromJson(json) as T;
      }
    } else if (json is List) { /// Here we handle Lists of JSON maps
      if (json.isEmpty) return [] as T;

      /// Inspect the first element of the List of JSON to determine its Type
      Map<String,dynamic> first = json.first as Map<String,dynamic>;

      if (first.containsKey('flipCardFront')) {
        return json.map((mapJson) => FlipCard.fromJson(mapJson)).toList() as T;
      }
    } else if (json is String) {
      /// Return the String as-is since we do not need to deserialise it.
      return json as T;
    }
    /// We didn't recognise this JSON map as one of our model classes, throw an error
    /// so we can add the missing case
    throw ArgumentError.value(json, 'json', 'OperationResult._fromJson cannot handle'
        ' this JSON payload. Please add a handler to _fromJson.');
  }

  /// Since we want to handle both JSON and List of JSON in our toJson(),
  /// our output Type will be Object.
  /// Otherwise, Map<String,dynamic> would be OK as our S type / return type.
  ///
  /// Below, "Serializable" is an abstract class / interface we created to allow
  /// us to check if a concrete class of type T has a "toJson()" method. See
  /// next section further below for the definition of Serializable.
  /// Maybe there's a better way to do this?
  ///
  /// Our JsonConverter uses a type variable of T, rather than "T extends Serializable",
  /// since if T is a List, it won't have a toJson() method and it's not a class
  /// under our control.
  /// Thus, we impose no narrower scope so as to handle both cases: an object that
  /// has a toJson() method, or a List of such objects.
  @override
  Object toJson(T object) {
    /// First we'll check if object is Serializable.
    /// Testing for Serializable type (our custom interface of a class signature
    /// that has a toJson() method) allows us to call toJson() directly on it.
    if (object is Serializable){
      return object.toJson();
    } /// otherwise, check if it's a List & not empty & elements are Serializable
    else if (object is List) {
      if (object.isEmpty) return [];

      if (object.first is Serializable) {
        return object.map((t) => t.toJson()).toList();
      }
    }
    /// It's not a List & it's not Serializable, this is a design issue
    throw ArgumentError.value(object, 'Cannot serialize to JSON',
        'OperationResult._toJson this object or List either is not '
            'Serializable or is unrecognized.');
  }
}