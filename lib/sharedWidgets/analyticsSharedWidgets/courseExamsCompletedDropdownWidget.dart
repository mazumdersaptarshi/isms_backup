// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CourseExamsCompletedDropdownWidget extends StatelessWidget {
  const CourseExamsCompletedDropdownWidget({
    super.key,
    required this.courseItem,
    required this.courseDetailsData,
  });

  final Map<String, dynamic> courseItem;
  final Map<String, dynamic>? courseDetailsData;
  int ensureInt(dynamic value) {
    if (value is int) {
      return value;
    } else {
      try {
        return int.parse(value.toString());
      } catch (e) {
        debugPrint('Value cannot be converted to an int: $e');
        return 0; // Default value or handle as appropriate
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int examsCompletedCount = ensureInt(courseItem["exams_completed"].length);
    int noOfExams = ensureInt(courseDetailsData?["noOfExams"] ?? 0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Exam completed: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${courseItem["exams_completed"].length} of ${courseDetailsData?["noOfExams"]}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: (examsCompletedCount < noOfExams)
                  ? Icon(
                      Icons.pending_rounded,
                      color: Colors.orangeAccent,
                    )
                  : Icon(
                      Icons.check_circle_rounded,
                      color: Colors.lightGreen,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
