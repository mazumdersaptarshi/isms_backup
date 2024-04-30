import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/charts/bar_charts/individual_bar.dart';
import 'package:isms/models/shared_widgets/custom_dropdown_item.dart';
import 'package:isms/views/widgets/shared_widgets/custom_dropdown_widget.dart';

class CustomBarChart extends StatefulWidget {
  CustomBarChart({
    super.key,
    required this.barChartValuesData,
    required this.scoreLimit,
    required this.totalPages,
    this.dottedLineIndicatorValue,
  });

  final List<dynamic> barChartValuesData;
  int scoreLimit;
  int totalPages;
  int? dottedLineIndicatorValue = 0;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  int _scoreLimit = 100;
  CustomDropdownItem<int>? scoreLimit;

  List<CustomDropdownItem<int>> scoreFilterList = [
    CustomDropdownItem(key: '30', value: 30),
    CustomDropdownItem(key: '50', value: 50),
    CustomDropdownItem(key: '70', value: 70),
    CustomDropdownItem(key: '100', value: 100),
  ];
  int _touchedIndex = -1;

  int _currentPage = 0;
  final int _pageSize = 15;
  int _totalPages = 0;
  List<IndividualBar> barData = [];

  //Test Data

  @override
  void initState() {
    super.initState();

    _buildBarData();
    _calculateTotalPages();
  }

  void _buildBarData() {
    _scoreLimit = widget.scoreLimit;
    _totalPages = widget.totalPages;
    if (widget.barChartValuesData.isEmpty) _scoreLimit = 0;
    int maxValue = 0;
    for (int index = 0; index < widget.barChartValuesData.length; index++) {
      barData.add(IndividualBar(x: index, y: widget.barChartValuesData[index].y));

      if (maxValue <= widget.barChartValuesData[index].y) maxValue = widget.barChartValuesData[index].y;
    }
    // if (maxValue <= 5) {
    //   _scoreLimit = 5; // If the max value is less than 10, set the limit to 10
    // } else if (maxValue < 10) {
    //   _scoreLimit = 10; // If the max value is less than 10, set the limit to 10
    // } else if (maxValue <= 100) {
    //   _scoreLimit = 100; // If the max value is between 10 and 100, set the limit to 100
    // } else {
    //   // If the max value is greater than 100, round up to the nearest multiple of 5
    //   _scoreLimit = maxValue;
    // }
    _calculateTotalPages();
  }

  void _calculateTotalPages() {
    var filteredDataCount = barData.where((bar) => bar.y <= _scoreLimit).length;
    _totalPages = (filteredDataCount / _pageSize).ceil();
    _currentPage = 0; // Reset to first page whenever the filter changes
  }

  @override
  void didUpdateWidget(CustomBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Call this in case the data changes to recalculate pages
    _calculateTotalPages();
  }

  List<IndividualBar> _getPaginatedFilteredData() {
    final filteredData = barData.where((bar) => bar.y <= _scoreLimit).toList();
    _totalPages = (filteredData.length / _pageSize).ceil();
    final startIndex = _currentPage * _pageSize;
    final endIndex = min(startIndex + _pageSize, filteredData.length);
    return filteredData.sublist(startIndex, endIndex);
  }

