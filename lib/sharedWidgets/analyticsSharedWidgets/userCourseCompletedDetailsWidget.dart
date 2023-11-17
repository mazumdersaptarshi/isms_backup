// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../projectModules/courseManagement/coursesProvider.dart';
import '../../utilityFunctions/getCourseCompletedPercentage.dart';
import 'courseDropdownWidget.dart';

class UserCourseCompletedDetailsWidget extends StatelessWidget {
  const UserCourseCompletedDetailsWidget(
      {super.key,
      required this.courseItem,
      required this.coursesProvider,
      required this.index});
  final Map<String, dynamic> courseItem;
  final CoursesProvider coursesProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> courseDetailsData =
        getCourseCompletedPercentage(courseItem, coursesProvider);
    return CourseDropdownWidget(
      courseItem: courseItem,
      courseDetailsData: courseDetailsData,
      detailType: 'courses_completed',
    );
  }
}
