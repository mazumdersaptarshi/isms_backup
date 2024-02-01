import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphsPage extends StatelessWidget {
  final Map<String, Map<String, List<Map<String, Map<String, int>>>>> examData =
      {
    "course1": {
      "exam1": [
        {
          "student1": {"score": 27},
          "student2": {"score": 90},
          "student3": {"score": 75},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam2": [
        {
          "student1": {"score": 88},
          "student2": {"score": 92},
          "student3": {"score": 78},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam3": [
        {
          "student1": {"score": 82},
          "student2": {"score": 87},
          "student3": {"score": 80},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
    },
    "course2": {
      "exam1": [
        {
          "student1": {"score": 68},
          "student2": {"score": 70},
          "student3": {"score": 66},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam2": [
        {
          "student1": {"score": 72},
          "student2": {"score": 74},
          "student3": {"score": 71},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam3": [
        {
          "student1": {"score": 69},
          "student2": {"score": 65},
          "student3": {"score": 67},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
    },
    "course3": {
      "exam1": [
        {
          "student1": {"score": 95},
          "student2": {"score": 92},
          "student3": {"score": 90},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam2": [
        {
          "student1": {"score": 93},
          "student2": {"score": 91},
          "student3": {"score": 94},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam3": [
        {
          "student1": {"score": 96},
          "student2": {"score": 98},
          "student3": {"score": 97},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
    },
    // Additional courses
    "course4": {
      "exam1": [
        {
          "student1": {"score": 77},
          "student2": {"score": 84},
          "student3": {"score": 80},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam2": [
        {
          "student1": {"score": 82},
          "student2": {"score": 78},
          "student3": {"score": 75},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam3": [
        {
          "student1": {"score": 85},
          "student2": {"score": 88},
          "student3": {"score": 83},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
    },
    "course5": {
      "exam1": [
        {
          "student1": {"score": 65},
          "student2": {"score": 62},
          "student3": {"score": 70},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam2": [
        {
          "student1": {"score": 68},
          "student2": {"score": 71},
          "student3": {"score": 73},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam3": [
        {
          "student1": {"score": 56},
          "student2": {"score": 87},
          "student3": {"score": 72},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 35},
        },
      ],
    },
    "course6": {
      "exam1": [
        {
          "student1": {"score": 90},
          "student2": {"score": 92},
          "student3": {"score": 88},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam2": [
        {
          "student1": {"score": 85},
          "student2": {"score": 87},
          "student3": {"score": 89},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam3": [
        {
          "student1": {"score": 83},
          "student2": {"score": 81},
          "student3": {"score": 84},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
    },
    "course7": {
      "exam1": [
        {
          "student1": {
            "score": 55,
          },
          "student2": {"score": 60},
          "student3": {"score": 58},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam2": [
        {
          "student1": {"score": 62},
          "student2": {"score": 64},
          "student3": {"score": 67},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
      "exam3": [
        {
          "student1": {"score": 70},
          "student2": {"score": 72},
          "student3": {"score": 68},
          "student4": {"score": 40},
          "student5": {"score": 50},
          "student6": {"score": 71},
        },
      ],
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
                Text(course,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ...examCharts,
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
                width: 50),
          ],
        ));
      });
    });
    return barGroups;
  }

  Widget _buildChart(String exam, List<BarChartGroupData> barGroups) {
    return Column(
      children: <Widget>[
        Text('$exam',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        SizedBox(
          height: 350,
          width: double.infinity,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              gridData: FlGridData(show: true),
              // Remove grid lines
              titlesData: FlTitlesData(
                // Reduce label size and adjust other title settings
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getTitles,
                    reservedSize: 28, // Adjust the space for titles
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
                  top: BorderSide.none, // Hide top border
                  right: BorderSide.none, // Hide right border
                ),
              ),
              groupsSpace: 10,
              // Other BarChartData settings...

              // Other BarChartData settings...
            ),
          ),
        )
      ],
    );
  }

  Widget _getTitles(double value, TitleMeta meta) {
    // Customize this method to change how titles are displayed
    return Text(
      value.toString(),
      style: TextStyle(
        fontSize: 10, // Smaller font size for titles
      ),
    );
  }
}
