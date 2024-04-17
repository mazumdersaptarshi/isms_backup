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
  });

  String startDate;
  String userName;
  String examName;
  double value;
  String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$startDate',
              style: TextStyle(color: ThemeConfig.primaryTextColor),
            ),
          ),
          Expanded(
            child: Text(
              '$userName',
              style: TextStyle(color: ThemeConfig.primaryColor),
            ),
          ),
          Expanded(child: Text('$examName')),
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
          Expanded(child: Text('$score')),
        ],
      ),
    );
  }
}
