import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CourseProvider extends ChangeNotifier {
  /// Converts a JSON to a type of _JsonMap (which is Map<String, dynamic> type)
  static Future<Map<String, dynamic>> parseJsonAsMap({String? courseId}) async {
    String jsonString =
        await rootBundle.loadString('assets/data/all_courses/courses.json');

    return json.decode(jsonString);
  }

  /// Searches for a course by its ID and returns the details
  static Future<Map<String, dynamic>> getCourseByID({String? courseId}) async {
    Map<String, dynamic> fetchedCourse = {};

    Map<String, dynamic> allCoursesData = await parseJsonAsMap(
        courseId:
            courseId); //for now we are using JSON data, later we will store data in Firebase

    List coursesList = allCoursesData['coursesList'];
    for (Map<String, dynamic> course in coursesList) {
      if (course['courseId'] == courseId) {
        fetchedCourse = course;
      }
    }
    return fetchedCourse;
  }
}
