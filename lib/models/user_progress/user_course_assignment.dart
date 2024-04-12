import 'course_assignment_info.dart';

class UserCoursesAssignment {
  String userId;
  String name;
  String email;
  List<CourseAssignmentInfo> coursesAssigned;

  UserCoursesAssignment({
    required this.userId,
    required this.coursesAssigned,
    required this.name,
    required this.email,
  });
}
