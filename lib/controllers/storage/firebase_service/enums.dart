/// Collections in Firebase
enum FirebaseCollections { userCourseProgress, userExamAttempts, users }

/// Field names for documents in the `userCourseProgress` collection
enum UserCourseProgressFields { completedExams, completedSections, courseCompleted, courseId, currentSection, userId }

/// Field names for documents in the `userExamAttempts` collection
enum UserExamAttemptsFields { courseId, endTime, examId, passed, responses, score, startTime, userId }

/// Firebase query operators
enum QueryOperators {
  isEqualTo("=="),
  isNotEqualTo("!="),
  isLessThan("<"),
  isLessThanOrEqualTo("<="),
  isGreaterThan(">"),
  isGreaterThanOrEqualTo(">="),
  whereIn("in"),
  whereNotIn("not_in"),
  arrayContains("array_contains"),
  arrayContainsAny("array_contains_any");

  final String name;

  /// Overrides the default return value of the extension name getter method to get the value specified in brackets,
  /// instead of just the source identifier value.
  /// For example, `QueryOperators.isEqualTo.name` will return `==`, not `isEqualTo`.
  const QueryOperators(this.name);
}
