import 'package:hive/hive.dart';

part 'user_attempts.g.dart';

/// A Hive data model to store information about a user's attempt on an exam.
///
/// This class uses Hive's type adapters to store and retrieve data from a local database.
/// Each field is annotated with `@HiveField` to indicate that it should be stored in Hive.
@HiveType(typeId: 3)
class UserAttempts {
  /// Default constructor for creating a new UserAttempts instance.
  ///
  /// [attemptId] Unique identifier for the attempt.
  /// [startTime] The start time of the attempt.
  /// [endTime] The end time of the attempt.
  /// [completionStatus] The completion status of the attempt.
  /// [score] The score achieved in the attempt.
  /// [responses] A list of responses given during the attempt.
  UserAttempts({
    this.attemptId,
    this.startTime,
    this.endTime,
    this.completionStatus,
    this.score,
    this.responses,
  });

  /// Constructs a UserAttempts instance from a map of key-value pairs.
  ///
  /// This constructor is useful for creating an instance from data structures
  /// that represent JSON or other map-based data formats.
  ///
  /// [data] The map containing the attempt data.
  UserAttempts.fromMap(Map<String, dynamic> data) {
    attemptId = data['attemptId'] as String?;
    startTime = data['startTime'].toString();
    endTime = data['endTime'].toString();
    completionStatus = data['completionStatus'] as String?;
    score = data['score'] as int?;
    responses = data['responses'] as List?;
  }

  Map<String, dynamic> toMap() {
    return {
      'attemptId': attemptId,
      'startTime': startTime,
      'endTime': endTime,
      'completionStatus': completionStatus,
      'score': score,
      'responses': responses
    };
  }

  @HiveField(0)
  String? attemptId; // Unique identifier for the attempt.

  @HiveField(1)
  String? startTime; // Start time of the attempt.

  @HiveField(2)
  String? endTime; // End time of the attempt.

  @HiveField(3)
  String? completionStatus; // Completion status of the attempt.

  @HiveField(4)
  int? score; // Score achieved in the attempt.

  @HiveField(5)
  List? responses; // List of responses given during the attempt.
}
