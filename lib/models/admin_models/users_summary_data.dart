class UsersSummaryData {
  String uid;
  String? name;

  String? emailId;

  String? role;

  double? coursesCompletedPercentage;

  double? coursesLearningCompletedPercentage;
  int? coursesAssigned;
  int? examsTaken;

  int? examsPending;
  double? averageScore;
  String? lastLogin;

  UsersSummaryData({
    required this.uid,
    this.name,
    this.emailId,
    this.role,
    this.coursesCompletedPercentage,
    this.coursesLearningCompletedPercentage,
    this.coursesAssigned,
    this.averageScore,
    this.examsTaken,
    this.examsPending,
    this.lastLogin,
  });
}
