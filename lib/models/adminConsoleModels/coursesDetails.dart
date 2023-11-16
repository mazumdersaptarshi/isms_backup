// ignore_for_file: file_names, non_constant_identifier_names


class CoursesDetails {
  String course_id;
  String course_name;
  List<dynamic>? course_completed;
  List<dynamic>? course_started;

  CoursesDetails(
      {required this.course_id,
      required this.course_name,
      this.course_started,
      this.course_completed});

  Map<String, dynamic> toMap() {
    return {
      'course_id': course_id,
      'course_name': course_name,
    };
  }

  factory CoursesDetails.fromMap(Map<String, dynamic> map) {
    return CoursesDetails(
      course_id: map['course_ID'] ?? 'n/a',
      course_name: map['course_name'] ?? 'n/a',
      course_started: map['course_started'] ?? [],
      course_completed: map['course_completed'] ?? [],
    );
  }
}
