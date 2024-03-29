import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/models/shared_widgets/custom_dropdown_item.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';
import 'package:isms/views/widgets/shared_widgets/single_select_search_widget.dart';

import 'charts/custom_bar_chart_widget.dart';
import 'custom_dropdown_button_widget.dart';
import 'custom_dropdown_widget.dart';
import 'hoverable_section_container.dart';
import 'multi_select_search_widget.dart';
import 'selected_items_display_widget.dart';

class CoursesScoresOverview extends StatefulWidget {
  CoursesScoresOverview({
    super.key,
    required this.courses,
    required this.domainUsers,
  });

  List<CourseInfo> courses = [CourseInfo(courseId: 'none')];
  List<UsersSummaryData> domainUsers = [];

  @override
  State<CoursesScoresOverview> createState() => _CoursesScoresOverviewState();
}

class _CoursesScoresOverviewState extends State<CoursesScoresOverview> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  late AdminState adminState;

  SelectableItem? _selectedCourse;
  SelectableItem? _selectedExam;
  String? _selectedExamBarChart = null;

  List<SelectableItem> _examsBarChartData = [];
  List<CustomBarChartData> _barChartData = [];
  CustomDropdownItem<String>? _selectedMetricForBarChart;
  List<CustomDropdownItem<String>> barChartMetrics = [
    CustomDropdownItem(key: 'avgScore', value: 'Average Score'),
    CustomDropdownItem(key: 'maxScore', value: 'Max Score'),
    CustomDropdownItem(key: 'minScore', value: 'Min Score'),
    CustomDropdownItem(key: 'numberOfAttempts', value: 'Number of Attempts'),
  ];
  List<SelectableItem> _selectedUsersList = [];
  List<String> _userIdsForFilter = [];

  Future<void> _fetchExams(String courseId) async {
    var exams = await adminState.getExamsListForCourse(courseId: courseId);

    setState(() {
      _examsBarChartData = exams;
    });
  }

  Future<void> _fetchBarChartData(String examId, String metric) async {
    // Replace with the actual endpoint that returns bar chart data for the selected exam
    var barChartData = await adminState.getAllUsersCoursesStatusOverview(examId: examId, metric: metric);
    setState(() {
      _barChartData = barChartData;
    });
  }

  void _applyUserFiltersBarChartData({required String examId, required String metric, required List<String> userIds}) {
    setState(() {
      _barChartData =
          adminState.getFilteredUsersCoursesStatusOverview(examId: examId, metric: metric, userIds: userIds);
    });
  }

  void _showCourseSingleSelectModalForBarChart(BuildContext context, {required List<SelectableItem> items}) async {
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
      _selectedCourse = selectedItem;
      _selectedExamBarChart = null;
      _examsBarChartData = [];
      _fetchExams(selectedItem.itemId!);
    }
  }

  void _showExamSingleSelectModalForBarChart(BuildContext context, {required List<SelectableItem> items}) async {
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
      _selectedExamBarChart = selectedItem.itemId;

      _selectedExam = selectedItem;
      _fetchBarChartData(selectedItem.itemId, 'avgScore');
    }
  }

  void _showMultiSelectUsersModal(List<UsersSummaryData> users) async {
    final List<SelectableItem> selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: MultiSelectSearch(
            items: users,
          ),
        );
      },
    );

    if (selected != null) {
      // Dialog was closed with selected items
      setState(() {
        _selectedUsersList = selected;
      });
      print(_selectedUsersList);
      _selectedUsersList.forEach((element) {
        if (!_userIdsForFilter.contains(element.itemId)) {
          _userIdsForFilter.add(element.itemId);
        }
      });
      if (_selectedMetricForBarChart == null) {
        _applyUserFiltersBarChartData(
          examId: _selectedExamBarChart!,
          metric: 'avgScore',
          userIds: _userIdsForFilter,
        );
      } else {
        _applyUserFiltersBarChartData(
          examId: _selectedExamBarChart!,
          metric: _selectedMetricForBarChart!.key,
          userIds: _userIdsForFilter,
        );
      }
    }
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
              'Courses scores overview',
              style: TextStyle(
                fontSize: 14,
                color: ThemeConfig.primaryTextColor,
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
                  onButtonPressed: () => _showCourseSingleSelectModalForBarChart(context, items: widget.courses),
                ),
                if (_examsBarChartData.isNotEmpty)
                  CustomDropdownButton(
                    label: 'Exam',
                    buttonText: 'Select Exam',
                    onButtonPressed: () => _showExamSingleSelectModalForBarChart(context, items: _examsBarChartData),
                  ),
                if (_selectedExamBarChart != null)
                  CustomDropdownWidget(
                    label: 'Metrics',
                    hintText: 'Select Metrics',
                    value: _selectedMetricForBarChart,
                    items: barChartMetrics,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMetricForBarChart = newValue;
                      });
                      _fetchBarChartData(_selectedExamBarChart!, newValue!.key);
                    },
                  ),
                Row(
                  children: [
                    CustomDropdownButton(
                      label: 'Filter By Users',
                      buttonText: 'Select Users',
                      onButtonPressed: () => _showMultiSelectUsersModal(widget.domainUsers),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 8),
                          child: Text(
                            '',
                          ),
                        ),
                        if (_selectedUsersList.length > 0)
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  setState(() {
                                    _selectedUsersList = [];
                                    _userIdsForFilter = [];
                                  });
                                });
                                if (_selectedMetricForBarChart == null) {
                                  _applyUserFiltersBarChartData(
                                    examId: _selectedExamBarChart!,
                                    metric: 'avgScore',
                                    userIds: _userIdsForFilter,
                                  );
                                } else {
                                  _applyUserFiltersBarChartData(
                                    examId: _selectedExamBarChart!,
                                    metric: _selectedMetricForBarChart!.key,
                                    userIds: _userIdsForFilter,
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.close_rounded),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text('Clear Selection'),
                                ],
                              )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (_selectedCourse != null)
              SelectedItemsWidget(label: 'Selected Course', selectedItemsList: [_selectedCourse!]),
            if (_selectedExam != null) SelectedItemsWidget(label: 'Selected Exam', selectedItemsList: [_selectedExam!]),
            if (_selectedUsersList.isNotEmpty)
              SelectedItemsWidget(
                  key: ValueKey(_selectedUsersList), label: 'Selected Users', selectedItemsList: _selectedUsersList),
            SizedBox(
              height: 20,
            ),
            CustomBarChart(key: ValueKey(_barChartData), barChartValuesData: _barChartData),
          ],
        ),
      ),
    );
  }
}
