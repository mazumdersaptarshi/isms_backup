import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/element.dart';
import 'package:isms/models/course/section.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'section_full.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class SectionFull implements Section {
  @override
  final String sectionId;
  @override
  final String sectionTitle;
  @override
  final String sectionSummary;
  final List<Element> sectionElements;

  SectionFull(
      {required this.sectionId,
      required this.sectionTitle,
      required this.sectionSummary,
      required this.sectionElements});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory SectionFull.fromJson(Map<String, dynamic> json) => _$SectionFullFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$SectionFullToJson(this);
}
