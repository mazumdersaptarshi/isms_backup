import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/charts/pie_charts/custom_pie_chart_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';
import 'package:isms/views/widgets/shared_widgets/selected_items_display_widget.dart';
import 'package:isms/views/widgets/shared_widgets/single_select_search_widget.dart';

import 'charts/custom_pie_chart_widget.dart';
import 'custom_dropdown_button_widget.dart';
import 'hoverable_section_container.dart';

class CoursesStatusOverview extends StatefulWidget {
  CoursesStatusOverview({
    super.key,
    required this.courses,
  });

  List<CourseInfo> courses = [CourseInfo(courseId: 'none')];

  @override
  State<CoursesStatusOverview> createState() => _CoursesStatusOverviewState();
}

class _CoursesStatusOverviewState extends State<CoursesStatusOverview> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  late AdminState adminState;
  List<CustomPieChartData> _pieChartData = [];
  SelectableItem? _selectedCourse;
  SelectableItem? _selectedExam;
  List<SelectableItem> _examsPieChartData = [];

  Future<void> _fetchExamsPie(String courseId) async {
    var exams = await adminState.getExamsListForCourse(courseId: courseId);
    setState(() {
      _examsPieChartData = exams;
    });
  }

  void _showCourseSingleSelectModalForPieChart(BuildContext context, {required List<SelectableItem> items}) async {
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
      print('Selected item: ${selectedItem.itemName}');
      _examsPieChartData = [];
      _selectedCourse = selectedItem;
      _fetchExamsPie(selectedItem.itemId!);
    }
  }

  void _showExamSingleSelectModalForPieChart(BuildContext context, {required List<SelectableItem> items}) async {
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
      _selectedExam = selectedItem;
      _fetchPieChartData(selectedItem.itemId);
    }
  }

  Future<void> _fetchPieChartData(String examId) async {
    var pieChartData = await adminState.getExamOverallResults(examId: examId);
    setState(() {
      _pieChartData = pieChartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
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
                  color: ThemeConfig.primaryTextColor!,
                ),
              ),
              Divider(),
              SizedBox(
                height: 40,
              ),
              Wrap(
                spacing: 20, // Horizontal space between children
                runSpacing: 20, // Vertical space between runs
                alignment: WrapAlignment.start,
                children: [
                  CustomDropdownButton(
                    label: 'Course',
                    buttonText: 'Select Course',
                    onButtonPressed: () => _showCourseSingleSelectModalForPieChart(context, items: widget.courses),
                  ),
                  if (_examsPieChartData.isNotEmpty)
                    CustomDropdownButton(
                      label: 'Exam',
                      buttonText: 'Select Exam',
                      onButtonPressed: () => _showExamSingleSelectModalForPieChart(context, items: _examsPieChartData),
                    ),
                ],
              ),
              if (_selectedCourse != null)
                SelectedItemsWidget(label: 'Selected Course', selectedItemsList: [_selectedCourse!]),
              if (_selectedExam != null)
                SelectedItemsWidget(label: 'Selected Exam', selectedItemsList: [_selectedExam!]),
              CustomPieChartWidget(
                pieData: _pieChartData,
              ),
            ],
          ),
        ));
  }
}
