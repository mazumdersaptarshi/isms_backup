import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_box_and_whisker_chart_data.dart';

import 'test_data.dart';

Map<String, List<CustomBarChartData>> _usersDataDifferentExamsMap = {
  'yu78nb': usersData23,
  'tr56bb': usersData24,
  'vc34fv': usersData23,
  'io90hj': usersData24
};

Map<String, List<CustomBarChartData>> _usersDataDifferentMetricsMap = {
  'avgScore': usersDataAvgScores,
  'maxScore': usersDataMaxScores,
  'minScore': usersDataMinScores,
};

Map<String, List<CustomBoxAndWhiskerChartData>> _usersDataDifferentExamsMapBoxWhisker = {
  'yu78nb': usersData501,
  'tr56bb': usersData502,
  'vc34fv': usersData501,
  'io90hj': usersData502
};

List<CustomBarChartData> _usersData = [];
List<CustomBoxAndWhiskerChartData> _usersData2 = [];

List<CustomBarChartData> updateUsersDataOnDifferentCourseExamSelectionBarChart(String? examKey) {
  _usersData = (examKey != null ? _usersDataDifferentExamsMap[examKey] : [])!;
  return _usersData;
}

List<CustomBoxAndWhiskerChartData> updateUsersDataOnDifferentCourseExamSelectionBoxAndWhiskerChart(String? examKey) {
  _usersData2 = (examKey != null ? _usersDataDifferentExamsMapBoxWhisker[examKey] : [])!;
  return _usersData2;
}

List<CustomBarChartData> updateUsersDataOnDifferentMetricSelection(String? metricKey) {
  _usersData = (metricKey != null ? _usersDataDifferentMetricsMap[metricKey] : [])!;
  return _usersData;
}

List<CustomBarChartData> updateUserDataOnDifferentMetricSelection(String? metricKey) {
  _usersData = (metricKey != null ? userDifferentDataMap[metricKey] : [])!;
  return _usersData;
}

Map<String, List<CustomBarChartData>> userDifferentDataMap = {
  'avgScore': userDataAllCoursesAverage,
  'maxScore': userDataAllCoursesMaximum,
  'minScore': userDataAllCoursesMinimum,
};
