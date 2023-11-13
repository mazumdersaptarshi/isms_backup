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
        return Card(
          margin:
              const EdgeInsets.all(4.0), // Add margin for spacing between cards
          elevation: 4.0, // Adds shadow beneath the card
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Rounded edges for the card
          ),
          child: ExpansionTile(
            title: Row(
              children: [
                Text(
                  '${index + 1}.  ',
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
                const Icon(Icons.menu_book_rounded),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Text(
                    '${courses[index].course_name}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ],
            ),
            children: [
              CourseDetailExpansionTile(
                adminProvider: adminProvider,
                // course: course,
                courses: courses,
                index: index,
                title: 'Completed',
              ),
              CourseDetailExpansionTile(
                  adminProvider: adminProvider,
                  // course: course,
                  courses: courses,
                  index: index,
                  title: 'Enrolled')
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
    // this.course,
    required this.courses,
    required this.index,
    required this.title,
  });

  final AdminProvider adminProvider;
  // final dynamic course;
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
              progressColor: Colors.lightGreen,
            )
          : (title == 'Enrolled')
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
                  progressColor: Colors.orangeAccent,
                )
              : const Text('n/a'),
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title == 'Enrolled')
                CourseEnrolledUsersDropdown(
                  studentsEnrolled: courses[index].course_started ?? [],
                  studentsCompleted: courses[index].course_completed ?? [],
                ),
              if (title == 'Completed')
                CourseCompletedUsersDropdown(
                    students: courses[index].course_completed!),
            ],
          ),
        ),
      ],
    );
  }
}

class CourseCompletedUsersDropdown extends StatelessWidget {
  const CourseCompletedUsersDropdown({super.key, required this.students});
  final List<dynamic> students;

  @override
  Widget build(BuildContext context) {
    List<CourseUserName> courseUserNames = [];
    for (int i = 0; i < students.length; i++) {
      Map<String, dynamic> student = students[i];
      courseUserNames.add(CourseUserName(
        student: student,
        color: Colors.lightGreen,
        index: i,
      ));
    }
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: courseUserNames,
      ),
    );
  }
}

class CourseEnrolledUsersDropdown extends StatelessWidget {
  const CourseEnrolledUsersDropdown({
    super.key,
    required this.studentsEnrolled,
    this.studentsCompleted,
  });
  final List<dynamic> studentsEnrolled;
  final List<dynamic>? studentsCompleted;

  @override
  Widget build(BuildContext context) {
    List<String> studentsCompletedUIDs = [];
    for (var student in studentsCompleted!) {
      studentsCompletedUIDs.add(student['uid']);
    }
    List<CourseUserName> courseUserNames = [];
    for (int i = 0; i < studentsEnrolled.length; i++) {
      Map<String, dynamic> student = studentsEnrolled[i];
      studentsCompletedUIDs.contains(student['uid'])
          ? courseUserNames.add(CourseUserName(
              student: student,
              color: Colors.lightGreen,
              index:
                  i, // This is the index of the student within course_completed
              title: 'enrolled',
              status: 'completed',
            ))
          : courseUserNames.add(CourseUserName(
              student: student,
              color: Colors.orangeAccent,
              index:
                  i, // This is the index of the student within course_completed
              title: 'enrolled',
              status: 'pending',
            ));
    }

    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: courseUserNames,
      ),
    );
  }
}

class CourseUserName extends StatelessWidget {
  const CourseUserName({
    super.key,
    required this.student,
    this.color,
    this.index,
    this.title = '',
    this.status = 'pending',
  });

  final Map<String, dynamic> student;
  final Color? color;
  final int? index;
  final String? title;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: (index! % 2 == 1) ? Colors.grey.shade100 : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${student['username']}',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary, fontSize: 12),
            ),
            if (title == 'enrolled')
              (status == 'pending')
                  ? const Icon(
                      Icons.pending_rounded,
                      color: Colors.orangeAccent,
                    )
                  : (status == 'completed')
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.lightGreen,
                        )
                      : const Text(''),
          ],
        ),
      ),
    );
  }
}
