import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_data.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/admin_management/users_analytics.dart';

class UsersAnalyticsStatsScreen extends StatefulWidget {
  const UsersAnalyticsStatsScreen({super.key});

  @override
  State<UsersAnalyticsStatsScreen> createState() => _UsersAnalyticsStatsScreenState();
}

class _UsersAnalyticsStatsScreenState extends State<UsersAnalyticsStatsScreen> {
  late AdminState adminState;

  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  @override
  Widget build(BuildContext context) {
    // return Text(adminState.getAllUsersData().toString());
    return Text('${UsersAnalytics.buildDataForGraph(
      allUsersData: adminState.getAllUsersData,
      allCoursesData: adminState.getAllFetchedCourses,
      allExamsData: adminState.getAllFetchedExams,
    )}');
  }
}
