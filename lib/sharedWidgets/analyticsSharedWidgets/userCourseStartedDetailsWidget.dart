import 'package:flutter/material.dart';

import '../../projectModules/courseManagement/coursesProvider.dart';
import '../../utilityFunctions/getCourseCompletedPercentage.dart';
import 'courseDropdownWidget.dart';

class UserCourseStartedDetailsWidget extends StatelessWidget {
  UserCourseStartedDetailsWidget(
      {super.key,
      required this.courseItem,
      required this.coursesProvider,
      required this.index});
  final Map<String, dynamic> courseItem;
  final CoursesProvider coursesProvider;
  final int index;
  // Map<String, dynamic> getCourseCompletedPercentage() {
  //   double courseCompletionPercentage = 0;
  //   int noOfExams = 0;
  //   bool isValid = false;
  //   debugPrint('Enrolled CoursesDropdown');
  //
  //   int modulesCount = 0;
  //
  //   for (int i = 0; i < coursesProvider.allCourses.length; i++) {
  //     var element = coursesProvider.allCourses[i];
  //
  //     if (element.name == courseItem["course_name"]) {
  //       modulesCount = element.modulesCount!;
  //       noOfExams = element.examsCount!;
  //       isValid = true;
  //     }
  //   }
  //
  //   int modulesCompletedCount = courseItem["modules_completed"] != null
  //       ? courseItem["modules_completed"].length
  //       : 0;
  //   if (isValid) {
  //     courseCompletionPercentage = modulesCompletedCount / modulesCount;
  //   }
  //
  //   return {
  //     "isValid": isValid,
  //     "courseCompletionPercentage": courseCompletionPercentage,
  //     "noOfExams": noOfExams
  //   };
  // }
  // Map<String, dynamic> res = getCourseCompletedPercentage();

  @override
  Widget build(BuildContext context) {
    var courseDetailsData =
        getCourseCompletedPercentage(courseItem, coursesProvider, index);
    return CourseDropdownWidget(
      courseItem: courseItem,
      courseDetailsData: courseDetailsData,
      detailType: 'courses_enrolled',
    );
  }
}
