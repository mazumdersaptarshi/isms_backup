import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/widgets/shared_widgets/custom_linear_progress_indicator.dart';

class ExamAttemptOverviewWidget extends StatelessWidget {
  ExamAttemptOverviewWidget({
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
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$startDate',
              style: TextStyle(color: ThemeConfig.tertiaryTextColor2),
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
              style: TextStyle(color: ThemeConfig.primaryTextColor),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              width: 150,
              height: 50,
              child: Center(
                child: CustomLinearProgressIndicator(
                    value: value,
                    backgroundColor: ThemeConfig.tertiaryColor1!,
                    height: 14,
                    valueColor: ThemeConfig.primaryColor!),
              ),
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Expanded(
              child: Row(
            children: [
              Text(
                '$score',
                style: TextStyle(color: ThemeConfig.primaryTextColor),
              ),
              SizedBox(
                width: 4,
              ),
              (passed)
                  ? Icon(Icons.check_circle_outline, color: ThemeConfig.primaryColor)
                  : Icon(Icons.warning_amber_rounded, color: Colors.orange)
            ],
          )),
        ],
      ),
    );
  }
}
