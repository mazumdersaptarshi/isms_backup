import 'dart:ui';

import 'custom_line_chart_data_point.dart';

class CustomLineChartDataConfig {
  final List<CustomLineChartDataPoint> dataPoints;
  final List<Color> gradientColors;

  final String title;

  CustomLineChartDataConfig({required this.dataPoints, required this.gradientColors, required this.title});
}
