import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/user_progress/user_course_assignment.dart';

class UserAssignCoursesList extends StatefulWidget {
  UserAssignCoursesList({super.key, required this.userSummaryData});

  UsersSummaryData userSummaryData;

  @override
  State<UserAssignCoursesList> createState() => _UserAssignCoursesListState();
}

class _UserAssignCoursesListState extends State<UserAssignCoursesList> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  late AdminState adminState;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserCoursesAssignment>(
      future: adminState.getUsersCourseAssignments(user: widget.userSummaryData),
      // Get the future from the map.
      builder: (context, snapshot) {
        // Check if the future has completed with data.
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // Display the fetched data.
          return Text(snapshot.data?.coursesAssigned.toString() ?? 'No data');
        } else {
          // Display a loading indicator or a placeholder while waiting.
          return CircularProgressIndicator();
        }
      },
    );
  }
}
