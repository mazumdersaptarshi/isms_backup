// ignore_for_file: file_names, non_constant_identifier_names

class CustomUser {
  String username;
  String email;
  String role;
  String uid;
  String domain;
  List<dynamic> courses_started;
  List<dynamic> courses_completed;

  CustomUser(
      {required this.username,
      required this.email,
      required this.role,
      required this.courses_started,
      required this.courses_completed,
      required this.uid,
      required this.domain});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'role': role,
      'courses_started': courses_started,
      'courses_completed': courses_completed,
      'uid': uid,
      'domain': domain,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    CustomUser customUser = CustomUser(
        username: map['username'],
        email: map['email'],
        role: map['role'] ?? "",
        courses_started: map['courses_started'] ?? [],
        courses_completed: map['courses_completed'] ?? [],
        uid: map["uid"],
        domain: map['domain'] ?? "");
    return customUser;
  }
}
