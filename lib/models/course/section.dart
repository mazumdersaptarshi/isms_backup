import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/element.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'section.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class Section {
  final String sectionId;
  final String sectionTitle;
  final String sectionSummary;
  final List<Element> sectionElements;

  Section(
      {required this.sectionId,
      required this.sectionTitle,
      required this.sectionSummary,
      required this.sectionElements});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$SectionToJson(this);
}
