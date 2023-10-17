class CustomUser {
  String username;
  String email;
  String role;
  List<Courses> courses;

  CustomUser({
    required this.username,
    required this.email,
    required this.role,
    required this.courses,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'role': role,
      'course_completed': courses.map((course) => course.toMap()).toList(),
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      username: map['username'],
      email: map['email'],
      role: map['role'],
      courses: (map['courses'] as List)
          .map((courseMap) => Courses.fromMap(courseMap))
          .toList(),
    );
  }
}

class Courses {
  String course_ID;
  int course_percent_completed;
  List<ModuleDetails> course_details;

  Courses(
      {required this.course_ID,
      required this.course_percent_completed,
      required this.course_details});

  Map<String, dynamic> toMap() {
    return {
      'course_ID': course_ID,
      'course_percent_completed': course_percent_completed,
      'course_details': course_details.map((module) => module.toMap()).toList(),
    };
  }

  factory Courses.fromMap(Map<String, dynamic> map) {
    return Courses(
      course_ID: map['course_ID'],
      course_percent_completed: map['course_percent_completed'],
      course_details: (map['course_details'] as List)
          .map((moduleMap) => ModuleDetails.fromMap(moduleMap))
          .toList(),
    );
  }
}

class ModuleDetails {
  String module_ID;
  bool isPassed;
  String module_name;
  int module_percent_completed;

  ModuleDetails(
      {required this.module_ID,
      required this.isPassed,
      required this.module_name,
      required this.module_percent_completed});

  Map<String, dynamic> toMap() {
    return {
      'module_ID': module_ID,
      'isPassed': isPassed,
      'module_name': module_name,
      'module_percent_completed': module_percent_completed,
    };
  }

  factory ModuleDetails.fromMap(Map<String, dynamic> map) {
    return ModuleDetails(
      module_ID: map['module_ID'],
      isPassed: map['isPassed'],
      module_name: map['module_name'],
      module_percent_completed: map['module_percent_completed'],
    );
  }
}
