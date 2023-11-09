// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'modulesDetailsDropdownWidget.dart';

class CourseDropdownWidget extends StatelessWidget {
  CourseDropdownWidget(
      {super.key,
      required this.courseItem,
      this.courseDetailsData,
      required this.detailType});

  var courseItem;
  final Map<String, dynamic>? courseDetailsData;
  String detailType;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align children to the start of the cross axis
          children: [
            ExpansionTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${courseItem["course_name"]}',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    if (detailType == 'courses_enrolled')
                      CircularPercentIndicator(
                        radius: 20.0,
                        lineWidth: 5.0,
                        percent:
                            courseDetailsData?["courseCompletionPercentage"]!,
                        center: Text(
                          '${(courseDetailsData?["courseCompletionPercentage"] * 100).ceil()}%',
                          style: const TextStyle(fontSize: 10),
                        ),
                        progressColor: Colors.yellow.shade900,
                      ),
                    if (detailType == 'courses_completed')
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.lightGreen,
                      ),
                  ]),
              children: [
                if (detailType == 'courses_enrolled')
                  Column(
                    children: [
                      if (courseItem["exams_completed"] != null)
                        Text(
                          'Exam completed: ${courseItem["exams_completed"].length} of ${courseDetailsData?["noOfExams"]}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      if (courseItem["modules_started"] != null)
                        CourseModulesDetailsDropdownWidget('Modules Started:',
                            courseItem["modules_started"], context),
                      if (courseItem["modules_completed"] != null)
                        CourseModulesDetailsDropdownWidget('Modules Completed:',
                            courseItem["modules_completed"], context),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
