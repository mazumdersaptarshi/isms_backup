import 'package:flutter/material.dart';
import 'package:isms/themes/common_theme.dart';

class OptionTile extends StatefulWidget {
  OptionTile({
    super.key,
    required this.controller,
    required this.getTextValue,
    required this.optionCreationProvider,
  });
  late bool isChecked;
  String optionName = "";
  bool isOptionSaved = true;
  Function(String, bool) getTextValue;
  TextEditingController controller;
  OptionCreationProvider optionCreationProvider;
  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (mounted) {
      widget.isChecked = widget.optionCreationProvider.isOptionChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.isChecked = widget.optionCreationProvider.isOptionChecked;
    print("ISOPTIONCHECKED ${widget.optionCreationProvider.isOptionChecked}");
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Checkbox(
              fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Fill color for the disabled state
                    }
                    if (states.contains(MaterialState.selected)) {
                      return secondaryColor; // Fill color when the checkbox is checked
                    }
                    return white; // Fill color when the checkbox is unchecked
                  }),
              value: widget.isChecked,
              onChanged: (value) {
                setState(() {
                  widget.isChecked = value!;
                  widget.isOptionSaved = false;
                  widget.optionCreationProvider.updateIsOptionChecked(value);
                });
              }),
          Expanded(
              child: TextFormField(
                decoration: customInputDecoration(hintText: 'Enter Option'),
                controller: widget.controller,
                onChanged: (value) {
                  setState(() {
                    widget.optionName = value;
                    widget.isOptionSaved = false;
                  });
                },
              )),
          if (widget.isOptionSaved == false)
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                      style: customElevatedButtonStyle(),
                      onPressed: () {
                        setState(() {
                          widget.getTextValue(
                              widget.controller.text, widget.isChecked);
                          widget.isOptionSaved = true;
                        });
                      },
                      child: Text(
                        "Save",
                        style: optionButtonText,
                      )),
                ),
              ],
            )
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