class UsersAnalytics {
  static Map _allCoursesAllExamsMap = {};

  static dynamic showAllUsersData({
    required Map allUsersData,
    required dynamic allCoursesData,
    required dynamic allExamsData,
  }) {
    _setAllCourseIDsAsKeys(allCoursesData: allCoursesData);
    _addAllExamsToRespectiveCourses(allExamsData: allExamsData);

    allUsersData.forEach((key, individualUserData) {
      individualUserData.forEach((key, allUserProgressItems) {
        var userId;

        print(key);
        if (key == 'userId') {
          userId = allUserProgressItems;
        }
        if (key == 'exams') {
          allUserProgressItems.forEach((key, value) {
            print(key);
            var valueMap = value.toMap();
            print(valueMap);
            var map = {userId: valueMap};
            print(_allCoursesAllExamsMap[valueMap['courseId']][valueMap['examId']]);
          });
        }
      });
    });
    return _allCoursesAllExamsMap;

    print(allUsersData);
  }

  static void _setAllCourseIDsAsKeys({required List allCoursesData}) {
    for (var course in allCoursesData) {
      _allCoursesAllExamsMap[course['courseId']] = '';
    }
    // print('_allCoursesAllExamsMap: $_allCoursesAllExamsMap');
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
