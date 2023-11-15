// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../utilityFunctions/csvDataHandler.dart';
import 'courseExamsCompletedDropdownWidget.dart';
import 'modulesDetailsDropdownWidget.dart';

class CourseDropdownWidget extends StatelessWidget {
  const CourseDropdownWidget(
      {super.key,
      required this.courseItem,
      this.courseDetailsData,
      required this.detailType,
      this.completedModules});

  final Map<String, dynamic> courseItem;
  final List<Map<String, dynamic>>? completedModules;
  final Map<String, dynamic>? courseDetailsData;
  final String detailType;

  @override
  Widget build(BuildContext context) {
    debugPrint('iolk: $courseDetailsData');
    return Card(
      margin: const EdgeInsets.all(4.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align children to the start of the cross axis
          children: [
            ExpansionTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu_book_rounded),
                        const SizedBox(
                          width: 10,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.5),
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            '${courseItem["course_name"]}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                        )
                      ],
                    ),
                    if (detailType == 'courses_enrolled')
                      CircularPercentIndicator(
                        radius: 20.0,
                        lineWidth: 5.0,
                        percent: (courseDetailsData?[
                                    "courseCompletionPercentage"]) >
                                1
                            ? 1
                            : courseDetailsData?["courseCompletionPercentage"]!,
                        center: Text(
                          '${(courseDetailsData?["courseCompletionPercentage"] * 100).floor()}%',
                          style: const TextStyle(fontSize: 10),
                        ),
                        progressColor:
                            ((courseDetailsData?["courseCompletionPercentage"] *
                                            100)
                                        .floor() >=
                                    100)
                                ? Colors.lightGreen
                                : Colors.yellow.shade900,
                      ),
                    if (detailType == 'courses_completed')
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.lightGreen,
                      ),
                  ]),
              children: [
                Column(
                  children: [
                    if (courseItem['courseID'] != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(minHeight: 50),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'CourseID:  ',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${courseItem['courseID']}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Colors.grey.shade100,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Completed at:  ',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      (courseItem['started_at'] != null)
                                          ? Text(
                                              CSVDataHandler
                                                  .timestampToReadableDate(
                                                      courseItem['started_at']),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary),
                                            )
                                          : Text('n/a',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary)),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  // color: Colors.grey.shade100,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Started at:  ',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      (courseItem['completed_at'] != null &&
                                              courseItem['completed_at']
                                                  is Timestamp)
                                          ? Text(
                                              CSVDataHandler
                                                  .timestampToReadableDate(
                                                      courseItem[
                                                          'completed_at']),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary),
                                            )
                                          : Text('n/a',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (courseItem["exams_completed"] != null)
                      CourseExamsCompletedDropdownWidget(
                          courseItem: courseItem,
                          courseDetailsData: courseDetailsData),
                    if (courseItem["modules_started"] != null)
                      CourseModulesDropdownWidget(
                          'Modules',
                          courseItem["modules_started"] ?? [],
                          courseItem["modules_completed"] ?? [],
                          context),
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
