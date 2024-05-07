import 'package:animated_pie_chart/animated_pie_chart.dart';
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
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'charts/custom_pie_chart_widget.dart';
import 'custom_dropdown_button_widget.dart';
import 'hoverable_section_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExamsStatusOverview extends StatefulWidget {
  ExamsStatusOverview({
    super.key,
    required this.courses,
  });

  List<CourseInfo> courses = [CourseInfo(courseId: 'none')];

  @override
  State<ExamsStatusOverview> createState() => _ExamsStatusOverviewState();
}

class _ExamsStatusOverviewState extends State<ExamsStatusOverview> {
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

  List<PieData> _piesData = [];
  final List<PieData> piesData2 = [
    PieData(value: 30, color: Colors.red),
    PieData(value: 50, color: Colors.blue),
    PieData(value: 30, color: Colors.yellow),
    PieData(value: 30, color: Colors.lightGreen),
  ];
  String tapIndex = '';

  String _passedValue = '';

  void setPieData(List<CustomPieChartData> pieChartData) {
    _piesData = [];
    pieChartData.forEach((element) {
      if (element.label == 'Passed') {
        print(element.label);

        _passedValue = element.percent.toString();
      }
      _piesData.add(PieData(value: element.percent, color: element.color!));
    });
  }

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
      setPieData(_pieChartData);
    });
  }

  Widget buildLegend(List<CustomPieChartData> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((item) {
        return Container(
          padding: EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.color, // Assuming item.color is already defined
                ),
              ),
              SizedBox(width: 8),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeConfig.primaryTextColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
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
            AppLocalizations.of(context)!.examStatusOverview,
            style: TextStyle(
              fontSize: 16,
              color: ThemeConfig.primaryTextColor!,
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
                buttonText:
                    _selectedCourse != null ? _selectedCourse!.itemName : AppLocalizations.of(context)!.selectCourse,
                onButtonPressed: () => _showCourseSingleSelectModalForPieChart(context, items: widget.courses),
              ),
              if (_examsPieChartData.isNotEmpty)
                CustomDropdownButton(
                  // label: 'Exam',
                  buttonText: _selectedExam != null ? _selectedExam!.itemName : 'Select Exam',
                  onButtonPressed: () => _showExamSingleSelectModalForPieChart(context, items: _examsPieChartData),
                ),
            ],
          ),
          // if (_selectedCourse != null)
          //   SelectedItemsWidget(label: 'Selected Course', selectedItemsList: [_selectedCourse!]),
          // if (_selectedExam != null) SelectedItemsWidget(label: 'Selected Exam', selectedItemsList: [_selectedExam!]),

          // CustomPieChartWidget(
          //   pieData: _pieChartData,
          // ),

          if (_piesData.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: EasyPieChart(
                        key: const Key('pie 2'),
                        children: _piesData,
                        borderEdge: StrokeCap.round,

                        pieType: PieType.crust,
                        showValue: false,
                        centerText: 'Passed Status',
                        onTap: (index) {
                          tapIndex = index.toString();
                          setState(() {});
                        },
                        gap: 3,
                        borderWidth: 20,
                        start: 10,
                        animateFromEnd: true,
                        size: 250,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${_passedValue.toString()}%',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeConfig.primaryTextColor,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Passed',
                              style: TextStyle(
                                fontSize: 20,
                                color: ThemeConfig.primaryTextColor,
                              ),
                            ),
                          ],
                        )),
                        // child: Center(child: Text('')),
                      ),
                    ),
                    SizedBox(width: 60),
                    buildLegend(_pieChartData),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
        ],
      ),
    ));
  }
}
