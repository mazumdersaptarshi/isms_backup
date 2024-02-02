import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/storage/firebase_service/firebase_service.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';

class AdminDataHandler {
  static Future<Map<String, dynamic>> getUser(String uid) async {
    Map<String, dynamic> userData = await FirebaseService.getUserDataFromFirestore(uid);
    return userData;
  }

  static Future<Map> getAllUsersData() async {
    return await HiveService.getExistingLocalDataFromUsersBox();
  }
}
