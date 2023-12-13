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

  /// Searches for Course details by ID from Local storage and returns the details. For now, we get this data from JSON
  static Future<Map<String, dynamic>> getCourseByIDLocal(
      {String? courseId}) async {
    Map<String, dynamic> fetchedCourse =
        {}; //this variable will store the course that needs to be fetched from the local storage

    Map<String, dynamic> allCoursesData = await parseJsonAsMap(
        courseId: courseId); //for now we are using JSON data

    List coursesList =
        allCoursesData['coursesList']; // Gets the List of courses
    for (Map<String, dynamic> course in coursesList) {
      if (course['courseId'] == courseId) {
        fetchedCourse = course;
      }
    }
    return fetchedCourse; //returns the course fetched by Id
  }

  static Map<String, dynamic> getCourseSectionByIdLocal(
      {String? sectionId, List<dynamic>? sections}) {
    Map<String, dynamic> currentSection = {};
    for (Map<String, dynamic> section in sections!) {
      if (section['sectionId'] == sectionId) {
        currentSection = section;
      }
    }
    return currentSection;
  }

  static Future<void> deleteCourseProgressLocal() async {}
}
