import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/admin_models/exam_deadline.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpcomingDeadlines extends StatefulWidget {
  UpcomingDeadlines({
    super.key,
    required this.examDeadlines,
  });

  List<ExamDeadline> examDeadlines;

  @override
  State<UpcomingDeadlines> createState() => _UpcomingDeadlinesState();
}

class _UpcomingDeadlinesState extends State<UpcomingDeadlines> {
  @override
  Widget build(BuildContext context) {
    print(widget.examDeadlines);
    final loggedInState = context.watch<LoggedInState>();

    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      body: Column(
        children: [
          buildSectionHeader(title: AppLocalizations.of(context)!.upcomingDeadlines),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ExamDeadlinesTable(
              examDeadlines: widget.examDeadlines,
            ),
          ),
        ],
      ),
    );
  }
}

class ExamDeadlinesTable extends StatelessWidget {
  final List<ExamDeadline> examDeadlines;

  const ExamDeadlinesTable({Key? key, required this.examDeadlines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.fromLTRB(80, 12, 80, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildHeaderCell(title: 'Exam Name', flexValue: 3),
                buildHeaderCell(title: 'Course Name', flexValue: 3),
                buildHeaderCell(title: 'Language', flexValue: 2),
                buildHeaderCell(title: 'Users In Compliance', flexValue: 2),
                buildHeaderCell(title: 'Deadline', flexValue: 2),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: examDeadlines.length,
              itemBuilder: (context, index) {
                return buildExamDeadlineRow(context, examDeadlines[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderCell({required String title, required int flexValue}) {
    return Expanded(
      flex: flexValue,
      child: Text('$title',
          style: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
            color: ThemeConfig.tertiaryTextColor1,
          )),
    );
  }

  Widget buildExamDeadlineRow(BuildContext context, ExamDeadline examDeadline) {
    DateTime parsedDateTime = DateTime.parse(examDeadline.nearestCompletionDeadline);
    var r = DateFormat.yMMMMEEEEd('en_US').format(parsedDateTime);
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDateTime);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: HoverableSectionContainer(
        onHover: (bool) {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildDataCell(title: examDeadline.examTitle, flexValue: 3),
            buildDataCell(title: examDeadline.courseTitle, flexValue: 3),
            buildDataCell(title: examDeadline.contentLanguage, flexValue: 2),
            buildDataCell(
                title:
                    '${examDeadline.usersPassed.toString()}/${examDeadline.allUsersCount.toString()}  users in compliance',
                flexValue: 2),
            buildDataCell(title: examDeadline.nearestCompletionDeadline, flexValue: 2),
          ],
        ),
      ),
    );
  }

  Expanded buildDataCell({required String title, required int flexValue}) {
    return Expanded(
      flex: flexValue,
      child: Text(
        title,
        style: TextStyle(
          color: ThemeConfig.primaryTextColor,
        ),
      ),
    );
  }
}
