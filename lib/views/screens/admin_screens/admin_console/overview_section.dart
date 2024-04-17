import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/screens/admin_screens/admin_console/deadline_overview_widget.dart';
import 'package:isms/views/screens/admin_screens/admin_console/exam_attempt_overview_widget.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.fromLTRB(80, 30, 100, 0), // Margin for the whole container
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: HoverableSectionContainer(
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                // height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Deadlines',
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeConfig.primaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        DeadlineOverviewWidget(
                          day: '03',
                          month: 'April',
                          year: '2024',
                          courseTitle: 'Advanced Javascript Fundamentals',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DeadlineOverviewWidget(
                          day: '05',
                          month: 'June',
                          year: '2024',
                          courseTitle: 'Python Fundamentals',
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onHover: (bool) {},
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: HoverableSectionContainer(
              child: Container(
                // height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Exam Attempts',
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeConfig.primaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(children: [
                        ExamAttemptOverviewWidget(
                          startDate: '2024-04-17 14:13:11',
                          userName: 'Julia Cancio',
                          examName: 'Advanced Javascript Fundamentals Exam 1',
                          value: 0.88,
                          score: '88/100',
                        ),
                        ExamAttemptOverviewWidget(
                          startDate: '2024-03-15 12:12:11',
                          userName: 'Aidan Pope',
                          examName: 'Advanced Javascript Fundamentals Exam 1',
                          value: 0.76,
                          score: '76/100',
                        ),
                        ExamAttemptOverviewWidget(
                          startDate: '2024-03-11 13:42:58',
                          userName: 'Shigeru Kyotani',
                          examName: 'Python Fundamentaals Exam 1',
                          value: 0.80,
                          score: '80/100',
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Container(
                                padding: EdgeInsets.all(8),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Text(
                                          'See More',
                                          style: TextStyle(
                                            color: ThemeConfig.getPrimaryColorShade(600),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: ThemeConfig.getPrimaryColorShade(600),
                                          size: 16,
                                        ),
                                      ],
                                    ))),
                          ],
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              onHover: (bool) {},
            ),
          ),
        ],
      ),
    );
  }
}
