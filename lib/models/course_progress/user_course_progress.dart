/// This class is for tracking the progress of the course for the User

class UserCourseProgress {
  String courseId;
  String? courseName;
  String? completionStatus;
  String? currentSectionId;
  Map<String, dynamic>? currentSection;
  List? sectionProgressList;
  List? attempts;
  List? scores;

  UserCourseProgress(
      {required this.courseId,
      this.courseName,
      this.completionStatus,
      this.currentSectionId,
      this.currentSection,
      this.sectionProgressList,
      this.attempts,
      this.scores});
}
