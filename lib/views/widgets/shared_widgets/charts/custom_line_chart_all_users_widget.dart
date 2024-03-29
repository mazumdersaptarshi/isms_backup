import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/charts/line_charts/custom_line_chart_data_point.dart';

class CustomLineChartAllUsersWidget extends StatefulWidget {
  final Map<String, dynamic> metricAndData;

  CustomLineChartAllUsersWidget({super.key, required this.metricAndData});

  @override
  State<CustomLineChartAllUsersWidget> createState() => _CustomLineChartAllUsersWidgetState();
}

class _CustomLineChartAllUsersWidgetState extends State<CustomLineChartAllUsersWidget> {
  String _selectedMetricType = 'All';
  Map<String, dynamic> metricTypeData = {};

  List<Color> coursesCompletedGradientColors = [
    ThemeConfig.primaryColor!,
    Colors.redAccent,
  ];
  List<Color> coursesEnrolledGradientColors = [
    Colors.pink!,
    Colors.orange,
  ];
  List<Color> userActivityGradientColors = [
    Colors.green,
    Colors.orangeAccent,
  ];

  Map<int, String> _calculateLeftTitles(List<CustomLineChartDataPoint> data) {
    // Determine min and max y values
    double minY = data.map((e) => e.y).reduce(min);
    double maxY = data.map((e) => e.y).reduce(max);
    // maxY = 80.0;
    // Calculate range and suggest intervals
    double range = maxY - minY;
    double interval = range / 10; // For example, create 5 intervals

    // Generate titles for these intervals
    Map<int, String> titles = {};
    for (int i = 0; i <= range; i += interval.ceil()) {
      int value = int.parse((minY + i).toString());

      titles[value] = value.toString(); // Customize formatting as needed
    }

    return titles;
  }

  @override
  void initState() {
    super.initState();
    // Initialize the metricTypeData map

    metricTypeData = widget.metricAndData;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Color>> dataTypesAndColors = {
      'Courses Completed over Time': coursesCompletedGradientColors,
      'Active Users': userActivityGradientColors,
      'Courses Enrolled over Time': coursesEnrolledGradientColors,
      // Add more data types and their colors as needed
    };
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricSelectionDropdown(),
          Row(
            children: [
              Container(
                // color: Colors.pink,
                width: 600,
                height: 300,
                padding: EdgeInsets.all(20),

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
              // _buildLineChartLegend(dataTypesAndColors: dataTypesAndColors),
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
    var titles = _calculateLeftTitles(_selectedMetricType == 'All'
        ? [...coursesCompletedOverTimeData, ...activeUsersData]
        : _selectedMetricType == 'Courses Completed over Time'
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
    if (_selectedMetricType == 'All') {
      // Include both sets of data for 'All'
      metricTypeData.forEach((key, value) {
        if (key != 'All') {
          var spots = value['data'] as List<FlSpot>;
          var colors = value['colors'] as List<Color>;
          lineBarsData.add(_getLineChartBarData(spots, colors));
        }
      });
    } else {
      // Retrieve the selected metric's data and colors from the map for specific selections
      var selectedMetric = metricTypeData[_selectedMetricType];
      List<FlSpot> spots = selectedMetric['data'];
      List<Color> colors = selectedMetric['colors'];
      lineBarsData.add(_getLineChartBarData(spots, colors));
    }

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white!,

          // Other tooltip customizations
        ),
      ),
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
      dotData: FlDotData(
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
    List<String> displayItems = <String>[
      'All',
      'Courses Completed over Time',
      'Active Users',
      'Courses Enrolled over Time'
    ].map((entry) => "${entry}").toList();

    return Container(
      margin: EdgeInsets.all(10),
      // Dropdown button to select chart data type
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metrics',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          SizedBox(
            height: 10,
          ),
          ConstrainedBox(
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
                // decoration: customDropdownDecoration,
              )),
        ],
      ),
    );
  }

  Widget _buildLineChartLegend({required Map<String, List<Color>> dataTypesAndColors}) {
    return Container(
      // color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dataTypesAndColors.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: Row(
                // mainAxisSize: MainAxisSize.min
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: entry.value.first, // Take the first color from the gradient list
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      entry.key,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
