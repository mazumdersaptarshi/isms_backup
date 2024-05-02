import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/utils/utils.dart';
import 'package:isms/models/course/section_overview.dart';
import 'package:isms/models/course/user_assigned_course_overview.dart';
import 'package:http/http.dart' as http;

class CourseProvider extends ChangeNotifier {
  static const String remoteFetchUrl =
      'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/get2';
  static List<UserAssignedCourseOverview> _assignedCourses = [];
  static bool courseStatusChanged = false;

  static Future<List<UserAssignedCourseOverview>> fetchAssignedCoursesOverviewData(
      {required String loggedInUserId}) async {
    if (_assignedCourses.isEmpty || courseStatusChanged == true) {
      _assignedCourses = [];
      Map<String, dynamic> requestParams = {'userID': loggedInUserId};
      String jsonString = jsonEncode(requestParams);
      String encodedJsonString = Uri.encodeComponent(jsonString);
      http.Response response =
          await http.get(Uri.parse('$remoteFetchUrl?flag=assigned_courses_list_for_user&params=$encodedJsonString'));
      List<dynamic> jsonResponse = [];
      if (response.statusCode == 200) {
        // Check if the request was successful
        // Decode the JSON string into a Dart object (in this case, a List)
        jsonResponse = jsonDecode(response.body);
      }
      for (List<dynamic> jsonCourse in jsonResponse) {
        Map<String, dynamic> courseMap = jsonCourse.first as Map<String, dynamic>;
        // UserAssignedCourseOverview course = UserAssignedCourseOverview.fromJson(courseMap);
        List<SectionOverview> sections = [];
        for (Map<String, dynamic> section in courseMap['courseSections']) {
          sections.add(SectionOverview.fromJson(section));
        }
        UserAssignedCourseOverview course = UserAssignedCourseOverview(
          courseId: courseMap['courseId'] ?? '',
          courseVersion: courseMap['contentVersion'] ?? '0',
          courseTitle: courseMap['courseTitle'] ?? '',
          courseSummary: courseMap['courseSummary'] ?? '',
          courseDescription: courseMap['courseDescription'] ?? '',
          courseSections: sections ?? [],
          courseExams: [],
          allSectionIds: courseMap['allSectionIds'] ?? [],
          completedSections: courseMap['completedSections'] ?? [],
        );
        _assignedCourses.add(course);
      }
      courseStatusChanged = false;
    }

    return _assignedCourses;
  }
}
