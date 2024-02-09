import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../widgets/shared_widgets/custom_app_bar.dart';
import 'bar_chart_data.dart';
import 'graphs_more_data.dart';
import 'quiz_result.dart';
import 'user_profile.dart';
// import 'max_ave_min_chart.dart';

class GraphsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    List<Widget> courseCharts = _buildCourseCharts();
    return Scaffold(
      appBar: IsmsAppBar(context: context),
      body: SingleChildScrollView(
        // Make the whole page scrollable
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to the MoreGraphsPage when the button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DataVisualizationPage()),
                  );
                },
                child: Text('More Graphs'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the MoreGraphsPage when the button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuizResultPage()),
                  );
                },
                child: Text('Quiz Result'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the MoreGraphsPage when the button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileTestPage()),
                  );
                },
                child: Text('User Profile'),
              ),
              SizedBox(height: 20),
              // Added spacing between button and charts
              ...courseCharts,
              // Use the spread operator to add the courseCharts widgets
            ],
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
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(24),
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
                        getTitlesWidget: _getStudentNames,
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

Widget _getStudentNames(double value, TitleMeta meta) {
  int index = value.toInt();
  String studentName = '';
  examData.forEach((course, exams) {
    exams.forEach((exam, scoresList) {
      scoresList.forEach((studentScores) {
        studentScores.forEach((name, data) {
          if (index == 0) {
            studentName = name;
          }
          index--;
        });
      });
    });
  });

  return Transform.rotate(
    angle: -15 * (pi / 180),
    child: Text(
      studentName,
      style: TextStyle(
        fontSize: 13,
      ),
    ),
  );
}