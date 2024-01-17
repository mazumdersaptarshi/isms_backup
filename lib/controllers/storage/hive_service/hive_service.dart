import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:isms/controllers/domain_management/domain_provider.dart';
import 'package:isms/services/hive/config/config.dart';
import 'package:isms/services/hive/hive_adapters/user_attempts.dart';
import 'package:isms/services/hive/hive_adapters/user_course_progress.dart';
import 'package:isms/services/hive/hive_adapters/user_exam_progress.dart';
import 'package:logging/logging.dart';

class HiveService {
  //class variables
  static final Logger _logger = Logger('HiveService');

  static const String _usersBoxName = 'users';

  // static final String _coursesFieldName = 'courses';

  static late Box _box;
  static Map<String, dynamic> _userData = {};
  static Map _allUsersData = {};

  static dynamic _userProgress;

  /// Registers the adapters required for the custom objects used in Hive
  /// This should be called during app initialization
  static void registerAdapters() {
    Hive.registerAdapter(UserCourseProgressHiveAdapter());
    Hive.registerAdapter(UserExamProgressHiveAdapter());
    Hive.registerAdapter(UserAttemptsAdapter());

    // Register other adapters as needed
  }

  /// Updates existing user data with the local course progress data in Hive, for the current user.
  ///
  /// This function retrieves the user's existing data from the Hive box and updates it
  /// with the provided course progress data. If an error occurs during this process,
  /// it is caught and logged.
  ///
  /// [data] A map containing the progress data for the course.
  /// [currentUser] The user whose course progress is being updated.
  static Future<void> updateLocalData(Map<String, dynamic> data, User currentUser, String fieldName, String key) async {
    //Declaring a Hive Box variable to store the Hive box
    try {
      _box = Hive.box(_usersBoxName); //Opens existing Hive box 'users'

      final userIdKey = currentUser.uid;
      // Ensures there is existing user data to be fetched.

      await ensureLocalDataExists(currentUser);
      /* Fetch the existing User Data, and update it with the new data
      being passed to this function
       */
      final existingUserData =
          Map<String, dynamic>.from(await _box.get(userIdKey)); // Gets the existing User data from the Hive Box

      if (fieldName == DatabaseFields.courses.name) {
        _userProgress = UserCourseProgressHive.fromMap(data);
      } else if (fieldName == DatabaseFields.exams.name) {
        _userProgress = UserExamProgressHive.fromMap(data);
      } else {
        _logger.severe('Invalid Field Id, the given field ${fieldName} does not exist in Hive!');
      }
      //Updating the existingUserData variable with new Progress Data
      existingUserData[fieldName][key] = _userProgress;

      //putting the Updated users data in Hive
      _box.put(userIdKey, existingUserData);
      _logger.info('Successfully updated course progress for user $userIdKey.');
      _logger.info(existingUserData[fieldName][key]);

      // Create an instance of UserCourseProgressHive with the current progress data.
    } catch (e) {
      // Log any exceptions that occur during the update process.
      _logger.severe('There was an error in updating the local course progress data ', e);
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
  static Future<void> ensureLocalDataExists(User? user) async {
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
      _logger.info('No stored local data found, creating local data for user $userId');
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
        "exams": {},
      };
      // Save the newly created default user data to the Hive box.
      await _box.put('${user?.uid}', localUserData);
      // Log an info message indicating successful creation of local user data.
      _logger.info('Local user data created for UID: $userId');
    } else {
      _logger.info('Local user data exists for UID: $userId');
    }
  }

  static Future<Map<String, dynamic>> getExistingLocalDataForUser(User? user) async {
    _box = Hive.box(_usersBoxName);
    print(_box);
    dynamic data = await _box.get(user?.uid);

    _userData = Map<String, dynamic>.from(data);
    print(_userData);

    // _userData = await _box.get(user?.uid);
    try {
      return _userData;
    } catch (e) {
      _logger.severe(
          'Retrieving failed, there maybe an error with the field name, field Id, box name, or the data does not exist');
    }
    return _userData;
  }

  static Map getExistingLocalDataFromUsersBox() {
    try {
      _box = Hive.box(_usersBoxName);
      _allUsersData = _box.toMap();
    } catch (e) {
      _logger.severe(
          'Retrieving failed, there maybe an error with the field name, field Id, box name, or the data does not exist');
    }
    print(_allUsersData);
    return _allUsersData;
  }

  static Future<void> clearLocalHiveData() async {
    final box = Hive.box(_usersBoxName);
    box.clear();
  }
}
