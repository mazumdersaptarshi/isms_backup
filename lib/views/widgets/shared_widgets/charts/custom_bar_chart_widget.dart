import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/charts/bar_charts/individual_bar.dart';

class CustomBarChart extends StatefulWidget {
  CustomBarChart({
    super.key,
    required this.barChartValuesData,
  });

  final List<dynamic> barChartValuesData;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  int _scoreLimit = 100;
  int _touchedIndex = -1;

  int _currentPage = 0;
  final int _pageSize = 15;
  int _totalPages = 0;
  List<IndividualBar> barData = [];

  //Test Data

  @override
  void initState() {
    print(widget.key);
    super.initState();

    _buildBarData();
    _calculateTotalPages();
  }

  void _buildBarData() {
    for (int index = 0; index < widget.barChartValuesData.length; index++) {
      barData
          .add(IndividualBar(x: index, y: widget.barChartValuesData[index].y));
    }
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

  BarChartGroupData _buildBarChartGroupData(
      IndividualBar data, int index, bool isTouched) {
    return BarChartGroupData(
      x: data.x,
      barRods: [
        BarChartRodData(
            borderSide: BorderSide(
              color: getPrimaryColorShade(200)!,
              width: isTouched ? 3 : 0,
            ),
            toY: isTouched ? data.y + 2 : data.y,
            color: isTouched
                ? primary
                : data.y <= 50
                    ? Colors.redAccent
                    : (data.y > 50 && data.y <= 70)
                        ? Colors.orangeAccent
                        : (data.y > 70)
                            ? Colors.lightGreen
                            : primary,
            // gradient: getBarsGradientColor(),
            width: 20,
            borderRadius: BorderRadius.circular(5),
            backDrawRodData: BackgroundBarChartRodData(
                show: true, toY: 100, color: Colors.grey.shade300)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _paginatedFilteredData = _getPaginatedFilteredData();
    final chartWidth = max(_paginatedFilteredData.length * 50.0, 1);

    List<BarChartGroupData> _buildBarChartGroups() =>
        List.generate(_paginatedFilteredData.length, (i) {
          return _buildBarChartGroupData(
              _paginatedFilteredData[i], i, _touchedIndex == i);
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Score Filter',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        SizedBox(
          height: 10,
        ),
        CustomScoreFilterDropdownButton(context),
        Container(
          // decoration: BoxDecoration(
          //     color: Colors.grey.shade100,
          //     borderRadius: BorderRadius.circular(20),
          //     border: Border.all(color: Colors.grey.shade200)),
          height: 400,
          child: Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Container(
                // width: widget.barData.length * 50.0,
                // width: _limitedBarData.length * 50.0,
                width: max(_paginatedFilteredData.length * 50.0, 1),

                child: BarChart(BarChartData(
                  maxY: 100,
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: primary,
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
                        _touchedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                      show: true,
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Expanded(
                            child: Text(
                              value.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      )),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Transform.rotate(
                                  angle: -45 * (pi / 180),
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text(
                                      '${widget.barChartValuesData[value.toInt()].x} ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }))),
                  // barGroups: _limitedBarData.map((data) => buildBarChartGroupData(data, 0)).toList(),
                  barGroups: _buildBarChartGroups(),
                )),
              ),
            ),
          ),
        ),
        if (_totalPages > 1) _buildPaginationControls(),
      ],
    );
  }

  Widget CustomScoreFilterDropdownButton(BuildContext context) {
    List<String> displayItems =
        <int>[30, 50, 70, 100].map((entry) => "${entry}").toList();

    return Container(
      // margin: EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 50, // Set your minimum width here
          maxWidth: 100, // Set your maximum width here
        ),
        child: CustomDropdown<String>(
          hintText: '<=',
          items: displayItems,
          overlayHeight: 342,
          onChanged: (value) {
            int? selectedKey;
            for (var entry in <int>[30, 50, 70, 100]) {
              if (entry == int.parse(value)) {
                selectedKey = int.parse(value);
                break;
              }
            }
            setState(() {
              _scoreLimit = selectedKey!;
              _calculateTotalPages();
              _currentPage = 0;
            });
          },
          decoration: customDropdownDecoration,
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed:
                _currentPage > 0 ? () => setState(() => _currentPage--) : null,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              'Showing ${_currentPage + 1} of $_totalPages',
              style: TextStyle(fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: _currentPage < _totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
