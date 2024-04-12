class CourseAssignmentInfo {
  String courseId;
  bool enabled;
  String completionDeadline;

  String recurringInterval;
  String trackingStart;

  CourseAssignmentInfo({
    required this.courseId,
    required this.enabled,
    required this.completionDeadline,
    required this.recurringInterval,
    required this.trackingStart,
  });
}