  BarChartGroupData _buildBarChartGroupData(IndividualBar data, int index, bool isTouched) {
    return BarChartGroupData(
      x: data.x,
      barRods: [
        BarChartRodData(
            borderSide: BorderSide(
              color: ThemeConfig.getPrimaryColorShade(200)!,
              width: isTouched ? 3 : 0,
            ),
            // toY: isTouched ? data.y : data.y,
            toY: data.y,
            color: isTouched
                ? ThemeConfig.primaryColor
                : data.y <= _scoreLimit.toDouble() * 0.5
                    ? ThemeConfig.getPrimaryColorShade(100)
                    : (data.y > _scoreLimit.toDouble() * 0.5 && data.y <= _scoreLimit.toDouble() * 0.7)
                        ? ThemeConfig.getPrimaryColorShade(400)
                        : (data.y > _scoreLimit.toDouble() * 0.7)
                            ? ThemeConfig.primaryColor
                            : ThemeConfig.primaryColor,
            // gradient: getBarsGradientColor(),
            width: 20,
            borderRadius: BorderRadius.circular(20),
            backDrawRodData:
                // BackgroundBarChartRodData(show: true, toY: _scoreLimit.toDouble(), color: ThemeConfig.tertiaryColor2)),
                BackgroundBarChartRodData(show: true, toY: _scoreLimit.toDouble(), color: Colors.transparent)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _paginatedFilteredData = _getPaginatedFilteredData();
    final chartWidth = max(_paginatedFilteredData.length * 50.0, 1);
    List<BarChartGroupData> _buildBarChartGroups() => List.generate(_paginatedFilteredData.length, (i) {
          return _buildBarChartGroupData(_paginatedFilteredData[i], i, _touchedIndex == i);
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        // CustomDropdownWidget<int>(
        //   label: 'Filter',
        //   hintText: '<=',
        //   value: scoreLimit,
        //   items: scoreFilterList,
        //   onChanged: (value) {
        //     setState(() {
        //       scoreLimit = value;
        //       _scoreLimit = scoreLimit!.value;
        //       _calculateTotalPages();
        //       _currentPage = 0;
        //     });
        //   },
        // ),
        // CustomScoreFilterDropdownButton(context),
        Container(
          height: 400,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Container(
              width: max(_paginatedFilteredData.length * 50.0, 1),
              child: BarChart(BarChartData(
                maxY: _scoreLimit.toDouble(),
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    if (value == widget.dottedLineIndicatorValue!) {
                      return FlLine(
                        color: Colors.blue, // Color of the grid line at y=70
                        strokeWidth: 1, // Thickness of the grid line
                        dashArray: [5, 5], // Optional: Make it dashed, remove if we want solid line
                      );
                    }
                    return FlLine(
                      color: Colors.transparent, // Hiding other lines by making them transparent
                      strokeWidth: 0,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                    top: BorderSide.none,
                    left: BorderSide.none,
                    right: BorderSide.none,
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: ThemeConfig.primaryColor,
                    tooltipPadding: EdgeInsets.fromLTRB(4, 2, 4, 0),
                    fitInsideVertically: true,
                    tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toString(),
                        TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toString(),
                          style: TextStyle(fontSize: 12, color: ThemeConfig.primaryTextColor),
                        );
                      },
                    )),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            reservedSize: 60,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Transform.rotate(
                                angle: -45 * (pi / 180),
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    '${widget.barChartValuesData[value.toInt()].x} ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ThemeConfig.primaryTextColor!,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }))),
                barGroups: _buildBarChartGroups(),
              )),
            ),
          ),
        ),
        if (_totalPages > 1) _buildPaginationControls(),
      ],
    );
  }

  // Widget CustomScoreFilterDropdownButton(BuildContext context) {
  //   List<String> displayItems = <int>[30, 50, 70, 100].map((entry) => "${entry}").toList();
  //
  //   return Container(
  //     // margin: EdgeInsets.all(10),
  //     child: ConstrainedBox(
  //       constraints: const BoxConstraints(
  //         minWidth: 50, // Set your minimum width here
  //         maxWidth: 100, // Set your maximum width here
  //       ),
  //       child: CustomDropdown<String>(
  //         hintText: '<=',
  //         items: displayItems,
  //         overlayHeight: 342,
  //         onChanged: (value) {
  //           int? selectedKey;
  //           for (var entry in <int>[30, 50, 70, 100]) {
  //             if (entry == int.parse(value)) {
  //               selectedKey = int.parse(value);
  //               break;
  //             }
  //           }
  //           setState(() {
  //             _scoreLimit = selectedKey!;
  //             _calculateTotalPages();
  //             _currentPage = 0;
  //           });
  //         },
  //         decoration: customDropdownDecoration,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPaginationControls() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: ThemeConfig.primaryTextColor,
            ),
            style: ThemeConfig.elevatedRoundedButtonStyle,
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              'Showing ${_currentPage + 1} of $_totalPages',
              style: TextStyle(
                fontSize: 14,
                color: ThemeConfig.primaryTextColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: ThemeConfig.primaryTextColor,
            ),
            style: ThemeConfig.elevatedRoundedButtonStyle,
          ),
        ],
      ),
    );
  }
}
