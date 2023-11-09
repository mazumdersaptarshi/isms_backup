import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../adminManagement/adminProvider.dart';

class AllCoursesDropdown extends StatelessWidget {
  AllCoursesDropdown({super.key, required this.adminProvider});
  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: adminProvider.allCoursesDataFetcher(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          return _buildCourseList(snapshot.data!);
        }
        return Text('Could not load data, unforseen error!');
      },
    );
  }

  Widget _buildCourseList(List<dynamic> courses) {
    return ListView.builder(
      itemCount: courses.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: EdgeInsets.all(4.0), // Add margin for spacing between cards
          elevation: 4.0, // Adds shadow beneath the card
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Rounded edges for the card
          ),
          child: ExpansionTile(
            title: Text(
              '${index + 1}.  ${courses[index].course_name}',
              style: TextStyle(fontSize: 14),
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
                  title: 'Enrolled')
            ],
          ),
        );
      },
    );
  }
}

class CourseDetailExpansionTile extends StatelessWidget {
  CourseDetailExpansionTile({
    super.key,
    required this.adminProvider,
    required this.course,
    required this.courses,
    required this.index,
    required this.title,
  });

  final AdminProvider adminProvider;
  final dynamic course;
  List<dynamic> courses;
  int index;
  String title;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 12),
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
                  style: TextStyle(fontSize: 10)),
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
                    style: TextStyle(fontSize: 10),
                  ),
                  progressColor: Colors.orangeAccent,
                )
              : Text('n/a'),
      children: [
        Container(
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
  CourseCompletedUsersDropdown({required this.students});
  List<dynamic> students;
  int index = 0;
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
      padding: EdgeInsets.all(4),
      child: Column(
        children: courseUserNames,
      ),
    );
  }
}

class CourseEnrolledUsersDropdown extends StatelessWidget {
  CourseEnrolledUsersDropdown({
    required this.studentsEnrolled,
    this.studentsCompleted,
  });
  List<dynamic> studentsEnrolled;
  List<dynamic>? studentsCompleted;
  List<String> studentsCompletedUIDs = [];

  @override
  Widget build(BuildContext context) {
    for (var student in studentsCompleted!) {
      studentsCompletedUIDs.add(student['uid']);
    }
    List<CourseUserName> courseUserNames = [];
    for (int i = 0; i < studentsEnrolled.length; i++) {
      Map<String, dynamic> student = studentsEnrolled[i];
      studentsCompletedUIDs!.contains(student['uid'])
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
      padding: EdgeInsets.all(4),
      child: Column(
        children: courseUserNames,
      ),
    );
  }
}

class CourseUserName extends StatelessWidget {
  CourseUserName({
    super.key,
    required this.student,
    this.color,
    this.index,
    this.title,
    this.status,
  });

  Map<String, dynamic> student;
  Color? color;
  int? index;
  String? title = '';
  String? status = 'pending';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: (index! % 2 == 1) ? Colors.grey.shade100 : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(5)),
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
                  ? Icon(
                      Icons.pending_rounded,
                      color: Colors.orangeAccent,
                    )
                  : (status == 'completed')
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: Colors.lightGreen,
                        )
                      : Text(''),
          ],
        ),
      ),
    );
  }
}
