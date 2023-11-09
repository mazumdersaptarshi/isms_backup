// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../adminManagement/adminProvider.dart';

class AllCoursesDropdown extends StatelessWidget {
  const AllCoursesDropdown({super.key, required this.adminProvider});
  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: adminProvider.allCoursesDataFetcher(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          return _buildCourseList(snapshot.data!);
        }
        return const Text('Could not load data, unforseen error!');
      },
    );
  }

  Widget _buildCourseList(List<dynamic> courses) {
    return ListView.builder(
      itemCount: courses.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin:
              const EdgeInsets.all(4.0), // Add margin for spacing between cards
          elevation: 4.0, // Adds shadow beneath the card
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Rounded edges for the card
          ),
          child: ExpansionTile(
            title: Text(
              '${index + 1}.  ${courses[index].course_name}',
              style: const TextStyle(fontSize: 14),
            ),
            children: [
              CourseDetailExpansionTile(
                adminProvider: adminProvider,
                course: course,
                courses: courses,
                index: index,
                title: 'Completed',
              ),
              CourseDetailExpansionTile(
                  adminProvider: adminProvider,
                  course: course,
                  courses: courses,
                  index: index,
                  title: 'Started')
            ],
          ),
        );
      },
    );
  }
}

class CourseDetailExpansionTile extends StatelessWidget {
  const CourseDetailExpansionTile({
    super.key,
    required this.adminProvider,
    required this.course,
    required this.courses,
    required this.index,
    required this.title,
  });

  final AdminProvider adminProvider;
  final dynamic course;
  final List<dynamic> courses;
  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: (title == 'Completed')
          ? CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 5.0,
              percent: (courses[index].course_completed!.length /
                      (adminProvider.userRefs.length)) ??
                  0,
              center: Text(
                  '${(courses[index].course_completed!.length / (adminProvider.userRefs.length) * 100).round()}%',
                  style: const TextStyle(fontSize: 10)),
              progressColor: Colors.green,
            )
          : (title == 'Started')
              ? CircularPercentIndicator(
                  radius: 20.0,
                  lineWidth: 5.0,
                  percent: (courses[index].course_started!.length /
                          (adminProvider.userRefs.length)) ??
                      0,
                  center: Text(
                    '${(courses[index].course_started!.length / (adminProvider.userRefs.length) * 100).round()}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                  progressColor: Colors.yellow.shade900,
                )
              : const Text('n/a'),
      children: [
        if (title == 'Completed')
          for (var student in courses[index].course_completed!)
            Text(
              '${student['username']}',
              style: const TextStyle(color: Colors.green),
            ),
        if (title == 'Started')
          for (var student in courses[index].course_started!)
            Text(
              '${student['username']}',
              style: TextStyle(color: Colors.yellow.shade900),
            ),
      ],
    );
  }
}
