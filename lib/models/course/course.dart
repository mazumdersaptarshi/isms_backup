// This class defines the structure of the Course
class Course {
  String courseId;
  String? courseName;
  String? courseDescription;
  List<dynamic>? courseSections;
  int? numberOfCourseSections;
  List<dynamic>? courseAssesments;

  Course(
      {required this.courseId,
      this.courseName,
      this.courseDescription,
      this.courseSections,
      this.numberOfCourseSections,
      this.courseAssesments});
}
