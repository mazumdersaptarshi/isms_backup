class CustomUser {
  String username;
  String email;
  String role;
  String? uid;

  List<dynamic> courses_started;
  List<dynamic> courses_completed;

  CustomUser({
    required this.username,
    required this.email,
    required this.role,
    required this.courses_started,
    required this.courses_completed,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'role': role,
      'courses_started': courses_started,
      'courses_completed': courses_completed,
      'uid': this.uid,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    print(map['username']);
    print(map['courses_started']);
    CustomUser customUser = CustomUser(
        username: map['username'],
        email: map['email'],
        role: map['role'] ?? "",
        courses_started: map['courses_started'] ?? [],
        courses_completed: map['courses_completed'] ?? [],
        uid: map["uid"]);
    print('courses_completed: ${customUser.courses_completed}');
    return customUser;
  }
}
