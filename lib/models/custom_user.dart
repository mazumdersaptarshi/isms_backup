// ignore_for_file: file_names, non_constant_identifier_names

class CustomUser {
  String username;
  String email;
  String role;
  String uid;
  String domain;

  CustomUser({
    required this.username,
    required this.email,
    required this.role,
    required this.uid,
    required this.domain,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'role': role,
      'uid': uid,
      'domain': domain,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    CustomUser customUser = CustomUser(
        username: map['username'],
        email: map['email'],
        role: map['role'] ?? "",
        uid: map["uid"],
        domain: map['domain'] ?? "");
    return customUser;
  }
}
