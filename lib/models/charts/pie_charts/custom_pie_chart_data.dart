import 'dart:ui';

class CustomPieChartData {
  final String label;
  final double percent;

  Color? color;

  CustomPieChartData({required this.label, required this.percent, this.color});
}
