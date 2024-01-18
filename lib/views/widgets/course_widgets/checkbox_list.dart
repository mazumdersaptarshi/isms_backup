import 'package:flutter/material.dart';

import 'package:isms/models/course/answer.dart';

class CheckboxList extends StatefulWidget {
  const CheckboxList({Key? key, required this.values, required this.onItemSelected}) : super(key: key);

  final List<Answer> values;
  final dynamic Function(dynamic selectedValues) onItemSelected;

  @override
  State<CheckboxList> createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
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
    return Expanded(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildList(context),
    ));
  }

  _buildList(BuildContext context) {
    List<Widget> checkboxes = [];
    for (Answer answer in widget.values) {
      checkboxes.add(
        Flexible(
          fit: FlexFit.loose,
          child: CheckboxListTile(
            title: Text(answer.answerText),
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
      );
    }

    return checkboxes;
  }
}
