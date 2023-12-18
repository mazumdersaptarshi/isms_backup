import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:isms/controllers/domain_management/domain_provider.dart';
import 'package:isms/models/enums.dart';
import 'package:isms/services/hive/hive_adapters/user_course_progress.dart';
import 'package:logging/logging.dart';

class HiveService {
  //class variables
  static final Logger _logger = Logger('HiveService');

  static final String _usersBoxName = 'users';
  static final String _coursesFieldName = 'courses';
  static late Box _box;

  /// Registers the adapters required for the custom objects used in Hive
  /// This should be called during app initialization
  static void registerAdapters() {
    Hive.registerAdapter(UserCourseProgressHiveAdapter());
    // Register other adapters as needed
  }

  /// Updates existing user data with the local course progress data in Hive, for the current user.
  ///
  /// This function retrieves the user's existing data from the Hive box and updates it
  /// with the provided course progress data. If an error occurs during this process,
  /// it is caught and logged.
  ///
  /// [newProgressData] A map containing the progress data for the course.
  /// [currentUser] The user whose course progress is being updated.
  static Future<void> updateCourseWithNewProgressLocal(
      Map<String, dynamic> newProgressData, User currentUser) async {
    //Declaring a Hive Box variable to store the Hive box
    try {
      _box = Hive.box(_usersBoxName); //Opens existing Hive box 'users'

      final userIdKey = currentUser.uid;
      // Ensures there is existing user data to be fetched.

      await ensureUserLocalDataExists(currentUser);
      /* First we need to fetch the existing user data and check the sections data present
      for that course ID, which contains the past and then we update the map present with that ID with the latest map
      of the progress
       */
      final existingUserData = Map<String, dynamic>.from(await _box
          .get(userIdKey)); // Gets the existing User data from the Hive Box

      Map<String, dynamic> sections = {};
      try {
        existingUserData[_coursesFieldName].forEach((key, value) {
          sections = value.sections;
          // print(sections);
          // print(value.sections);
          sections['${newProgressData['currentSectionId']}'] =
              newProgressData['currentSection'];
        });
      } catch (e) {
        sections['${newProgressData['currentSectionId']}'] =
            newProgressData['currentSection'];
        print(sections);
        _logger.severe('No sections found');
      }

      // Create an instance of UserCourseProgressHive with the current progress data.
      final userCourseProgressHive = UserCourseProgressHive(
        courseId: newProgressData[CourseKeys.courseId.name],
        courseTitle: newProgressData['courseTitle'],
        completionStatus: newProgressData['completionStatus'],
        currentSectionId: newProgressData['currentSectionId'],
        currentSection: newProgressData['currentSection'],
        sections: sections,
      );
      //Updating the existingUserData variable with the Course Progress
      existingUserData[_coursesFieldName]['${newProgressData['courseId']}'] =
          userCourseProgressHive;

      //putting the Updated users data in Hive
      _box.put(userIdKey, existingUserData);
      _logger.info('Successfully updated course progress for user $userIdKey.');
    } catch (e) {
      // Log any exceptions that occur during the update process.
      _logger.severe(
          'There was an error in updating the local course progress data ', e);
    }
  }

  /// Ensures that local data exists for the provided user.
  ///
  /// Checks the local Hive database for an entry corresponding to the user's UID.
  /// If no such entry exists, it creates a default data structure and saves it
  /// to the Hive box for future use.
  ///
  /// The local data structure includes the user's ID, username, email, role,
  /// domain, and a placeholder for course data.
  ///
  /// [user] The FirebaseAuth user object.
  /// [domain] The domain string to associate with the user (if any)
  static Future<void> ensureUserLocalDataExists(User? user) async {
    if (user == null) {
      _logger.warning('User is null, cannot ensure local data.');
      return;
    }
    // Open the Hive box where user data is stored.
    _box = Hive.box(_usersBoxName);
    // Retrieve the unique user ID from the FirebaseAuth user object.
    final String userId = user.uid;
    // Attempt to retrieve existing data for this user from the Hive box.
    final existingData = _box.get(userId);

    if (existingData == null) {
      // Create a map with default user data.
      _logger.info(
          'No stored local data found, creating local data for user $userId');
      //Fetching the domain of the user for the local data map
      DomainProvider domainProvider = DomainProvider();

      String domain = await domainProvider.getUserDomain(userId);
      Map<String, dynamic> localUserData = {
        "userId": userId,
        "username": user.displayName ?? 'n/a', // Provide a default value
        "email": user.email ?? 'n/a', // Provide a default value
        "role": "user",
        "domain": domain ?? 'n/a', // Provide a default value
        "courses": {},
      };
      // Save the newly created default user data to the Hive box.
      await _box.put('${user?.uid}', localUserData);
      // Log an info message indicating successful creation of local user data.
      _logger.info('Local user data created for UID: $userId');
    } else {
      _logger.info('Local user data exists for UID: $userId');
    }
  }

  static Future<dynamic> getExistingUserCourseLocalData(String? userId,
      {String? courseId}) async {
    final box = Hive.box(_usersBoxName);
    if (courseId == null) courseId = '';
    // Attempt to retrieve the user data from the box.
    final userData = await box.get(userId);

    // Ensure that the retrieved data is a Map<String, dynamic>.
    try {
      return userData['courses']['${courseId}'].sections;
    } catch (e) {
      _logger.severe('No local data currently exists for this, error');
      return userData;
    }
  }

  static Future<void> clearLocalHiveData() async {
    final box = Hive.box(_usersBoxName);
    box.clear();
  }
}
