import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/models/charts/bar_charts/individual_bar.dart';

class CustomBarChart extends StatefulWidget {
  const CustomBarChart({
    super.key,
    required this.barData,
    required this.barChartValuesData,
  });

  final List<IndividualBar> barData;

  final List<dynamic> barChartValuesData;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  int _numberOfBarsLimit = 10;
  int _scoreLimit = 100;

  @override
  Widget build(BuildContext context) {
    List<IndividualBar> _filteredBarData = widget.barData
        .where((bar) => bar.y <= _scoreLimit) // Filter by y value
        .toList();
    List<IndividualBar> _limitedBarData = _filteredBarData.take(_numberOfBarsLimit).toList();

    print(widget.barData);
    return Column(
      children: [
        Row(
          children: [
            Text('Max Columns ='),
            SizedBox(
              width: 4,
            ),
            _buildMaxDataDropdownMenu(),
          ],
        ),
        Row(
          children: [
            Text('Score <='),
            SizedBox(
              width: 4,
            ),
            _buildScoreFilterDropdownMenu(),
          ],
        ),
        Expanded(
          child: Container(
            height: 400,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                // width: widget.barData.length * 50.0,
                // width: _limitedBarData.length * 50.0,
                width: max(_limitedBarData.length * 50.0, 1),
                child: BarChart(BarChartData(
                  maxY: 100,
                  minY: 0,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: primary,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      // Handle touch events if needed
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
                                return Text(
                                  '${widget.barChartValuesData[value.toInt()].x}',
                                  style: TextStyle(fontSize: 12),
                                );
                              }))),
                  barGroups: _limitedBarData
                      .map((data) => BarChartGroupData(
                            x: data.x,
                            barRods: [
                              BarChartRodData(
                                  toY: data.y,
                                  color: data.y <= 50
                                      ? Colors.redAccent
                                      : (data.y > 50 && data.y <= 70)
                                          ? Colors.orange
                                          : (data.y > 70)
                                              ? Colors.lightGreen
                                              : primary,
                                  width: 25,
                                  borderRadius: BorderRadius.circular(4),
                                  backDrawRodData:
                                      BackgroundBarChartRodData(show: true, toY: 100, color: Colors.grey.shade200)),
                            ],
                          ))
                      .toList(),
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaxDataDropdownMenu() {
    return DropdownButton<int>(
      value: _numberOfBarsLimit,
      items: <int>[10, 20, 50, 100].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _numberOfBarsLimit = newValue!;
          // You might also want to adjust the logic for displaying bars based on this new limit
        });
      },
    );
  }

  Widget _buildScoreFilterDropdownMenu() {
    return DropdownButton<int>(
      value: _scoreLimit,
      items: <int>[30, 50, 70, 100].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _scoreLimit = newValue!;
          // You might also want to adjust the logic for displaying bars based on this new limit
        });
      },
    );
  }
}
