class UsersAnalytics {
  static Map _allCoursesAllExamsMap = {};

  static dynamic showAllUsersData({
    required Map allUsersData,
    required dynamic allCoursesData,
    required dynamic allExamsData,
  }) {
    allUsersData.forEach((key, individualUserData) {
      individualUserData.forEach((key, value) {
        if (key == 'courses') {}
      });
    });

    _setAllCourseIDsAsKeys(allCoursesData: allCoursesData);
    _addAllExamsToRespectiveCourses(allExamsData: allExamsData);
    return _allCoursesAllExamsMap;

    print(allUsersData);
  }

  static void _setAllCourseIDsAsKeys({required List allCoursesData}) {
    for (var course in allCoursesData) {
      _allCoursesAllExamsMap[course['courseId']] = '';
    }
    print('_allCoursesAllExamsMap: $_allCoursesAllExamsMap');
  }

  static void _addAllExamsToRespectiveCourses({required List allExamsData}) {
    Map examsMapForCourse = {};
    _allCoursesAllExamsMap.forEach((courseId, value) {
      examsMapForCourse = {};
      for (var exam in allExamsData) {
        if (courseId == exam['courseId']) {
          examsMapForCourse[exam['examId']] = [];
        }
      }

      _allCoursesAllExamsMap[courseId] = examsMapForCourse;
    });
    print(_allCoursesAllExamsMap);
  }
}
