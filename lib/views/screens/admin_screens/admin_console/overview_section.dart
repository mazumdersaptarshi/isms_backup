import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isms/controllers/language_management/app_localization_extension.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/admin_models/exam_attempt_overview.dart';
import 'package:isms/models/admin_models/exam_deadline.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/screens/admin_screens/admin_console/deadline_overview_widget.dart';
import 'package:isms/views/screens/admin_screens/admin_console/exam_attempt_overview_widget.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OverviewSection extends StatelessWidget {
  OverviewSection({
    super.key,
    required this.examDeadlines,
    required this.recentExamAttempts,
  });

  List<ExamDeadline> examDeadlines;
  List<ExamAttemptOverview> recentExamAttempts = [];

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width >= 1200;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: isWideScreen
          ? const EdgeInsets.fromLTRB(80, 30, 100, 0)
          : const EdgeInsets.fromLTRB(20, 30, 20, 0), // Margin for the whole container
      child: isWideScreen
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buildChildren(context, isWideScreen),
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildChildren(context, isWideScreen),
      ),
    );
  }

  List<Widget> buildChildren(BuildContext context, bool isWideScreen) {
    return [
      Flexible(
        fit: FlexFit.loose,
        child: HoverableSectionContainer(
          child: Container(
            // padding: EdgeInsets.only(bottom: 20),
            // height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.upcomingDeadlines,
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeConfig.primaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    // print(examDeadlines[index].nearestCompletionDeadline);
                    DateTime dateTime = DateTime.parse(examDeadlines[index].nearestCompletionDeadline);
                    int day = dateTime.day;
                    String monthName = DateFormat('MMMM').format(dateTime).toLowerCase();
                    int year = dateTime.year;
                    String passed = examDeadlines[index].usersPassed.toString();
                    String totalUsers = examDeadlines[index].allUsersCount.toString();
                    String usersCompliance = '${passed}/${totalUsers}';
                    return Column(
                      children: [
                        DeadlineOverviewWidget(
                          day: day.toString(),
                          month: '${AppLocalizations.of(context)!.getLocalizedString(monthName)}',
                          year: year.toString(),
                          courseTitle: examDeadlines[index].examTitle,
                          usersCompliance: usersCompliance,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      // padding: EdgeInsets.all(8),
                      child: TextButton(
                        onPressed: () => context.goNamed(NamedRoutes.upcomingDeadlines.name, extra: examDeadlines),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.viewAll,
                              style: TextStyle(
                                color: ThemeConfig.secondaryTextColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: ThemeConfig.secondaryTextColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onHover: (bool) {},
        ),
      ),
      SizedBox(
        height: isWideScreen ? 0 : 20,
        width: isWideScreen ? 20 : 0,
      ),
      Flexible(
        fit: FlexFit.loose,
        child: HoverableSectionContainer(
          child: Container(
            // height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.recentAttempts,
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeConfig.primaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          print(recentExamAttempts[index].date);
                          DateTime parsedDateTime = DateTime.parse(recentExamAttempts[index].date);
                          String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDateTime);

                          return ExamAttemptOverviewWidget(
                            startDate: '${formattedDateTime}',
                            userName: '${recentExamAttempts[index].givenName} ${recentExamAttempts[index].familyName}',
                            examName: '${recentExamAttempts[index].examTitle}',
                            value: (recentExamAttempts[index].score) / 100,
                            score: '${(recentExamAttempts[index].score)}/100',
                            passed: recentExamAttempts[index].passed,
                          );
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            // padding: EdgeInsets.all(8),
                            child: TextButton(
                              onPressed: () {
                                context.goNamed(NamedRoutes.examAttempts.name, extra: recentExamAttempts);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.seeMore,
                                    style: TextStyle(
                                      color: ThemeConfig.secondaryTextColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: ThemeConfig.secondaryTextColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onHover: (bool) {},
        ),
      ),
    ];
  }
}
