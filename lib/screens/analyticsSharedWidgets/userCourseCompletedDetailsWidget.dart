import 'package:flutter/material.dart';

import '../../projectModules/courseManagement/coursesProvider.dart';
import 'courseDropdownWidget.dart';

class UserCourseCompletedDetailsWidget extends StatelessWidget {
  UserCourseCompletedDetailsWidget(
      {super.key,
      required this.courseItem,
      required this.coursesProvider,
      required this.index});
  var courseItem;
  CoursesProvider coursesProvider;
  int index;

  @override
  Widget build(BuildContext context) {
    return CourseDropdownWidget(
      courseItem: courseItem,
      detailType: 'courses_completed',
    );
  }
}
