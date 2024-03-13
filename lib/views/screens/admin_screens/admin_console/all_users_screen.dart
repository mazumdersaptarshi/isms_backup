import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/admin_management/users_analytics.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/testing/testing_admin_graphs.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_box_and_whisker_chart_data.dart';
import 'package:isms/sql/queries/query1.dart';
import 'package:isms/utilities/platform_check.dart';
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
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
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
    // Default data is set for initial display
    _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart('yu78nb');
    _usersDataBoxAndWhiskerChart = updateUsersDataOnDifferentCourseExamSelectionBoxAndWhiskerChart('yu78nb');
  }

  List<CustomBarChartData> _usersDataBarChart = [];
  List<CustomBoxAndWhiskerChartData> _usersDataBoxAndWhiskerChart = [];
  Map _allUsers = {};
  bool isHoveringOverSection = false;

  late dynamic _allUsersSummaryData;
  String url = 'http://127.0.0.1:5000/api?query=';

  /// Updates the chart data based on the selected exam.
  ///
  /// [examKey] is the key for the selected exam.
  void _updateBarDataOnExamSelection(String? examKey) {
    setState(() {
      _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart(examKey);
    });
  }

  /// Updates the chart data based on the selected metric.
  ///
  /// [metricKey] is the key for the selected metric.
  void _updateBarDataOnMetricSelection(String? metricKey) {
    setState(() {
      _usersDataBarChart = updateUsersDataOnDifferentMetricSelection(metricKey);
    });
  }

  void _updateBoxDataOnExamSelection(String? examKey) {
    setState(() {
      // _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart(examKey);
      _usersDataBoxAndWhiskerChart = updateUsersDataOnDifferentCourseExamSelectionBoxAndWhiskerChart(examKey);
    });
  }

  /// Helper function to update selected exam and reload chart data.
  ///
  /// [selectedExam] is the exam key selected from the dropdown.
  void _updateSelectedExamBarChart(String? selectedExam) {
    setState(() {
      _updateBarDataOnExamSelection(selectedExam);
    });
  }

  void _updateSelectedExamBoxAndWhiskerChart(String? selectedExam) {
    setState(() {});
  }

  /// Helper function to update selected metric and reload chart data.
  ///
  /// [selectedMetric] is the metric key selected from the dropdown.
  void _updateSelectedMetricBarChart(String? selectedMetric) {
    setState(() {
      _updateBarDataOnMetricSelection(selectedMetric);
    });
  }

  /// Retrieves all users for display in the custom data table.

  List<Color> coursesCompletedGradientColors = [
    primary!,
    Colors.deepPurpleAccent,
  ];
  List<Color> coursesEnrolledGradientColors = [
    Colors.pink!,
    Colors.orange,
  ];
  List<Color> userActivityGradientColors = [
    Colors.green,
    Colors.orangeAccent,
  ];

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    Map<String, dynamic> metricTypeDataForLineChartWidget = {
      'All': {
        // 'data': coursesCompletedOverTimeData.map((data) => FlSpot(data.x, data.y)).toList(),
        // 'colors': coursesCompletedGradientColors,
      },
      'Courses Completed over Time': {
        'data': coursesCompletedOverTimeData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': coursesCompletedGradientColors,
      },
      'Active Users': {
        'data': activeUsersData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': userActivityGradientColors,
      },
      'Courses Enrolled over Time': {
        'data': coursesEnrolledOverTimeData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': coursesEnrolledGradientColors,
      },
    };
    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionHeader(title: 'All Users'),
              FutureBuilder(
                  future: adminState.getAllUsers(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primary,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data;
                      // return CustomDataTable(usersList: snapshot.data);
                      return CustomDataTable(usersList: snapshot.data);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              // CustomDataTable(usersList: usersListData),
              buildSectionHeader(title: 'Users performance overview'),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.fromLTRB(80, 12, 80, 30),
                decoration: BoxDecoration(
                  border: Border.all(color: getTertiaryColor1()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 800),
                        child: HoverableSectionContainer(
                          onHover: (bool) {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User activity over time',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                height: 40,
                              ),
                              CustomLineChartAllUsersWidget(
                                metricAndData: metricTypeDataForLineChartWidget,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 800),
                          child: HoverableSectionContainer(
                            onHover: (bool) {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Courses status overview',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Divider(),
                                SizedBox(
                                  height: 40,
                                ),
                                CustomPieChartWidget(),
                              ],
                            ),
                          )),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 800),
                        child: HoverableSectionContainer(
                          onHover: (bool) {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Courses scores overview',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                height: 40,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CourseExamSelectWidget(
                                    onExamSelected: (selectedExam) {
                                      _updateSelectedExamBarChart(selectedExam);
                                    },
                                  ),
                                  ChartMetricSelectWidget(
                                    onMetricSelected: (selectedMetric) {
                                      _updateSelectedMetricBarChart(selectedMetric);
                                    },
                                  ),
                                  CustomBarChart(
                                    key: ValueKey(_usersDataBarChart),
                                    barChartValuesData: _usersDataBarChart,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 800),
                        child: HoverableSectionContainer(
                          onHover: (bool) {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Users score variation by attempts ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  CourseExamSelectWidget(
                                    onExamSelected: (selectedExam) {
                                      _updateBoxDataOnExamSelection(selectedExam);
                                    },
                                  ),
                                  CustomBoxAndWhiskerChartWidget(
                                    key: ValueKey(_usersDataBoxAndWhiskerChart),
                                    allData: _usersDataBoxAndWhiskerChart,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    super.color,
    super.offset,
    super.blurRadius,
    this.blurStyle = BlurStyle.normal,
  });

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) {
        result.maskFilter = null;
      }
      return true;
    }());
    return result;
  }
}
