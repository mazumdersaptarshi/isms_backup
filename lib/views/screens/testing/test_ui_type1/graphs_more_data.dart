import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';

class DataVisualizationPage extends StatefulWidget {
  @override
  _DataVisualizationPageState createState() => _DataVisualizationPageState();
}

class _DataVisualizationPageState extends State<DataVisualizationPage> {
  bool isDataLoaded = false;
  Map<String, List<double>> chartData = {};

  @override
  void initState() {
    super.initState();
    loadExamData();
  }

  Future<void> loadExamData() async {
    String jsonString = await rootBundle.loadString('assets/data/all_courses/graphs1.json');
    // print('Loaded JSON String: $jsonString');

    Map<String, dynamic> data = json.decode(jsonString);
    processExamData(data);
  }

  void processExamData(Map<String, dynamic> data) {
    List<double> avgScores = [];
    List<double> minScores = [];
    List<double> maxScores = [];
    List<double> avgDurations = [];
    List<double> minDurations = [];
    List<double> maxDurations = [];

    data.forEach((course, exams) {
      exams.forEach((exam, students) {
        students[0].forEach((studentId, studentData) {
          var details = studentData['details'];
          avgScores.add(details['avgScore'].toDouble());
          minScores.add(details['minScore'].toDouble());
          maxScores.add(details['maxScore'].toDouble());
          avgDurations.add(details['avgDuration'].toDouble());
          minDurations.add(details['minDuration'].toDouble());
          maxDurations.add(details['maxDuration'].toDouble());
        });
      });
    });

    chartData = {
      'avgScores': avgScores,
      'minScores': minScores,
      'maxScores': maxScores,
      'avgDurations': avgDurations,
      'minDurations': minDurations,
      'maxDurations': maxDurations,
    };

    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Data Visualization'),
      ),
      body: isDataLoaded
          ? SingleChildScrollView(
              child: Column(
                children: [
                  LineChartWidget(
                    chartData['avgScores']!,
                    chartData['minScores']!,
                    chartData['maxScores']!,
                    'Scores',
                  ),
                  LineChartWidget(
                    chartData['avgDurations']!,
                    chartData['minDurations']!,
                    chartData['maxDurations']!,
                    'Durations (Seconds)',
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> avgData;
  final List<double> minData;
  final List<double> maxData;
  final String title;

  LineChartWidget(this.avgData, this.minData, this.maxData, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            _lineChartBarData(avgData, Colors.blue),
            _lineChartBarData(minData, Colors.green),
            _lineChartBarData(maxData, Colors.red),
          ],
        ),
      ),
    );
  }

  LineChartBarData _lineChartBarData(List<double> data, Color color) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
      isCurved: true,
      barWidth: 2,
      color: Colors.grey,
      dotData: FlDotData(show: false),
    );
  }
}
