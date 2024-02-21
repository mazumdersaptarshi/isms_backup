import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Define the ChartData class outside to make it reusable.
class HorizontalBarChartData {
  HorizontalBarChartData({required this.x, required this.y});

  final String x;
  final double y;
}

// Create a stateful widget for your chart.
class HorizontalBarChartWidget extends StatefulWidget {
  HorizontalBarChartWidget({Key? key, required this.data}) : super(key: key);
  List<HorizontalBarChartData> data = [];

  @override
  _HorizontalBarChartWidgetState createState() => _HorizontalBarChartWidgetState();
}

class _HorizontalBarChartWidgetState extends State<HorizontalBarChartWidget> {
  late TooltipBehavior _tooltipBehavior;
  String _selectedRange = ''; // This will now be set dynamically based on filtered data
  final int _batchSize = 20;
  int _selectedScoreLimit = 100;
  late List<HorizontalBarChartData> _filteredData; // To store filtered data

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true, color: primary, textStyle: TextStyle(color: Colors.white));
    _updateFilteredData(); // Initialize the filtered data based on the default score limit
  }

  void _updateFilteredData() {
    // Filter data based on the selected score limit
    _filteredData = widget.data.where((data) => data.y <= _selectedScoreLimit).toList();
    // Update selected range based on the new filtered data size
    _updateSelectedRange();
  }

  void _updateSelectedRange() {
    // Set the range to show the first batch of the filtered data
    int endRange = min(_batchSize, _filteredData.length);
    _selectedRange = '1-$endRange';
  }

  @override
  Widget build(BuildContext context) {
    const double perBarHeight = 0.7;
    //Here we are setting the chart height to handle various heights of the charts.
    double chartHeight = min(_getDataSourceBasedOnSelectedRange().length * (perBarHeight) * 27, 400);
    chartHeight = max(chartHeight, 200);
    print('_filteredData length: ${chartHeight}');
    return Column(
      children: [
        _buildScoreFilterDropdown(),
        _buildBarsRangeDropdown(
          _filteredData.length,
          _batchSize,
          _selectedRange,
          (newValue) {
            setState(() {
              _selectedRange = newValue!;
            });
          },
        ),
        SizedBox(
          height: chartHeight,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: 100, interval: 10),
            tooltipBehavior: _tooltipBehavior,
            legend: Legend(isVisible: true),
            series: <CartesianSeries<HorizontalBarChartData, String>>[
              BarSeries<HorizontalBarChartData, String>(
                // width: perBarHeight,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.outer,
                    textStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ) // Ensure good contrast
                    ),
                dataSource: _getDataSourceBasedOnSelectedRange(),
                xValueMapper: (HorizontalBarChartData data, _) => data.x,
                yValueMapper: (HorizontalBarChartData data, _) => data.y,
                pointColorMapper: (HorizontalBarChartData data, _) {
                  // Determine label and return matching color
                  final String label = data.y < 50
                      ? '<50'
                      : data.y < 70
                          ? '<70'
                          : '<100';
                  return _getColorBasedOnScore(data.y); //  Reuse existing logic
                },
                borderRadius: BorderRadius.circular(10),
                name: 'Average Score',
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<HorizontalBarChartData> _getDataSourceBasedOnSelectedRange() {
    List<String> selectedParts = _selectedRange.split('-');
    int startIndex = int.parse(selectedParts[0]) - 1;
    int endIndex = min(int.parse(selectedParts[1]), _filteredData.length);
    return _filteredData.sublist(startIndex, endIndex);
  }

  Widget _buildScoreFilterDropdown() {
    return DropdownButton<int>(
      value: _selectedScoreLimit,
      onChanged: (newValue) {
        setState(() {
          _selectedScoreLimit = newValue!;
          _updateFilteredData(); // Update the filtered data and range when score limit changes
        });
      },
      items: <int>[50, 70, 100].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('Score <= $value'),
        );
      }).toList(),
    );
  }

  // Updated to generate dropdown items based on filtered data length
  Widget _buildBarsRangeDropdown(
      int itemCount, int batchSize, String selectedValue, Function(String?) onChangedCallback) {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < itemCount; i += batchSize) {
      int start = i + 1;
      int end = min(i + batchSize, itemCount);
      String value = "$start-$end";
      items.add(DropdownMenuItem<String>(
        value: value,
        child: Text('Range between ${value}'),
      ));
    }

    return DropdownButton<String>(
      value: selectedValue,
      items: items,
      onChanged: onChangedCallback,
    );
  }

  Color _getColorBasedOnScore(double score) {
    if (score < 50) {
      return Colors.redAccent;
    } else if (score >= 50 && score < 70) {
      return Colors.orangeAccent;
    } else {
      return Colors.lightGreen;
    }
  }
}
