import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/storage/firebase_service/firebase_service.dart';

class AdminData {
  static Future<Map<String, dynamic>> getUser(String uid) async {
    Map<String, dynamic> userData =
        await FirebaseService.getUserDataFromFirestore(uid);
    return userData;
  }

  static Future<Map<String, dynamic>> getCourse(String courseId) {
    return CourseProvider.getCourseByIDLocal(courseId: courseId);
  }
}
