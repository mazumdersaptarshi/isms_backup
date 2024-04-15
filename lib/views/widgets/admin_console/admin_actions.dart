import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/models/shared_widgets/custom_dropdown_item.dart';
import 'package:isms/views/widgets/admin_console/assign_courses_to_users.dart';
import 'package:isms/views/widgets/admin_console/build_users_course_assignments_list.dart';
import 'package:isms/views/widgets/admin_console/view_users_courses_assignments.dart';
import 'package:isms/views/widgets/shared_widgets/build_secondary_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_dropdown_button_widget.dart';
import 'package:isms/views/widgets/shared_widgets/custom_dropdown_widget.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:isms/views/widgets/shared_widgets/multi_select_search_widget.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';
import 'package:isms/views/widgets/shared_widgets/selected_items_display_widget.dart';

class AdminActions extends StatefulWidget {
  AdminActions({
    super.key,
    required this.courses,
    required this.allDomainUsersSummary,
    required this.CSRFToken,
    required this.JWT,
  });

  List<CourseInfo> courses = [CourseInfo(courseId: 'ip78hd', courseTitle: 'oplkj')];
  List<UsersSummaryData> allDomainUsersSummary = [];
  final String CSRFToken;
  final String JWT;

  @override
  State<AdminActions> createState() => _AdminActionsState();
}

class _AdminActionsState extends State<AdminActions> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  late AdminState adminState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.fromLTRB(80, 12, 80, 30),
      // margin: EdgeInsets.all(20),
      child: AssignCoursesToUserSection(
        courses: widget.courses,
        allDomainUsersSummary: widget.allDomainUsersSummary,
        CSRFToken: widget.CSRFToken,
        JWT: widget.JWT,
      ),
    );
  }
}
