import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_box_and_whisker_chart_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';
import 'package:isms/views/widgets/shared_widgets/selected_items_display_widget.dart';
import 'package:isms/views/widgets/shared_widgets/single_select_search_widget.dart';

import 'charts/custom_box_and_whisker_chart_widget.dart';
import 'custom_dropdown_button_widget.dart';
import 'hoverable_section_container.dart';

class UsersScoresVariationByAttempts extends StatefulWidget {
  UsersScoresVariationByAttempts({super.key, required this.courses});

  List<CourseInfo> courses = [CourseInfo(courseId: 'none')];

  @override
  State<UsersScoresVariationByAttempts> createState() => _UsersScoresVariationByAttemptsState();
}

class _UsersScoresVariationByAttemptsState extends State<UsersScoresVariationByAttempts> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();

    // Default data is set for initial display
    // _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart('py102ex');
  }

  late AdminState adminState;

  String _selectedCourseBWChart = 'none';
  String? _selectedExamBWChart = null;

  SelectableItem? _selectedCourse;
  SelectableItem? _selectedExam;
  List<SelectableItem> _examsBWChartData = [];
  List<CustomBoxAndWhiskerChartData> _bwChartData = [];

  Future<void> _fetchExamsBW(String courseId) async {
    var exams = await adminState.getExamsListForCourse(courseId: courseId);
    setState(() {
      _examsBWChartData = exams;
      // _selectedExam = exams.first;
    });
  }

  void _showCourseSingleSelectModalForBWChart(BuildContext context, {required List<SelectableItem> items}) async {
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
      _selectedCourseBWChart = selectedItem.itemId;
      _selectedExamBWChart = null;
      _examsBWChartData = [];
      _selectedCourse = selectedItem;
      _fetchExamsBW(selectedItem.itemId);
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
      _selectedExamBWChart = selectedItem.itemId;
      _selectedExam = selectedItem;
      _fetchBWChartData(selectedItem.itemId);
    }
  }

  Future<void> _fetchBWChartData(String examId) async {
    var bwChartData = await adminState.getAllUsersCoursesBW(examId: examId);
    setState(() {
      _bwChartData = bwChartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: HoverableSectionContainer(
        onHover: (bool) {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Users score variation by attempts',
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
                  onButtonPressed: () => _showCourseSingleSelectModalForBWChart(context, items: widget.courses),
                ),
                if (_examsBWChartData.isNotEmpty)
                  CustomDropdownButton(
                    // label: 'Exam',
                    buttonText: _selectedExam != null ? _selectedExam!.itemName : 'Select Exam',
                    onButtonPressed: () => _showExamSingleSelectModalForBWChart(context, items: _examsBWChartData),
                  ),
              ],
            ),
            // if (_selectedCourse != null)
            //   SelectedItemsWidget(label: 'Selected Course', selectedItemsList: [_selectedCourse!]),
            // if (_selectedExam != null) SelectedItemsWidget(label: 'Selected Exam', selectedItemsList: [_selectedExam!]),
            if (_bwChartData.isNotEmpty)
              CustomBoxAndWhiskerChartWidget(
                key: ValueKey(_bwChartData),
                allData: _bwChartData,
              ),
          ],
        ),
      ),
    );
  }
}
