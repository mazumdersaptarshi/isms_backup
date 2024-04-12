import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/user_progress/user_course_assignment.dart';
import 'package:isms/views/widgets/admin_console/user_asigned_courses_list.dart';

class ViewUsersCoursesAssignmentsSection extends StatefulWidget {
  ViewUsersCoursesAssignmentsSection({super.key, required this.allDomainUsersSummary});

  List<UsersSummaryData> allDomainUsersSummary = [];

  @override
  State<ViewUsersCoursesAssignmentsSection> createState() => _ViewUsersCoursesAssignmentsSectionState();
}

class _ViewUsersCoursesAssignmentsSectionState extends State<ViewUsersCoursesAssignmentsSection> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  late AdminState adminState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.allDomainUsersSummary.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.allDomainUsersSummary.length,
            itemBuilder: (context, index) {
              var res;
              return ExpansionTile(
                title: Text('${widget.allDomainUsersSummary[index].name}'),
                children: [
                  // FutureBuilder<UserCoursesAssignment>(
                  //   future: adminState.getUsersCourseAssignments(user: widget.allDomainUsersSummary[index]),
                  //   // Get the future from the map.
                  //   builder: (context, snapshot) {
                  //     // Check if the future has completed with data.
                  //     if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  //       // Display the fetched data.
                  //       return Text(snapshot.data?.coursesAssigned.toString() ?? 'No data');
                  //     } else {
                  //       // Display a loading indicator or a placeholder while waiting.
                  //       return CircularProgressIndicator();
                  //     }
                  //   },
                  // ),
                  UserAssignCoursesList(
                    userSummaryData: widget.allDomainUsersSummary[index],
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
