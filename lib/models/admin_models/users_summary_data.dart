import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';

class UsersSummaryData implements SelectableItem {
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

  @override
  String get itemId => uid;

  @override
  String get itemName => name ?? 'n/a';
}
