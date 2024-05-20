import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

import 'package:isms/models/course/answer.dart';

class CustomCheckboxList extends StatefulWidget {
  final List<Answer> values;
  final dynamic Function(dynamic selectedValues) onItemSelected;

  const CustomCheckboxList({Key? key, required this.values, required this.onItemSelected}) : super(key: key);

  @override
  State<CustomCheckboxList> createState() => _CustomCheckboxListState();
}

class _CustomCheckboxListState extends State<CustomCheckboxList> {
  late Map<String, bool> _checkboxAnswerState;

  @override
  void initState() {
    super.initState();
    _checkboxAnswerState = _initCheckboxStateTracking();
  }

  Map<String, bool> _initCheckboxStateTracking() {
    final Map<String, bool> answers = {};

    for (Answer value in widget.values) {
      answers[value.answerId] = false;
    }

    return answers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildList(context),
    );
  }

  _buildList(BuildContext context) {
    List<Widget> checkboxes = [];
    for (Answer answer in widget.values) {
      checkboxes.add(
        Flexible(
          fit: FlexFit.loose,
          child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: ThemeConfig.primaryTextColor, // Color for unselected state
            ),
            child: CheckboxListTile(
              title: Text(
                answer.answerText,
                style: TextStyle(
                  color: ThemeConfig.primaryTextColor,
                ),
              ),
              value: _checkboxAnswerState[answer.answerId],
              onChanged: (selectedValue) {
                setState(() {
                  _checkboxAnswerState[answer.answerId] = selectedValue ?? false;
                });
                widget.onItemSelected(_checkboxAnswerState);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ),
      );
    }

    return checkboxes;
  }
}
