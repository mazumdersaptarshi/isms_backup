class UsersListData {
  String username;

  String? emailId;

  String? role;

  double? coursesCompletedPercentage;
  int? coursesEnrolled;
  int? examsTaken;
  double? averageScore;
  String? lastLogin;

  UsersListData({
    required this.username,
    this.emailId,
    this.role,
    this.coursesCompletedPercentage,
    this.coursesEnrolled,
    this.averageScore,
    this.examsTaken,
    this.lastLogin,
  });
}
