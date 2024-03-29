import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/testing/testing_admin_graphs.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_box_and_whisker_chart_data.dart';
import 'package:isms/models/charts/pie_charts/custom_pie_chart_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/sql/queries/query1.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/admin_console/admin_actions.dart';
import 'package:isms/views/widgets/admin_console/users_performance_overview_section.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_box_and_whisker_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_pie_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_line_chart_all_users_widget.dart';
import 'package:isms/views/widgets/shared_widgets/course_exam_select_widget_dropdown.dart';
import 'package:isms/views/widgets/custom_data_table.dart';
import 'package:isms/views/widgets/shared_widgets/chart_metric_select_widget_dropdown.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_bar_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/charts/horizontal_bar_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';
import 'package:isms/views/widgets/shared_widgets/custom_expansion_tile.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late AdminState adminState;

  /// Initializes state with default data and sets up admin state.
  @override
  void initState() {
    super.initState();
    adminState = AdminState();
    _fetchAllDomainCourses();
    _fetchAllDomainUsers();
    // Default data is set for initial display
    // _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart('py102ex');
  }

  // Map _allUsers = {};
  bool isHoveringOverSection = false;

  String url = 'http://127.0.0.1:5000/api?query=';

  void _updateBarDataOnExamSelection(String? examKey) {
    setState(() {
      selectedExam = examKey!;
    });
  }

  List<Color> coursesCompletedGradientColors = [
    ThemeConfig.primaryColor!,
    Colors.redAccent,
  ];
  List<Color> coursesEnrolledGradientColors = [
    Colors.pink!,
    Colors.orange,
  ];
  List<Color> userActivityGradientColors = [
    Colors.green,
    Colors.orangeAccent,
  ];

  var selectedExam = '';

  List<CourseInfo> _courses = [CourseInfo(courseId: 'none', courseTitle: 'none')];

  List<UsersSummaryData> _allDomainUsersSummary = [];

  bool _coursesLoaded = false;

  Future<dynamic> _fetchAllDomainCourses() async {
    var courses = await adminState.getCoursesList();
    setState(() {
      _courses = [..._courses, ...courses];
      _coursesLoaded = true;
    });
  }

  Future<void> _fetchAllDomainUsers() async {
    var allUsers = await adminState.getAllUsers();
    setState(() {
      _allDomainUsersSummary = allUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UsersSummaryTable(key: ValueKey(_allDomainUsersSummary), usersList: _allDomainUsersSummary),
              buildSectionHeader(title: 'Admin Actions'),
              _coursesLoaded
                  ? AdminActions(
                      courses: _courses,
                      allDomainUsersSummary: _allDomainUsersSummary,
                    )
                  : CircularProgressIndicator(),
              buildSectionHeader(title: 'Users performance overview'),
              _coursesLoaded
                  ? UsersPerformanceOverviewSection(
                      courses: _courses,
                      domainUsers: _allDomainUsersSummary,
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
