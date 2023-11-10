import 'package:flutter/material.dart';

class CourseExamsCompletedDropdownWidget extends StatelessWidget {
  CourseExamsCompletedDropdownWidget({
    super.key,
    required this.courseItem,
    required this.courseDetailsData,
  });

  var courseItem;
  final Map<String, dynamic>? courseDetailsData;
  int ensureInt(dynamic value) {
    if (value is int) {
      return value;
    } else {
      try {
        return int.parse(value.toString());
      } catch (e) {
        print('Value cannot be converted to an int: $e');
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
      padding: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Exam completed: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${courseItem["exams_completed"].length} of ${courseDetailsData?["noOfExams"]}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: (examsCompletedCount < noOfExams)
                  ? const Icon(
                      Icons.pending_rounded,
                      color: Colors.orangeAccent,
                    )
                  : const Icon(
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
