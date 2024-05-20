import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/admin_models/exam_attempt_overview.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/screens/admin_screens/admin_console/exam_attempts_table.dart';
import 'package:isms/views/screens/admin_screens/admin_console/upcoming_deadlines.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

import 'exam_attempt_overview_widget.dart';

class ExamAttempts extends StatefulWidget {
  ExamAttempts({
    super.key,
    required this.recentExamAttempts,
  });

  List<ExamAttemptOverview> recentExamAttempts = [];

  @override
  State<ExamAttempts> createState() => _ExamAttemptsState();
}

class _ExamAttemptsState extends State<ExamAttempts> {
  @override
  List<ExamAttemptWidget> createExamAttemptsList() {
    List<ExamAttemptWidget> examAttemptsList = [];
    widget.recentExamAttempts.forEach((element) {
      examAttemptsList.add(ExamAttemptWidget(
        startDate: '${element.date}',
        userName: '${element.givenName} ${element.familyName}',
        examName: '${element.examTitle}',
        value: (element.score) / 100,
        score: '${(element.score)}/100',
        passed: element.passed,
      ));
    });
    return examAttemptsList;
  }

  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      body: Column(
        children: [
          buildSectionHeader(title: AppLocalizations.of(context)!.examAttempts),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExamAttemptsTable(examAttempts: createExamAttemptsList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
