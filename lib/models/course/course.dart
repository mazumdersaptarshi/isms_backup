import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/section.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'course.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class Course {
  final String courseId;
  final String courseTitle;
  final String courseSummary;
  final String courseDescription;
  final List<Section> courseSections;

  Course(
      {required this.courseId,
      required this.courseTitle,
      required this.courseSummary,
      required this.courseDescription,
      required this.courseSections});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
