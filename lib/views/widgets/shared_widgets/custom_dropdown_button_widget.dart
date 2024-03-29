import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

class CustomDropdownButton extends StatelessWidget {
  final String label;
  final String buttonText;
  final Function onButtonPressed; // Changed from 'Function' for better specificity and safety.

  const CustomDropdownButton({
    Key? key,
    required this.label,
    required this.buttonText,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: ThemeConfig.tertiaryTextColor1!, // Adjust this to use your actual color from theme.
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => onButtonPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeConfig.primaryColor, // Background color
          ),
          child: Container(
            // color: Colors.green,

            width: 150,
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Ensures the text and icon are spaced out over the entire button width.
              children: [
                Text(buttonText),
                Icon(Icons.arrow_drop_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
