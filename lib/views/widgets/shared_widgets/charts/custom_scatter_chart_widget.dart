import 'dart:math';
import 'package:isms/controllers/theme_management/theme_config.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_box_and_whisker_chart_data.dart';

class CustomScatterChartWidget extends StatefulWidget {
  CustomScatterChartWidget(
      {super.key, required this.usersExamScoresScatterData, this.getColorForScore, this.dottedLineIndicatorValue});

  final blue1 = ThemeConfig.getPrimaryColorShade(400)!;
  final blue2 = ThemeConfig.getPrimaryColorShade(700)!;
  List<CustomScoresVariationData> usersExamScoresScatterData = [];
  final Color Function(double)? getColorForScore; // Make this function optional
  int? dottedLineIndicatorValue = 0;

  @override
  State<StatefulWidget> createState() => CustomScatterChartWidgetState();
}

class CustomScatterChartWidgetState extends State<CustomScatterChartWidget> {
  final maxX = 25.0;
  final maxY = 100.0;
  final radius = 8.0;
  List<String> names = [];
  bool showFlutter = true;
  List<String> g = [
    'a',
    'a',
    'a',
    'a',
    'a',
  ];
  List<ScatterSpot> _scatterSpotsData = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AspectRatio(
        aspectRatio: 2.5,
        child: ScatterChart(
          ScatterChartData(
            scatterSpots: _buildScatterSpotsData(),
            minX: 0,
            maxX: (widget.usersExamScoresScatterData.length - 1).toDouble(),
            minY: 0,
            maxY: maxY,
            borderData: FlBorderData(
              show: false,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                top: BorderSide.none,
                left: BorderSide.none,
                right: BorderSide.none,
              ),
            ),
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
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: 60,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toString(),
                        style: TextStyle(color: ThemeConfig.primaryTextColor),
                      );
                    }),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      reservedSize: 60,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Transform.rotate(
                          angle: -45 * (pi / 180),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              '${widget.usersExamScoresScatterData[value.toInt()].x}',
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeConfig.primaryTextColor!,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      })),
            ),
            scatterTouchData: ScatterTouchData(
              enabled: false,
            ),
          ),
          swapAnimationDuration: const Duration(milliseconds: 600),
          swapAnimationCurve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  List<ScatterSpot> _buildScatterSpotsData() {
    Map<String, double> xIndexes = {};

    for (int i = 0; i < widget.usersExamScoresScatterData.length; i++) {
      names.add(widget.usersExamScoresScatterData[i].x);

      xIndexes[widget.usersExamScoresScatterData[i].x] = i.toDouble(); // Map each name to an index
      for (double score in widget.usersExamScoresScatterData[i].y) {
        Color spotColor = widget.getColorForScore != null
            ? widget.getColorForScore!(score)
            : Colors.primaries[((i.toDouble() * score) % Colors.primaries.length).toInt()];
        _scatterSpotsData.add(ScatterSpot(i.toDouble(), score, color: spotColor));
      }
      // _scatterSpotsData.add(ScatterSpot(i.toDouble(), widget.usersExamScoresScatterData[i].y[0]));
    }

    // print(_scatterSpotsData.length);
    // print(names.length);
    return _scatterSpotsData;
  }
}
