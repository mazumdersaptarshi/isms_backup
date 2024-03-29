import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

// The 'T' here declares that CustomDropdown is a generic class.
class CustomDropdownWidgetOld<T> extends StatelessWidget {
  final String? hintText;
  final T? value;
  final List<T>? items;
  final ValueChanged<T?>? onChanged;
  final String? label;

  const CustomDropdownWidgetOld({
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
                color: ThemeConfig.tertiaryTextColor1!,
              ),
            ),
          ),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: ThemeConfig.tertiaryColor1!), // Border color
            borderRadius: BorderRadius.circular(5), // Border radius
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200, minWidth: 150),
            child: DropdownButtonHideUnderline(
              child: Theme(
                data: ThemeData(
                  hoverColor: ThemeConfig.getPrimaryColorShade(50),
                  focusColor: ThemeConfig.getPrimaryColorShade(100),
                ),
                child: DropdownButton<T>(
                  borderRadius: BorderRadius.circular(5),
                  hint: Text(
                    hintText ?? '',
                    style: TextStyle(
                      color: ThemeConfig.tertiaryTextColor1!,
                    ),
                  ),
                  value: value,
                  onChanged: onChanged,
                  items: items?.map((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: TextStyle(color: ThemeConfig.tertiaryTextColor1!),
                      ),
                    );
                  }).toList(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: ThemeConfig.tertiaryTextColor1!),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
