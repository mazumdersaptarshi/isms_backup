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
  List<CustomBarChartData> _filteredBarChartData = [];

  CustomDropdownItem<String>? _selectedMetricForBarChart;
  int _scoreLimit = 100;
  int _currentPage = 0;
  final int _pageSize = 15;
  int _totalPages = 0;

  List<CustomDropdownItem<String>> barChartMetrics = [
    CustomDropdownItem(key: 'Average Score', value: 'avgScore'),
    CustomDropdownItem(key: 'Max Score', value: 'maxScore'),
    CustomDropdownItem(key: 'Min Score', value: 'minScore'),
    CustomDropdownItem(key: 'Number of Attempts', value: 'numberOfAttempts'),
  ];
  List<SelectableItem> _selectedUsersList = [];
  List<String> _userIdsForFilter = [];
  CustomDropdownItem<int>? scoreLimit;

  List<CustomDropdownItem<int>> scoreFilterList = [
    CustomDropdownItem(key: '<= 30', value: 30),
    CustomDropdownItem(key: '<= 50', value: 50),
    CustomDropdownItem(key: '<= 70', value: 70),
    CustomDropdownItem(key: '<= 100', value: 100),
  ];

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
      _filteredBarChartData = _barChartData;
    });
  }

  void _applyUserFiltersBarChartData({required String examId, required String metric, required List<String> userIds}) {
    setState(() {
      _barChartData =
          adminState.getFilteredUsersCoursesStatusOverview(examId: examId, metric: metric, userIds: userIds);
    });
  }

  void _applyScoreFilter({required int scoreLimit}) {
    setState(() {
      print(scoreLimit);
      _filteredBarChartData = _barChartData;
      List<CustomBarChartData> filteredScoresExamData = [];

      _barChartData.forEach((element) {
        if (element.y <= scoreLimit) filteredScoresExamData.add(element);
      });
      _filteredBarChartData = filteredScoresExamData;
    });
    print(_barChartData);
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
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: HoverableSectionContainer(
            onHover: (bool) {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scores Drilldown',
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeConfig.primaryTextColor,
                  ),
                ),
                // Divider(),
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
                      onButtonPressed: () => _showCourseSingleSelectModalForBarChart(context, items: widget.courses),
                    ),
                    if (_examsBarChartData.isNotEmpty)
                      CustomDropdownButton(
                        // label: 'Exam',
                        buttonText: _selectedExam != null ? _selectedExam!.itemName : 'Select Exam',
                        onButtonPressed: () =>
                            _showExamSingleSelectModalForBarChart(context, items: _examsBarChartData),
                      ),
                    // if (_selectedExamBarChart != null)
                    //   CustomDropdownWidget(
                    //     label: 'Metrics',
                    //     hintText: 'Select Metrics',
                    //     value: _selectedMetricForBarChart,
                    //     items: barChartMetrics,
                    //     onChanged: (newValue) {
                    //       setState(() {
                    //         _selectedMetricForBarChart = newValue;
                    //       });
                    //       _fetchBarChartData(_selectedExamBarChart!, newValue!.key);
                    //     },
                    //   ),
                  ],
                ),
                // if (_selectedCourse != null)
                //   SelectedItemsWidget(label: 'Selected Course', selectedItemsList: [_selectedCourse!]),
                // if (_selectedExam != null)
                //   SelectedItemsWidget(label: 'Selected Exam', selectedItemsList: [_selectedExam!]),
                if (_selectedUsersList.isNotEmpty)
                  SelectedItemsWidget(
                      key: ValueKey(_selectedUsersList),
                      label: 'Selected Users',
                      selectedItemsList: _selectedUsersList),
                // SizedBox(
                //   height: 20,
                // ),
                if (_selectedExamBarChart != null)
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomBarChart(
                            key: ValueKey([_filteredBarChartData, _scoreLimit, _currentPage]),
                            barChartValuesData: _filteredBarChartData,
                            scoreLimit: _scoreLimit,
                            totalPages: _totalPages,
                            dottedLineIndicatorValue: 70,
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Refine Data'),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownWidget<int>(
                                // label: 'Filter',
                                hintText: 'Filter Score Range',
                                value: scoreLimit,
                                items: scoreFilterList,
                                onChanged: (value) {
                                  setState(() {
                                    scoreLimit = value;
                                    _scoreLimit = scoreLimit!.value;
                                    _applyScoreFilter(scoreLimit: _scoreLimit);
                                    // calculateTotalPagesBasedOnFilter(_scoreLimit);
                                    _currentPage = 0;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownWidget(
                                // label: 'Metrics',
                                hintText: 'Select Metrics',
                                value: _selectedMetricForBarChart,
                                items: barChartMetrics,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedMetricForBarChart = newValue;
                                  });
                                  _fetchBarChartData(_selectedExamBarChart!, newValue!.value);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButton(
                                // label: 'View and Select Users',
                                buttonText: 'View and Select Users',
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
                    ],
                  ),
                // CustomBarChart(key: ValueKey(_barChartData), barChartValuesData: _barChartData),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
