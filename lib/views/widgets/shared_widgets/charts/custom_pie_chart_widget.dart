import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/models/charts/pie_charts/custom_pie_chart_data.dart';

class CustomPieChartWidget extends StatefulWidget {
  const CustomPieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;
  List<CustomPieChartData> data = [
    CustomPieChartData(label: 'completed', percent: 35, color: Colors.lightGreen),
    CustomPieChartData(label: 'not started', percent: 20, color: Colors.grey),
    CustomPieChartData(label: 'in progress', percent: 40, color: Colors.orange),
    CustomPieChartData(label: 'not registered', percent: 5, color: Colors.purpleAccent),
  ];

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> convertedData = List.generate(data.length, (index) {
      final isTouched = index == touchedIndex;
      final baseRadius = 150.0;
      final touchRadius = 165.0;
      final item = data[index];

      return PieChartSectionData(
        title: '${item.percent}%',
        color: item.color,
        // Assuming `item.color` is a Color object
        value: item.percent,
        radius: isTouched ? touchRadius : baseRadius,
        titleStyle: TextStyle(fontSize: isTouched ? 18 : 16, fontWeight: FontWeight.bold, color: Colors.white),
        titlePositionPercentageOffset: 0.55,
      );
    });
    return Row(
      children: [
        Container(
          width: 400,
          height: 300,
          child: PieChart(
              swapAnimationDuration: const Duration(milliseconds: 200),
              swapAnimationCurve: Curves.easeInOutQuint,
              PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }),
                  centerSpaceRadius: 0,
                  // borderData: FlBorderData(show: true, border: Border.all(color: Colors.black, width: 2)),
                  sections: convertedData)),
        ),
        SizedBox(height: 20),
        buildLegend(data), // Call buildLegend here
      ],
    );
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
              Text(item.label, style: TextStyle(fontSize: 14)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
