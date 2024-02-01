import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphsPage extends StatelessWidget {
  final Map<String, Map<String, List<Map<String, Map<String, int>>>>> examData =
  {
    "course1": {
      "exam1": [
        {
          "student1": {"score": 45},
          "student2": {"score": 90},
          "student3": {"score": 75}
        }
      ],
      "exam2": [
        {
          "student1": {"score": 73},
          "student2": {"score": 50},
          "student3": {"score": 35}
        }
      ],
      "exam3": [
        {
          "student1": {"score": 15},
          "student2": {"score": 90},
          "student3": {"score": 100}
        }
      ]
    },
    "course2": {
      "exam1": [
        {
          "student1": {"score": 95},
          "student2": {"score": 26},
          "student3": {"score": 54}
        }
      ],
      "exam2": [
        {
          "student1": {"score": 72},
          "student2": {"score": 74},
          "student3": {"score": 71}
        }
      ],
      "exam3": [
        {
          "student1": {"score": 69},
          "student2": {"score": 65},
          "student3": {"score": 67}
        }
      ]
    },
    "course3": {
      "exam1": [
        {
          "student1": {"score": 95},
          "student2": {"score": 51},
          "student3": {"score": 30}
        }
      ],
      "exam2": [
        {
          "student1": {"score": 100},
          "student2": {"score": 71},
          "student3": {"score": 34}
        }
      ],
      "exam3": [
        {
          "student1": {"score": 96},
          "student2": {"score": 98},
          "student3": {"score": 97}
        }
      ]
    },
    "course4": {
      "exam1": [
        {
          "student1": {"score": 77},
          "student2": {"score": 84},
          "student3": {"score": 80}
        }
      ],
      "exam2": [
        {
          "student1": {"score": 22},
          "student2": {"score": 58},
          "student3": {"score": 65}
        }
      ],
      "exam3": [
        {
          "student1": {"score": 85},
          "student2": {"score": 58},
          "student3": {"score": 13}
        }
      ]
    },
    "course5": {
      "exam1": [
        {
          "student1": {"score": 65},
          "student2": {"score": 62},
          "student3": {"score": 70}
        }
      ],
      "exam2": [
        {
          "student1": {"score": 68},
          "student2": {"score": 71},
          "student3": {"score": 73}
        }
      ],
      "exam3": [
        {
          "student1": {"score": 95},
          "student2": {"score": 67},
          "student3": {"score": 72}
        }
      ]
    },
    "course6": {
      "exam1": [
        {
          "student1": {"score": 70},
          "student2": {"score": 32},
          "student3": {"score": 88}
        }
      ],
      "exam2": [
        {
          "student1": {"score": 85},
          "student2": {"score": 57},
          "student3": {"score": 39}
        }
      ],
      "exam3": [
        {
          "student1": {"score": 53},
          "student2": {"score": 91},
          "student3": {"score": 14}
        }
      ]
    },
    "course7": {
      "exam1": [
        {
          "student1": {"score": 45},
          "student2": {"score": 60},
          "student3": {"score": 98}
        }
      ],
      "exam2": [
        {
          "student1": {"score": 52},
          "student2": {"score": 64},
          "student3": {"score": 97}
        }
      ],
      "exam3": [
        {
          "student1": {"score": 40},
          "student2": {"score": 32},
          "student3": {"score": 68}
        }
      ]
    }
  };


  Widget build(BuildContext context) {
    List<Widget> courseCharts = _buildCourseCharts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
      ),
      body: SingleChildScrollView(
        // Make the whole page scrollable
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            children: courseCharts,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCourseCharts() {
    List<Widget> courseCharts = [];
    examData.forEach((course, exams) {
      List<Widget> examCharts = [];
      exams.forEach((exam, scoresList) {
        examCharts.add(_buildChart(exam, _buildBarGroups(scoresList)));
      });

      courseCharts.add(
        Card(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...examCharts,
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
    return courseCharts;
  }

  List<BarChartGroupData> _buildBarGroups(
      List<Map<String, Map<String, int>>> scoresList) {
    List<BarChartGroupData> barGroups = [];
    int barId = 0;
    scoresList.forEach((studentScores) {
      studentScores.forEach((student, data) {
        barGroups.add(BarChartGroupData(
          x: barId++,
          barRods: [
            BarChartRodData(
                toY: data['score']!.toDouble(),
                color: Colors.blue.shade100,
                width: 30),
          ],
        ));
      });
    });
    return barGroups;
  }

  Widget _buildChart(String exam, List<BarChartGroupData> barGroups) {
    return Row(
      children: [
        Column(
          children: <Widget>[
            Text('$exam',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              height: 300,
              width: 300,
              child: BarChart(
                BarChartData(
                  maxY: 100,
                  barGroups: barGroups,
                  gridData: FlGridData(show: false),
                  // Remove grid lines
                  titlesData: FlTitlesData(
                    // Reduce label size and adjust other title settings
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _getTitles,
                        reservedSize: 28, // Adjust the space for titles
                        interval: 20, // Set interval to 20
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _getTitles,
                        reservedSize: 28,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        getTitlesWidget: _getTitles,
                        reservedSize: 28,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        getTitlesWidget: _getTitles,
                        reservedSize: 28,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.black, width: 1),
                      bottom: BorderSide(color: Colors.black, width: 1),
                      top: BorderSide.none,
                      right: BorderSide.none,
                    ),
                  ),
                  groupsSpace: 10,
                  // Other BarChartData settings...
                ),
              ),
            )
          ],
        ),
        SizedBox(width: 50),
      ],
    );
  }

  Widget _getTitles(double value, TitleMeta meta) {
    // Customize this method to change how titles are displayed
    return Text(
      value.toString(),
      style: TextStyle(
        fontSize: 13,
      ),
    );
  }
}
