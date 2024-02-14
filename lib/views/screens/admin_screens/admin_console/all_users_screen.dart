import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/admin_management/users_analytics.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/charts/bar_charts/individual_bar.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/custom_data_table.dart';
import 'package:isms/views/widgets/shared_widgets/bar_graph_widget.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_expansion_tile.dart';
import 'package:isms/views/widgets/shared_widgets/testing/price_point.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late AdminState adminState;

  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    Map _allUsers = {};

    List _getAllUsers() {
      _allUsers = UsersAnalytics.getAllUsersList(allUsersData: adminState.getAllUsersData);
      // print(_allUsers);
      var usersList = _allUsers.entries.toList();

      return usersList;
    }

    //Making CUstom Data

    List<IndividualBar> _barData = [];

    for (int index = 0; index < usersData.length; index++) {
      _barData.add(IndividualBar(x: index, y: usersData[index].y));
    }

    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: PlatformCheck.topNavBarWidget(context, loggedInState),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionHeader(title: 'All Users'),
          const SizedBox(height: 20),
          CustomDataTable(usersList: _getAllUsers()),
          Expanded(
            child: CustomBarChart(
              barData: _barData,
              barChartValuesData: usersData,
            ),
          ),
        ],
      ),
    );
  }
}
