// ignore_for_file: file_names, non_constant_identifier_names

class StudentCourseDetails {
  String user_ID;
  num course_percent_completed;
  String email;
  num exams_percent_completed;
  bool isPassed;

  StudentCourseDetails(
      {required this.user_ID,
      required this.course_percent_completed,
      required this.email,
      required this.exams_percent_completed,
      required this.isPassed});

  Map<String, dynamic> toMap() {
    return {
      'user_ID': user_ID,
      'course_percent_completed': course_percent_completed,
      'email': email,
      'exams_percent_completed': exams_percent_completed,
      'isPassed': isPassed,
    };
  }

  static StudentCourseDetails fromMap(Map<String, dynamic> map) {
    return StudentCourseDetails(
      user_ID: map['user_ID'] ?? 'n/a',
      course_percent_completed: map['course_percent_completed'] ?? 0.0,
      email: map['email'] ?? 'n/a',
      exams_percent_completed: map['exams_percent_completed'] ?? 0.0,
      isPassed: map['isPassed'] ?? false,
    );
  }
}
