import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_scores_variation_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_scatter_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/custom_dropdown_button_widget.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';
import 'package:isms/views/widgets/shared_widgets/single_select_search_widget.dart';

class ExamAttemptsAnalysis extends StatefulWidget {
  ExamAttemptsAnalysis({
    super.key,
    required this.courses,
  });

  List<CourseInfo> courses = [CourseInfo(courseId: 'none')];

  @override
  State<ExamAttemptsAnalysis> createState() => _ExamAttemptsAnalysisState();
}

class _ExamAttemptsAnalysisState extends State<ExamAttemptsAnalysis> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();

    // Default data is set for initial display
    // _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart('py102ex');
  }

  late AdminState adminState;
  String _selectedCourseScatterChart = 'none';
  String? _selectedExamScatterChart = null;
  List<SelectableItem> _examsScatterChartData = [];
  SelectableItem? _selectedCourse;
  SelectableItem? _selectedExam;
  List<CustomScoresVariationData> _scatterChartData = [];
  int _currentPage = 0;
  final int _pageSize = 10;
  List<CustomScoresVariationData> _paginatedUsersExamScoresScatterData = [];

  Color _getColorForScore(double score) {
    if (score < 40) {
      return ThemeConfig.getPrimaryColorShade(200)!;
    } else if (score < 70) {
      return ThemeConfig.getPrimaryColorShade(400)!;
    } else {
      return ThemeConfig.primaryColor!;
    }
  }

  Future<void> _fetchExamsScatterChart(String courseId) async {
    var scatterChartData = await adminState.getExamsListForCourse(courseId: courseId);
    setState(() {
      _examsScatterChartData = scatterChartData;
    });
  }

  Future<void> _fetchScatterChartData(String examId) async {
    var scatterChartData = await adminState.getAllUsersExamScores(examId: examId);
    setState(() {
      _scatterChartData = scatterChartData;
    });
  }

  void _showCourseSingleSelectModalForScatterChart(BuildContext context, {required List<SelectableItem> items}) async {
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
      _selectedCourseScatterChart = selectedItem.itemId;
      _selectedExamScatterChart = null;
      _examsScatterChartData = [];
      _selectedCourse = selectedItem;
      _fetchExamsScatterChart(selectedItem.itemId);
    }
  }

  void _showExamSingleSelectModalForBWChart(BuildContext context, {required List<SelectableItem> items}) async {
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
      _selectedCourseScatterChart = selectedItem.itemId;
      _selectedExam = selectedItem;
      _fetchScatterChartData(selectedItem.itemId);
    }
  }

  void _getPaginatedData(int currentPage) {
    int startIndex = currentPage * _pageSize;
    int endIndex = min(startIndex + _pageSize, _scatterChartData.length);

    for (int i = startIndex; i < endIndex; i++) {
      _paginatedUsersExamScoresScatterData.add(_scatterChartData[i]);
    }
    print(_paginatedUsersExamScoresScatterData);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: HoverableSectionContainer(
          onHover: (bool) {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exam Attempts Analysis',
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeConfig.primaryTextColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                spacing: 20, // Horizontal space between children
                runSpacing: 20, // Vertical space between runs
                alignment: WrapAlignment.start,
                children: [
                  CustomDropdownButton(
                    // label: 'Course',
                    buttonText: _selectedCourse != null ? _selectedCourse!.itemName : 'Select Course',
                    onButtonPressed: () => _showCourseSingleSelectModalForScatterChart(context, items: widget.courses),
                  ),
                  if (_examsScatterChartData.isNotEmpty)
                    CustomDropdownButton(
                      // label: 'Exam',
                      buttonText: _selectedExam != null ? _selectedExam!.itemName : 'Select Exam',
                      onButtonPressed: () =>
                          _showExamSingleSelectModalForBWChart(context, items: _examsScatterChartData),
                    ),
                ],
              ),
              if (_scatterChartData.isNotEmpty)
                Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                    height: 700,
                    child: CustomScatterChartWidget(
                      key: ValueKey(_scatterChartData),
                      usersExamScoresScatterData: _scatterChartData,
                      getColorForScore: _getColorForScore,
                      dottedLineIndicatorValue: 70,
                    )),
            ],
          )),
    );
  }
}
