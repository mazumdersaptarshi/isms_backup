import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/section.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'section_overview.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class SectionOverview implements Section {
  @override
  final String sectionId;
  @override
  final String sectionTitle;
  @override
  final String sectionSummary;
  final bool sectionCompleted;

  SectionOverview(
      {required this.sectionId,
      required this.sectionTitle,
      required this.sectionSummary,
      required this.sectionCompleted});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory SectionOverview.fromJson(Map<String, dynamic> json) => _$SectionOverviewFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$SectionOverviewToJson(this);
}
