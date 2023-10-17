import 'package:isms/models/adminConsoleModels/studentsCourseDetails.dart';

class CoursesDetails {
  String course_id;
  String course_name;
  int number_of_exams;
  int number_of_modules;

  List<StudentCourseDetails>? students = [
    StudentCourseDetails(
        course_percent_completed: 0,
        email: 's.mazumder@pvp.co.jp',
        exams_percent_completed: 0,
        isPassed: false,
        user_ID: 'n/a')
  ];

  CoursesDetails(
      {required this.course_id,
      required this.course_name,
      required this.number_of_modules,
      required this.number_of_exams,
      this.students});

  Map<String, dynamic> toMap() {
    print('Here');
    return {
      'course_id': course_id,
      'course_name': course_name,
      'number_of_modules': number_of_modules,
      'number_of_exams': number_of_exams,
      'students': students?.map((student) => student.toMap()).toList(),
    };
  }

  static List<StudentCourseDetails> getEnrolledStudentsList(
      Map<String, dynamic> map) {
    List<StudentCourseDetails> tempStudentsList = [];
    if (map['students'] != null) {
      map['students'].forEach((studentMap) {
        StudentCourseDetails student = StudentCourseDetails.fromMap(studentMap);
        tempStudentsList.add(student);
      });
      return tempStudentsList;
    }
    return tempStudentsList;
  }

  factory CoursesDetails.fromMap(Map<String, dynamic> map) {
    print('Map $map');

    return CoursesDetails(
      course_id: map['course_ID'] ?? 'n/a',
      number_of_modules: map['number_of_modules'] ?? 0,
      course_name: map['course_name'] ?? 'n/a',
      number_of_exams: map['number_of_exams'] ?? 0,
      students: getEnrolledStudentsList(map),
    );
  }
}
