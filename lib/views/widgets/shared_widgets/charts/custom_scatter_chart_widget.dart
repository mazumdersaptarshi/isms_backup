import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_scores_variation_data.dart';

class CustomScatterChartWidget extends StatefulWidget {
  final List<CustomScoresVariationData> usersExamScoresScatterData;
  final Color Function(double)? getColorForScore; // Optional function to determine color
  final int? dottedLineIndicatorValue;

  CustomScatterChartWidget({
    super.key,
    required this.usersExamScoresScatterData,
    this.getColorForScore,
    this.dottedLineIndicatorValue,
  });

  @override
  State<StatefulWidget> createState() => _CustomScatterChartWidgetState();
}

class _CustomScatterChartWidgetState extends State<CustomScatterChartWidget> {
  final maxY = 100.0;
  final int _pageSize = 15;
  int _currentPage = 0;
  int _totalPages = 0;
  int _endIndex = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotalPages();
  }

  void _calculateTotalPages() {
    _totalPages = (widget.usersExamScoresScatterData.length / _pageSize).ceil();
  }

  List<ScatterSpot> _buildScatterSpotsData() {
    List<ScatterSpot> spots = [];
    int start = _currentPage * _pageSize;
    int end = min(start + _pageSize, widget.usersExamScoresScatterData.length);
    _endIndex = end;
    for (int i = start; i < end; i++) {
      int pageIndex = i - start; // Adjust index for current page
      var userData = widget.usersExamScoresScatterData[i];
      double xIndex = pageIndex.toDouble(); // Use local index for x-axis
      for (double score in userData.y) {
        Color spotColor = widget.getColorForScore != null
            ? widget.getColorForScore!(score)
            : Colors.primaries[(pageIndex % Colors.primaries.length)];
        spots.add(ScatterSpot(xIndex, score, color: spotColor));
        // break;
      }
    }
    print(spots);
    return spots;
  }

  Widget _buildPaginationControls() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 0
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
        Container(padding: EdgeInsets.all(8), child: Text('Showing ${_currentPage + 1} of $_totalPages')),
        ElevatedButton(
          onPressed: _currentPage < _totalPages - 1
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        // color: Colors.green,
        width: MediaQuery.of(context).size.width * 0.5,
        // height: 500,
        child: AspectRatio(
          aspectRatio: 2,
          child: ScatterChart(
            ScatterChartData(
              scatterSpots: _buildScatterSpotsData(),
              minX: 0,
              maxX: _pageSize - 1,
              // Adjusted to local page index
              minY: 0,
              maxY: maxY,
              borderData: FlBorderData(show: false),
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
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 60,
                    interval: 1,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = _currentPage * _pageSize + value.toInt();
                      print(value.toInt());
                      if (index >= widget.usersExamScoresScatterData.length) {
                        return Text('');
                      }
                      return Transform.rotate(
                        angle: -45 * (pi / 180),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            widget.usersExamScoresScatterData[index].x,
                            style: TextStyle(
                              fontSize: 12,
                              color: ThemeConfig.primaryTextColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              scatterTouchData: ScatterTouchData(enabled: false),
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
            swapAnimationCurve: Curves.fastOutSlowIn,
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      if (_totalPages > 1) _buildPaginationControls(),
    ]);
  }
}
