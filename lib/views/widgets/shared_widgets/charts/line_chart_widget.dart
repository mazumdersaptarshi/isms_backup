import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/models/charts/line_charts/custom_line_chart_data.dart';

class CustomLineChartWidget extends StatefulWidget {
  const CustomLineChartWidget({super.key});

  @override
  State<CustomLineChartWidget> createState() => _CustomLineChartWidgetState();
}

class _CustomLineChartWidgetState extends State<CustomLineChartWidget> {
  String _selectedMetricType = 'all';
  Map<String, dynamic> metricTypeData = {};

  List<Color> avgScoresGradientColors = [
    primary!,
    Colors.deepPurpleAccent,
  ];
  List<Color> userActivityGradientColors = [
    Colors.green,
    Colors.orangeAccent,
  ];

  List<CustomLineChartData> coursesCompletedOverTimeData = [
    CustomLineChartData(x: 1, y: 3),
    CustomLineChartData(x: 2, y: 5),
    CustomLineChartData(x: 3, y: 6),
    CustomLineChartData(x: 4, y: 2),
    CustomLineChartData(x: 5, y: 24),
    CustomLineChartData(x: 6, y: 12),
    CustomLineChartData(x: 7, y: 43),
    CustomLineChartData(x: 8, y: 34),
    CustomLineChartData(x: 9, y: 20),
    CustomLineChartData(x: 10, y: 3),
    CustomLineChartData(x: 11, y: 7),
    CustomLineChartData(x: 12, y: 4),
    // Add more data points as necessary
  ];
  List<CustomLineChartData> activeUsersData = [
    CustomLineChartData(x: 1, y: 5),
    CustomLineChartData(x: 2, y: 12),
    CustomLineChartData(x: 3, y: 7),
    CustomLineChartData(x: 4, y: 3),
    CustomLineChartData(x: 5, y: 36),
    CustomLineChartData(x: 6, y: 20),
    CustomLineChartData(x: 7, y: 50),
    CustomLineChartData(x: 8, y: 44),
    CustomLineChartData(x: 9, y: 26),
    CustomLineChartData(x: 10, y: 5),
    CustomLineChartData(x: 11, y: 8),
    CustomLineChartData(x: 12, y: 4),
    // Add more data points as necessary
  ];

  Map<int, String> _calculateLeftTitles(List<CustomLineChartData> data) {
    // Determine min and max y values
    double minY = data.map((e) => e.y).reduce(min);
    double maxY = data.map((e) => e.y).reduce(max);

    // Calculate range and suggest intervals
    double range = maxY - minY;
    double interval = range / 15; // For example, create 5 intervals

    // Generate titles for these intervals
    Map<int, String> titles = {};
    for (int i = 0; i <= range; i += interval.ceil()) {
      int value = int.parse((minY + i).toString());

      titles[value] = value.toString(); // Customize formatting as needed
      print(value);
    }

    return titles;
  }

  @override
  void initState() {
    super.initState();
    // Initialize the metricTypeData map
    metricTypeData = {
      'all': {
        'data': coursesCompletedOverTimeData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': avgScoresGradientColors,
      },
      'completed courses': {
        'data': coursesCompletedOverTimeData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': avgScoresGradientColors,
      },
      'user activity': {
        'data': activeUsersData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': userActivityGradientColors,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Color>> dataTypesAndColors = {
      'Completed Courses': avgScoresGradientColors,
      'User Activity': userActivityGradientColors,
      // Add more data types and their colors as needed
    };
    return Container(
      // color: Colors.red,
      child: Column(
        children: [
          _buildMetricSelectionDropdown(),
          Row(
            children: [
              Container(
                // color: Colors.pink,
                width: 600,
                height: 300,
                child: Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.70,
                      child: LineChart(
                        _buildLineChart(),
                      ),
                      // Text('jdj'),
                    ),
                  ],
                ),
              ),
              _buildLineChartLegend(dataTypesAndColors: dataTypesAndColors),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade600);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Jan', style: style);
        break;
      case 2:
        text = Text('Feb', style: style);
        break;
      case 3:
        text = Text('Mar', style: style);
        break;
      case 4:
        text = Text('Apr', style: style);
        break;
      case 5:
        text = Text('May', style: style);
        break;
      case 6:
        text = Text('Jun', style: style);
        break;
      case 7:
        text = Text('Jul', style: style);
        break;
      case 8:
        text = Text('Aug', style: style);
        break;
      case 9:
        text = Text('Sep', style: style);
        break;
      case 10:
        text = Text('Oct', style: style);
        break;
      case 11:
        text = Text('Nov', style: style);
        break;
      case 12:
        text = Text('Dec', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var titles = _calculateLeftTitles(_selectedMetricType == 'all'
        ? [...coursesCompletedOverTimeData, ...activeUsersData]
        : _selectedMetricType == 'completed courses'
            ? coursesCompletedOverTimeData
            : activeUsersData);
    String text = titles[value] ?? '';
    return Text(text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
        ));
  }

  LineChartData _buildLineChart() {
    List<LineChartBarData> lineBarsData = [];
    if (_selectedMetricType == 'all') {
      // Include both sets of data for 'all'
      metricTypeData.forEach((key, value) {
        var spots = value['data'] as List<FlSpot>;
        var colors = value['colors'] as List<Color>;
        lineBarsData.add(_getLineChartBarData(spots, colors));
      });
    } else {
      // Retrieve the selected metric's data and colors from the map for specific selections
      var selectedMetric = metricTypeData[_selectedMetricType];
      List<FlSpot> spots = selectedMetric['data'];
      List<Color> colors = selectedMetric['colors'];
      lineBarsData.add(_getLineChartBarData(spots, colors));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 5,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade400,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.shade400,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: 50,
      lineBarsData: lineBarsData,
    );
  }

  LineChartBarData _getLineChartBarData(List<FlSpot> activeSpots, List<Color> gradientColors) {
    return LineChartBarData(
      spots: activeSpots,
      isCurved: false,
      gradient: LinearGradient(
        colors: gradientColors,
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
  }

  Widget _buildMetricSelectionDropdown() {
    List<String> displayItems =
        <String>['all', 'completed courses', 'user activity'].map((entry) => "${entry}").toList();

    return Container(
      margin: EdgeInsets.all(10),
      // Dropdown button to select chart data type
      child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 50, // Set your minimum width here
            maxWidth: 200, // Set your maximum width here
          ),
          child: CustomDropdown<String>(
            hintText: 'metric',
            items: displayItems,
            overlayHeight: 342,
            onChanged: (String value) {
              setState(() {
                _selectedMetricType = value;
              });
            },
            decoration: customDropdownDecoration,
          )),
    );
  }

  Widget _buildLineChartLegend({required Map<String, List<Color>> dataTypesAndColors}) {
    return Container(
      // color: Colors.purple,
      child: Column(
        children: dataTypesAndColors.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: entry.value.first, // Take the first color from the gradient list
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  entry.key,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
