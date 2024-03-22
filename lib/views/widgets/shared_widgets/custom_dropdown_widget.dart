import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

// Assume these functions return your theme's colors.

// The 'T' here declares that CustomDropdown is a generic class.
class CustomDropdownWidget<T> extends StatelessWidget {
  final String? hintText;
  final T? value;
  final List<T>? items;
  final ValueChanged<T?>? onChanged;
  final String? label;

  const CustomDropdownWidget({
    Key? key,
    this.hintText,
    this.value,
    this.items,
    this.onChanged,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 12,
                color: getTertiaryTextColor1(), // Adjust the color to match your theme
              ),
            ),
          ),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: getTertiaryColor1()), // Border color
            borderRadius: BorderRadius.circular(5), // Border radius
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200, minWidth: 150),
            child: DropdownButtonHideUnderline(
              child: Theme(
                data: ThemeData(
                  hoverColor: getPrimaryColorShade(50),
                  focusColor: getPrimaryColorShade(100),
                ),
                child: DropdownButton<T>(
                  borderRadius: BorderRadius.circular(5),
                  hint: Text(
                    hintText ?? '',
                    style: TextStyle(
                      color: getTertiaryTextColor1(), // Adjust the color to fit your theme
                    ),
                  ),
                  value: value,
                  onChanged: onChanged,
                  items: items?.map((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: TextStyle(color: getTertiaryTextColor1()), // Text color inside the dropdown
                      ),
                    );
                  }).toList(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: getTertiaryTextColor1()),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
