import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/section_full.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'course_full.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class CourseFull implements Course {
  @override
  final double courseVersion;
  @override
  final String courseTitle;
  @override
  final String courseSummary;
  @override
  final String courseDescription;
  @override
  final List<SectionFull> courseSections;

  CourseFull(
      {required this.courseVersion,
      required this.courseTitle,
      required this.courseSummary,
      required this.courseDescription,
      required this.courseSections});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory CourseFull.fromJson(Map<String, dynamic> json) => _$CourseFullFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$CourseFullToJson(this);
}
