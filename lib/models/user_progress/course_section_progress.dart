//This class shows progress of the individual sections of the course

class CourseSectionProgress {
  String sectionId;
  String? startDateTime;
  String? endDateTime;
  int? attempts;
  double? score;

  CourseSectionProgress(
      {required this.sectionId,
      this.startDateTime,
      this.endDateTime,
      this.attempts,
      this.score});
}
