import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CourseProvider extends ChangeNotifier {
  /// Converts a JSON to a type of _JsonMap (which is Map<String, dynamic> type)

  static dynamic _allCourses = [];
  static Map<String, dynamic> _mostRecentFetchedCourse = {};

  static Future<Map<String, dynamic>> parseJsonAsMap() async {
    String jsonString = await rootBundle.loadString('assets/data/all_courses/courses.json');

    return json.decode(jsonString);
  }

  /// Searches for Course details by ID from the database and returns the details.
  //For now, we get this data from JSON
  /*  For now this is of type <dynamic> since the courses are inside a list in JSON but in Firestore
      later on we will have the courses inside a map
      The courses will be a map of course ID which will be the collectionID */
  static Future<dynamic> getAllCourses() async {
    Map<String, dynamic> jsonCoursesData = await parseJsonAsMap(); //for now we are using JSON data
    _allCourses = jsonCoursesData['coursesList'];
    /*
    * We can create a new function later for separating out the fetching data bit into specificallly from JSON or
    * from Firestore
    * */

    return _allCourses;
  }

  ///This function returns a map of the course that needs to be fetched.
  static Future<Map<String, dynamic>> getCourseByID({String? courseId}) async {
    Map<String, dynamic> fetchedCourse =
        {}; //this variable will store the course that needs to be fetched from the local storage

    _allCourses = await CourseProvider.getAllCourses();

    /* As of now, the courses are inside a list, so we iterate through the list  and fetch the course
    * That we need. Later when we fetch data from Firestore, we can separate this out to a helper function
    * That gets the map of all courses from Firestore and iterates through uit, and returns a Map of
    * The course that we need. The return type of this function remains the same.*/
    for (Map<String, dynamic> course in _allCourses) {
      if (course['courseId'] == courseId) {
        fetchedCourse = course;
      }
    }
    _mostRecentFetchedCourse = fetchedCourse;
    return fetchedCourse; //returns the course fetched by Id
  }

  /// This function gets the list of Course sections, for the course  with
  ///  the given course Id. It always returns a List<Map<String, dynamic>>
  static Future<List> getSectionsForCourse({required String courseId}) async {
    List courseSections = [];
    if (_mostRecentFetchedCourse.isEmpty || _mostRecentFetchedCourse['courseId'] != courseId) {
      _mostRecentFetchedCourse = await getCourseByID(courseId: courseId);
    }
    courseSections = _mostRecentFetchedCourse['courseSections'];
    print(courseSections);
    return courseSections;
  }

  /// This function gets the length of the list of course sections, for the course  with
  /// the given course Id. It always returns an int.
  static Future<int> getSectionsCountForCourse({required String courseId}) async {
    int courseSectionsLength = 0;
    if (_mostRecentFetchedCourse.isEmpty || _mostRecentFetchedCourse['courseId'] != courseId) {
      _mostRecentFetchedCourse = await getCourseByID(courseId: courseId);
    }
    courseSectionsLength = _mostRecentFetchedCourse['courseSections'].length;
    return courseSectionsLength;
  }
}
