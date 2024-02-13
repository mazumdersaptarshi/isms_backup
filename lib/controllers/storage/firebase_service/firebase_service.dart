import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

import 'package:isms/controllers/storage/firebase_service/enums.dart';
import 'package:isms/models/user_progress/user_course_progress.dart';
import 'package:isms/models/user_progress/user_exam_attempt.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Logger _logger = Logger('FirebaseService');
  static Map<String, dynamic> _userData = {};

  static Future<Map<String, dynamic>> getUserDataFromFirestore(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection(FirebaseCollections.users.name).doc(uid).get();

      if (userDoc.exists) {
        _userData = userDoc.data() as Map<String, dynamic>;
        _logger.info('User data fetched for user $uid');
        return _userData;
      } else {
        _logger.severe('No user found with the uid!');
        return {};
      }
    } catch (e) {
      _logger.severe('Error fetching data from Firestore: $e');
      return {};
    }
  }

  /// Returns a List of [QuerySnapshot]s stored in custom [UserCourseProgress] objects.
  ///
  /// The [DocumentSnapshot]s contained within the [QuerySnapshot]s are fetched from the `userCourseProgress` collection.
  /// These results are conditionally filtered based on the fields which comprise the unique composite key of each document,
  /// passed to the function as optional named parameters:
  ///  - [userId]
  ///  - [courseId]
  static Future<List<QueryDocumentSnapshot<UserCourseProgress>>> getUserCourseProgress(
      {String? userId, String? courseId}) async {
    /// Base query which specifies only the target collection and custom object converters to use
    Query<UserCourseProgress> query =
        _firestore.collection(FirebaseCollections.userCourseProgress.name).withConverter<UserCourseProgress>(
              fromFirestore: (snapshot, _) => UserCourseProgress.fromJson(snapshot.data()!),
              toFirestore: (userCourseProgress, _) => userCourseProgress.toJson(),
            );
    _logger.info("Initialised base query for collection '${FirebaseCollections.userCourseProgress.name}'");

    // Append conditions to the base query as needed, depending on the parameters passed to the function
    if (userId != null) {
      query = query.where(UserCourseProgressFields.userId.name, isEqualTo: userId);
      _logger.info("Adding condition to filter on user ID '$userId'");
    }
    if (courseId != null) {
      query = query.where(UserCourseProgressFields.courseId.name, isEqualTo: courseId);
      _logger.info("Adding condition to filter on course ID '$courseId'");
    }

    // Execute the query, handling exceptions as necessary
    try {
      final List<QueryDocumentSnapshot<UserCourseProgress>> docs = await query.get().then((snapshot) => snapshot.docs);
      _logger.info('Query executed successfully; ${docs.length} total document(s) fetched');

      return docs;
    } on Exception catch (e) {
      _logger.severe('Error fetching data from Firestore: $e');
      rethrow;
    }
  }

  /// Returns a List of [QuerySnapshot]s stored in custom [UserExamAttempt] objects.
  ///
  /// The [DocumentSnapshot]s contained within the [QuerySnapshot]s are fetched from the `userCourseProgress` collection.
  /// These results are conditionally filtered based on the fields which comprise the unique composite key of each document,
  /// passed to the function as optional named parameters:
  ///  - [userId]
  ///  - [courseId]
  ///  - [examId]
  static Future<List<QueryDocumentSnapshot<UserExamAttempt>>> getUserExamAttempts(
      {String? userId, String? courseId, String? examId}) async {
    /// Base query which specifies only the target collection and custom object converters to use
    Query<UserExamAttempt> query =
        _firestore.collection(FirebaseCollections.userExamAttempts.name).withConverter<UserExamAttempt>(
              fromFirestore: (snapshot, _) => UserExamAttempt.fromJson(snapshot.data()!),
              toFirestore: (userExamAttempt, _) => userExamAttempt.toJson(),
            );
    _logger.info("Initialised base query for collection '${FirebaseCollections.userExamAttempts.name}'");

    // Append conditions to the base query as needed, depending on the parameters passed to the function
    if (userId != null) {
      query = query.where(UserExamAttemptsFields.userId.name, isEqualTo: userId);
      _logger.info("Adding condition to filter on user ID '$userId'");
    }
    if (courseId != null) {
      query = query.where(UserExamAttemptsFields.courseId.name, isEqualTo: courseId);
      _logger.info("Adding condition to filter on course ID '$courseId'");
    }
    if (examId != null) {
      query = query.where(UserExamAttemptsFields.examId.name, isEqualTo: examId);
      _logger.info("Adding condition to filter on exam ID '$examId'");
    }

    // Execute the query, handling exceptions as necessary
    try {
      final List<QueryDocumentSnapshot<UserExamAttempt>> docs = await query.get().then((snapshot) => snapshot.docs);
      _logger.info('Query executed successfully; ${docs.length} total document(s) fetched');

      return docs;
    } on Exception catch (e) {
      _logger.severe('Error fetching data from Firestore: $e');
      rethrow;
    }
  }
}
