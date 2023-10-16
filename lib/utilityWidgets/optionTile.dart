import 'package:flutter/material.dart';

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
            controller: widget.controller,
            onChanged: (value) {
              setState(() {
                widget.optionName = value;
                widget.isOptionSaved = false;
              });
            },
          )),
          if (widget.isOptionSaved == false)
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.getTextValue(widget.optionName, widget.isChecked);
                    widget.isOptionSaved = true;
                  });
                },
                child: Text("Save option"))
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
