import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

import 'charts/custom_line_chart_all_users_widget.dart';
import 'hoverable_section_container.dart';

class UserActivityOverTime extends StatefulWidget {
  const UserActivityOverTime({
    super.key,
  });

  @override
  State<UserActivityOverTime> createState() => _UserActivityOverTimeState();
}

class _UserActivityOverTimeState extends State<UserActivityOverTime> {
  List<Color> coursesCompletedGradientColors = [
    ThemeConfig.primaryColor!,
    Colors.green,
  ];
  List<Color> coursesEnrolledGradientColors = [
    Colors.pink!,
    Colors.orange,
  ];
  List<Color> userActivityGradientColors = [
    Colors.green,
    Colors.orangeAccent,
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> metricTypeDataForLineChartWidget = {
      'All': {
        // 'data': coursesCompletedOverTimeData.map((data) => FlSpot(data.x, data.y)).toList(),
        // 'colors': coursesCompletedGradientColors,
      },
      'Courses Completed over Time': {
        'data': coursesCompletedOverTimeData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': coursesCompletedGradientColors,
      },
      'Active Users': {
        'data': activeUsersData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': userActivityGradientColors,
      },
      'Courses Enrolled over Time': {
        'data': coursesEnrolledOverTimeData.map((data) => FlSpot(data.x, data.y)).toList(),
        'colors': coursesEnrolledGradientColors,
      },
    };
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 800),
      child: HoverableSectionContainer(
        onHover: (bool) {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User activity over time',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            Divider(),
            SizedBox(
              height: 40,
            ),
            CustomLineChartAllUsersWidget(
              metricAndData: metricTypeDataForLineChartWidget,
            ),
          ],
        ),
      ),
    );
  }
}
