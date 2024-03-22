import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_box_and_whisker_chart_data.dart';
import 'package:isms/models/charts/pie_charts/custom_pie_chart_data.dart';
import 'package:isms/models/course/course_exam_relationship.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_bar_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_box_and_whisker_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_line_chart_all_users_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_pie_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/course_exam_select_widget_dropdown.dart';
import 'package:isms/views/widgets/shared_widgets/custom_dropdown_widget.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';
import 'package:isms/views/widgets/shared_widgets/single_select_search_widget.dart';

class UsersPerformanceOverviewSection extends StatefulWidget {
  UsersPerformanceOverviewSection({
    super.key,
    required this.courses,
  });

  List<CourseExamRelationship> courses = [CourseExamRelationship(courseId: 'none')];

  @override
  State<UsersPerformanceOverviewSection> createState() => _UsersPerformanceOverviewSectionState();
}

class _UsersPerformanceOverviewSectionState extends State<UsersPerformanceOverviewSection> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();

    // Default data is set for initial display
    // _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart('py102ex');
  }

  String _selectedCourseBarChart = 'none';
  String? _selectedExamBarChart = null;
  String? _selectedMetricBarChart;
  List<dynamic> _examsBarChartData = [];
  List<CustomBarChartData> _barChartData = [];
  String? _selectedCoursePieChart = 'none';
  String? _selectedExamPieChart = null;
  List<dynamic> _examsPieChartData = [];
  List<CustomPieChartData> _pieChartData = [];
  String _selectedCourseBWChart = 'none';
  String? _selectedExamBWChart = null;
  List<dynamic> _examsBWChartData = [];
  List<CustomBoxAndWhiskerChartData> _bwChartData = [];

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

  Map<String, String> _metrics = {
    'avgScore': 'Average Score',
    'maxScore': 'Max Score',
    'minScore': 'Min Score',
    'numberOfAttempts': 'Number of Attempts',
  };

  Future<void> _fetchExams(String courseId) async {
    var exams = await adminState.getExamsListForCourse(courseId: courseId);
    setState(() {
      _examsBarChartData = exams;
      // _selectedExam = exams.first;
    });
  }

  late AdminState adminState;

  Future<void> _fetchBarChartData(String examId, String metric) async {
    // Replace with the actual endpoint that returns bar chart data for the selected exam
    var barChartData = await adminState.getAllUsersCoursesStatusOverview(examId: examId, metric: metric);
    setState(() {
      _barChartData = barChartData;
    });
  }

  Future<void> _fetchExamsPie(String courseId) async {
    var exams = await adminState.getExamsListForCourse(courseId: courseId);
    setState(() {
      _examsPieChartData = exams;
    });
  }

  Future<void> _fetchPieChartData(String examId) async {
    var pieChartData = await adminState.getExamOverallResults(examId: examId);
    setState(() {
      _pieChartData = pieChartData;
    });
  }

  Future<void> _fetchExamsBW(String courseId) async {
    var exams = await adminState.getExamsListForCourse(courseId: courseId);
    setState(() {
      _examsBWChartData = exams;
      // _selectedExam = exams.first;
    });
  }

  Future<void> _fetchBWChartData(String examId) async {
    var bwChartData = await adminState.getAllUsersCoursesBW(examId: examId);
    setState(() {
      _bwChartData = bwChartData;
    });
  }

  void _showSingleSelectModal(BuildContext context, {required List<SelectableItem> items}) async {
    final SelectableItem? selectedItem = await showDialog<SelectableItem>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleSelectSearch(
            items: items,
          ),
        );
      },
    );

    if (selectedItem != null) {
      // Use the selected item here
      print('Selected item: ${selectedItem.itemName}');
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Container(
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
            //Bar Graph
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
                    ElevatedButton(
                      onPressed: () => _showSingleSelectModal(context, items: widget.courses),
                      child: Text('Select Item'),
                    ),
                    DropdownButton<String>(
                      hint: Text('Select Course'),
                      value: _selectedCourseBarChart,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCourseBarChart = newValue!;
                          _selectedExamBarChart = null;
                          _selectedMetricBarChart = null;
                          _examsBarChartData = []; // Clear exams when changing course
                        });
                        _fetchExams(newValue!);
                      },
                      items: widget.courses.map<DropdownMenuItem<String>>((course) {
                        return DropdownMenuItem<String>(
                          value: course.courseId.toString(),
                          child: Text(course.courseTitle ?? 'none'),
                        );
                      }).toList(),
                    ),
                    if (_examsBarChartData.isNotEmpty)
                      DropdownButton<String>(
                        hint: Text('Select Exam'),
                        value: _selectedExamBarChart,
                        onChanged: (newValue) {
                          // Add your logic to update the chart based on the selected exam
                          setState(() {
                            _selectedExamBarChart = newValue!;
                            _selectedMetricBarChart = null;
                          });
                          _fetchBarChartData(newValue!, 'avgScore');
                        },
                        items: _examsBarChartData.map<DropdownMenuItem<String>>((exam) {
                          return DropdownMenuItem<String>(
                            value: exam['examId'].toString(),
                            child: Text(exam['examTitle']),
                          );
                        }).toList(),
                      ),
                    if (_selectedExamBarChart != null) // Ensure this only shows if an exam has been selected
                      DropdownButton<String>(
                        hint: Text('Select Metric'),
                        value: _selectedMetricBarChart,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedMetricBarChart = newValue!;
                            // Optionally update chart or other widgets based on the new metric
                          });
                          _fetchBarChartData(_selectedExamBarChart!,
                              newValue!); // Pass the metric as a new parameter if your fetching function supports it
                        },
                        items: _metrics.entries.map<DropdownMenuItem<String>>((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                      ),
                    CustomBarChart(key: ValueKey(_barChartData), barChartValuesData: _barChartData),
                  ],
                ),
              ),
            ),
            // User Activity Over Time
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
            //Courses Status Pie Chart
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
                      DropdownButton<String>(
                        hint: Text('Select Course'),
                        value: _selectedCoursePieChart,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCoursePieChart = newValue!;
                            _selectedExamPieChart = null;

                            _examsPieChartData = []; // Clear exams when changing course
                          });
                          _fetchExamsPie(newValue!);
                        },
                        items: widget.courses.map<DropdownMenuItem<String>>((course) {
                          return DropdownMenuItem<String>(
                            value: course.courseId.toString(),
                            child: Text(course.courseTitle ?? 'none'),
                          );
                        }).toList(),
                      ),
                      if (_examsPieChartData.isNotEmpty)
                        DropdownButton<String>(
                          hint: Text('Select Exam'),
                          value: _selectedExamPieChart,
                          onChanged: (newValue) {
                            // Add your logic to update the chart based on the selected exam
                            setState(() {
                              _selectedExamPieChart = newValue!;
                            });
                            _fetchPieChartData(newValue!);
                          },
                          items: _examsPieChartData.map<DropdownMenuItem<String>>((exam) {
                            return DropdownMenuItem<String>(
                              value: exam['examId'].toString(),
                              child: Text(exam['examTitle']),
                            );
                          }).toList(),
                        ),
                      CustomPieChartWidget(
                        pieData: _pieChartData,
                      ),
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
                      'Users score variation by attempts',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 40,
                    ),
                    DropdownButton<String>(
                      hint: Text('Select Course'),
                      value: _selectedCourseBWChart,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCourseBWChart = newValue!;
                          _selectedExamBWChart = null;
                          _selectedMetricBarChart = null;

                          _examsBWChartData = []; // Clear exams when changing course
                        });
                        _fetchExamsBW(newValue!);
                      },
                      items: widget.courses.map<DropdownMenuItem<String>>((course) {
                        return DropdownMenuItem<String>(
                          value: course.courseId.toString(),
                          child: Text(course.courseTitle ?? 'none'),
                        );
                      }).toList(),
                    ),
                    if (_examsBWChartData.isNotEmpty)
                      DropdownButton<String>(
                        hint: Text('Select Exam'),
                        value: _selectedExamBWChart,
                        onChanged: (newValue) {
                          // Add your logic to update the chart based on the selected exam
                          setState(() {
                            _selectedExamBWChart = newValue!;
                          });
                          _fetchBWChartData(newValue!);
                        },
                        items: _examsBWChartData.map<DropdownMenuItem<String>>((exam) {
                          return DropdownMenuItem<String>(
                            value: exam['examId'].toString(),
                            child: Text(exam['examTitle']),
                          );
                        }).toList(),
                      ),
                    CustomBoxAndWhiskerChartWidget(
                      key: ValueKey(_bwChartData),
                      allData: _bwChartData,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
