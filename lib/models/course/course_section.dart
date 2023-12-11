// This class is for individual course sections. It can be of types: learningModule, assesment
class CourseSection {
  String sectionId;
  String? sectionContent;
  String? sectionType;

  CourseSection(
      {required this.sectionId, this.sectionContent, this.sectionType});
}
