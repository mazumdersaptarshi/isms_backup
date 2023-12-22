import 'package:flutter/material.dart';

import 'package:isms/models/course/answer.dart';

class RadioList extends StatefulWidget {
  const RadioList(
      {Key? key,
        required this.values,
        required this.onItemSelected})
      : super(key: key);

  final List<Answer> values;
  final dynamic Function(dynamic selectedValue) onItemSelected;

  @override
  State<RadioList> createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {
  dynamic _groupNewValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildList(context),
      ),
    );
  }

  _buildList(BuildContext context) {
    List<Widget> radioButtons = [];
    for (Answer answer in widget.values) {
      radioButtons.add(
        Expanded(
          flex: 1,
          child: RadioListTile<Answer>(
            title: Text(answer.answerText),
            value: answer,
            groupValue: _groupNewValue,
            onChanged: (selectedValue) {
              setState(() {
                _groupNewValue = selectedValue;
              });
              widget.onItemSelected(selectedValue);
            },
            selected: _groupNewValue == answer,
          ),
        ),
      );
    }

    return radioButtons;
  }
}