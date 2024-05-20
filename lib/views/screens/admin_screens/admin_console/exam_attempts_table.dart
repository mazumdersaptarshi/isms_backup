import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/utilities/date_time_converter.dart';
import 'package:isms/views/widgets/shared_widgets/custom_linear_progress_indicator.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';

class ExamAttemptsTable extends StatelessWidget {
  final List<ExamAttemptWidget> examAttempts;

  ExamAttemptsTable({super.key, required this.examAttempts});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.fromLTRB(80, 12, 80, 0),
      child: Column(
        children: [
          // Header row with column names
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Start Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primaryTextColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'User Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primaryTextColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Exam Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primaryTextColor,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Progress',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primaryTextColor,
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Score',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of data rows
          ...examAttempts,
        ],
      ),
    );
  }
}

class ExamAttemptWidget extends StatelessWidget {
  ExamAttemptWidget({
    super.key,
    required this.startDate,
    required this.userName,
    required this.examName,
    required this.value,
    required this.score,
    required this.passed,
  });

  String startDate;
  String userName;
  String examName;
  double value;
  String score;
  bool passed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: HoverableSectionContainer(
        onHover: (bool) {},
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: ThemeConfig.primaryTextColor,
                    size: 20,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    DateTimeConverter.convertToReadableDateTime(startDate),
                    // '$startDate',
                    style: TextStyle(color: ThemeConfig.tertiaryTextColor2),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                '$userName',
                style: TextStyle(color: ThemeConfig.secondaryTextColor),
              ),
            ),
            Expanded(
              child: Text(
                '$examName',
                style: TextStyle(color: ThemeConfig.tertiaryTextColor2),
              ),
            ),
            // SizedBox(width: 10),
            Expanded(
              child: Container(
                width: 150,
                height: 20,
                child: Center(
                  child: CustomLinearProgressIndicator(
                    value: value,
                    backgroundColor: ThemeConfig.tertiaryColor1!,
                    height: 14,
                    valueColor: ThemeConfig.primaryColor!,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Row(
                children: [
                  Text(
                    '$score',
                    style: TextStyle(color: ThemeConfig.tertiaryTextColor2),
                  ),
                  SizedBox(width: 4),
                  (passed)
                      ? Icon(Icons.check_circle_outline, color: ThemeConfig.primaryColor)
                      : Icon(Icons.warning_amber_rounded, color: Colors.orange)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
