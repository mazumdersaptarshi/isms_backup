class UserCoursesDetails {
  List<dynamic>? courses_completed;
  List<dynamic>? courses_started;

  UserCoursesDetails({
    this.courses_completed,
    this.courses_started,
  });

  factory UserCoursesDetails.fromMap(Map<String, dynamic> map) {
    return UserCoursesDetails(
      courses_started: map['courses_started'] ?? [],
      courses_completed: map['courses_completed'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courses_started': courses_started,
      'courses_completed': courses_completed,
    };
  }
}
