import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/exam_overview.dart';
import 'package:isms/models/course/section_overview.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'course_overview.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class CourseOverview implements Course {
  final String courseId;
  @override
  final double courseVersion;
  @override
  final String courseTitle;
  @override
  final String courseSummary;
  @override
  final String courseDescription;
  @override
  final List<SectionOverview> courseSections;
  final List<ExamOverview> courseExams;

  CourseOverview(
      {required this.courseId,
      required this.courseVersion,
      required this.courseTitle,
      required this.courseSummary,
      required this.courseDescription,
      required this.courseSections,
      required this.courseExams});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory CourseOverview.fromJson(Map<String, dynamic> json) => _$CourseOverviewFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$CourseOverviewToJson(this);
}
