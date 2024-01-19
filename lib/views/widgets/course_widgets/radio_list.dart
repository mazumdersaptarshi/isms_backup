import 'package:flutter/material.dart';

import 'package:isms/models/course/answer.dart';

class RadioList extends StatefulWidget {
  const RadioList({Key? key, required this.values, required this.onItemSelected}) : super(key: key);

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
    return Expanded(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildList(context),
    ));
  }

  _buildList(BuildContext context) {
    List<Widget> radioButtons = [];
    for (Answer answer in widget.values) {
      radioButtons.add(
        Flexible(
          fit: FlexFit.loose,
          child: RadioListTile<Answer>(
            title: Text(
              answer.answerText,
              // When an answer is selected, text colour is the same as `fillColor` for the radio button,
              // inherited from the app theme (`Theme.of(context).radioTheme.fillColor`).
              // This cannot be decoupled so override the text colour at this level to standardise the behaviour for
              // text displayed in both `RadioListTile`s and `CheckboxListTile`s.
              style: const TextStyle(color: Colors.black),
            ),
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
