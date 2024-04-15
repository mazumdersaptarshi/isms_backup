// import 'dart:convert';
// import 'dart:math';
//
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:isms/controllers/admin_management/admin_state.dart';
// import 'package:isms/controllers/testing/test_data.dart';
// import 'package:isms/controllers/testing/testing_admin_graphs.dart';
// import 'package:isms/controllers/theme_management/app_theme.dart';
// import 'package:isms/controllers/user_management/logged_in_state.dart';
// import 'package:isms/models/admin_models/users_summary_data.dart';
// import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
// import 'package:isms/models/charts/box_and_whisker_charts/custom_box_and_whisker_chart_data.dart';
// import 'package:isms/models/charts/pie_charts/custom_pie_chart_data.dart';
// import 'package:isms/models/course/course_exam_relationship.dart';
// import 'package:isms/sql/queries/query1.dart';
// import 'package:isms/utilities/platform_check.dart';
// import 'package:isms/views/widgets/admin_console/admin_actions.dart';
// import 'package:isms/views/widgets/admin_console/users_performance_overview_section.dart';
// import 'package:isms/views/widgets/shared_widgets/charts/custom_box_and_whisker_chart_widget.dart';
// import 'package:isms/views/widgets/shared_widgets/charts/custom_pie_chart_widget.dart';
// import 'package:isms/views/widgets/shared_widgets/charts/custom_line_chart_all_users_widget.dart';
// import 'package:isms/views/widgets/shared_widgets/course_exam_select_widget_dropdown.dart';
// import 'package:isms/views/widgets/custom_data_table.dart';
// import 'package:isms/views/widgets/shared_widgets/chart_metric_select_widget_dropdown.dart';
// import 'package:isms/views/widgets/shared_widgets/charts/custom_bar_chart_widget.dart';
// import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
// import 'package:isms/views/widgets/shared_widgets/charts/horizontal_bar_chart_widget.dart';
// import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';
// import 'package:isms/views/widgets/shared_widgets/custom_expansion_tile.dart';
// import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
//
// class AllUsers extends StatefulWidget {
//   const AllUsers({super.key});
//
//   @override
//   State<AllUsers> createState() => _AllUsersState();
// }
//
// class _AllUsersState extends State<AllUsers> {
//   late AdminState adminState;
//
//   /// Initializes state with default data and sets up admin state.
//   @override
//   void initState() {
//     super.initState();
//     adminState = AdminState();
//     _fetchAllDomainCourses();
//     _fetchAllDomainUsers();
//     // Default data is set for initial display
//     // _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart('py102ex');
//     _usersDataBoxAndWhiskerChart = updateUsersDataOnDifferentCourseExamSelectionBoxAndWhiskerChart('py102ex');
//   }
//
//   List<CustomBarChartData> _usersDataBarChart = [];
//   List<CustomBoxAndWhiskerChartData> _usersDataBoxAndWhiskerChart = [];
//
//   // Map _allUsers = {};
//   bool isHoveringOverSection = false;
//
//   late dynamic _allUsersSummaryData;
//   String url = 'http://127.0.0.1:5000/api?query=';
//
//   /// Updates the chart data based on the selected exam.
//   ///
//   /// [examKey] is the key for the selected exam.
//   void _updateBarDataOnExamSelection(String? examKey) {
//     setState(() {
//       selectedExam = examKey!;
//       _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart(examKey);
//     });
//   }
//
//   /// Updates the chart data based on the selected metric.
//   ///
//   /// [metricKey] is the key for the selected metric.
//   void _updateBarDataOnMetricSelection(String? metricKey) {
//     setState(() {
//       _usersDataBarChart = updateUsersDataOnDifferentMetricSelection(metricKey);
//     });
//   }
//
//   void _updateBoxDataOnExamSelection(String? examKey) {
//     setState(() {
//       // _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart(examKey);
//       _usersDataBoxAndWhiskerChart = updateUsersDataOnDifferentCourseExamSelectionBoxAndWhiskerChart(examKey);
//     });
//   }
//
//   /// Helper function to update selected exam and reload chart data.
//   ///
//   /// [selectedExam] is the exam key selected from the dropdown.
//   void _updateSelectedExamBarChart(String? selectedExam) {
//     setState(() {
//       _updateBarDataOnExamSelection(selectedExam);
//     });
//   }
//
//   /// Helper function to update selected metric and reload chart data.
//   ///
//   /// [selectedMetric] is the metric key selected from the dropdown.
//   void _updateSelectedMetricBarChart(String? selectedMetric) {
//     setState(() {
//       _updateBarDataOnMetricSelection(selectedMetric);
//     });
//   }
//
//   /// Retrieves all users for display in the custom data table.
//
//   List<Color> coursesCompletedGradientColors = [
//     primary!,
//     Colors.deepPurpleAccent,
//   ];
//   List<Color> coursesEnrolledGradientColors = [
//     Colors.pink!,
//     Colors.orange,
//   ];
//   List<Color> userActivityGradientColors = [
//     Colors.green,
//     Colors.orangeAccent,
//   ];
//
//   var selectedExam = '';
//
//   List<Map<String, dynamic>> _allDomainUsersDropdown = [
//     {'userId': 'none', 'name': 'none'}
//   ];
//   List<CourseExamRelationship> _courses = [CourseExamRelationship(courseId: 'none', courseTitle: 'none')];
//
//   List<UsersSummaryData> _allDomainUsersSummary = [];
//
//   bool _coursesLoaded = false;
//
//   Future<dynamic> _fetchAllDomainCourses() async {
//     var courses = await adminState.getCoursesList();
//     setState(() {
//       _courses = [..._courses, ...courses];
//       _coursesLoaded = true;
//     });
//   }
//
//   Future<void> _fetchAllDomainUsers() async {
//     var allUsers = await adminState.getAllUsers();
//     setState(() {
//       _allDomainUsersSummary = allUsers;
//       allUsers.forEach((element) {
//         _allDomainUsersDropdown.add({'userId': element.uid, 'name': element.name});
//       });
//     });
//     print(_allDomainUsersDropdown);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final loggedInState = context.watch<LoggedInState>();
//
//     return Scaffold(
//       bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
//       appBar: IsmsAppBar(context: context),
//       drawer: IsmsDrawer(context: context),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               buildSectionHeader(title: 'All Users'),
//               UsersSummaryTable(key: ValueKey(_allDomainUsersSummary), usersList: _allDomainUsersSummary),
//               buildSectionHeader(title: 'Admin Actions'),
//               _coursesLoaded
//                   ? AdminActions(
//                       courses: _courses,
//                       allDomainUsersSummary: _allDomainUsersSummary,
//                     )
//                   : CircularProgressIndicator(),
//               buildSectionHeader(title: 'Users performance overview'),
//               _coursesLoaded
//                   ? UsersPerformanceOverviewSection(
//                       courses: _courses,
//                     )
//                   : CircularProgressIndicator(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
