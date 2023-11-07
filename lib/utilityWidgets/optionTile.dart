// ignore_for_file: file_names

import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  const OptionTile({
    super.key,
    required this.controller,
    required this.getTextValue,
    required this.optionCreationProvider,
  });
  final Function(String, bool) getTextValue;
  final TextEditingController controller;
  final OptionCreationProvider optionCreationProvider;
  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool isChecked;
  String optionName = "";
  bool isOptionSaved = true;
  
  @override
  void initState() {
    super.initState();
    if (mounted) {
      isChecked = widget.optionCreationProvider.isOptionChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    isChecked = widget.optionCreationProvider.isOptionChecked;
    debugPrint("ISOPTIONCHECKED ${widget.optionCreationProvider.isOptionChecked}");
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                  isOptionSaved = false;
                  widget.optionCreationProvider.updateIsOptionChecked(value);
                });
              }),
          Expanded(
              child: TextFormField(
            controller: widget.controller,
            onChanged: (value) {
              setState(() {
                optionName = value;
                isOptionSaved = false;
              });
            },
          )),
          if (isOptionSaved == false)
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.getTextValue(
                        widget.controller.text, isChecked);
                    isOptionSaved = true;
                  });
                },
                child: const Text("Save option"))
        ],
      ),
    );
  }
}

class OptionCreationProvider with ChangeNotifier {
  bool isOptionChecked = false;
  updateIsOptionChecked(bool val) {
    isOptionChecked = val;
    notifyListeners();
  }
}
