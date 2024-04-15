import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

class CustomDropdownButton extends StatefulWidget {
  final String? label;
  final String buttonText;
  final Function onButtonPressed; // Changed from 'Function' for better specificity and safety.
  String? selectedItemLabel;

  CustomDropdownButton({
    Key? key,
    this.label,
    required this.buttonText,
    required this.onButtonPressed,
    this.selectedItemLabel,
  }) : super(key: key);

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: Text(
              widget.selectedItemLabel != null ? widget.selectedItemLabel! : widget.label!,
              style: TextStyle(
                fontSize: 12,
                color: ThemeConfig.tertiaryTextColor1!, // Adjust this to use your actual color from theme.
              ),
            ),
          ),
        ElevatedButton(
          onPressed: () => widget.onButtonPressed(),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: ThemeConfig.primaryCardColor, // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Adjust the border radius as needed
              side: BorderSide(
                color: ThemeConfig.borderColor1!, // Border color
                width: 2.0, // Border width
              ),
            ),
          ),
          child: Container(
            // color: Colors.green,

            // width: 150,
            padding: EdgeInsets.symmetric(vertical: 13),
            child: IntrinsicWidth(
              stepWidth: 50,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400, minWidth: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Ensures the text and icon are spaced out over the entire button width.
                  children: [
                    Text(
                      widget.buttonText,
                      style: TextStyle(color: ThemeConfig.primaryColor),
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: ThemeConfig.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
