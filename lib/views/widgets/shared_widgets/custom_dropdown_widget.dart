import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/shared_widgets/custom_dropdown_item.dart';

// 'T' here will allow the dropdown to hold any type of value,
// but now within the structured format of CustomDropdownItem.
class CustomDropdownWidget<T> extends StatelessWidget {
  final String? hintText;
  final CustomDropdownItem<T>? value; // Changed to CustomDropdownItem<T>
  final List<CustomDropdownItem<T>>? items; // Changed to List<CustomDropdownItem<T>>
  final ValueChanged<CustomDropdownItem<T>?>? onChanged; // Changed to ValueChanged<CustomDropdownItem<T>?>
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
                color: ThemeConfig.tertiaryTextColor1!, // Adjust the color to match your theme
              ),
            ),
          ),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: ThemeConfig.borderColor1!, width: 2), // Border color
            borderRadius: BorderRadius.circular(5), // Border radius
          ),
          child: IntrinsicWidth(
            stepWidth: 50,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400, minWidth: 200),
              child: DropdownButtonHideUnderline(
                child: Theme(
                  data: ThemeData(
                    hoverColor: ThemeConfig.hoverFillColor2,
                    focusColor: ThemeConfig.hoverFillColor3,
                  ),
                  child: DropdownButton<CustomDropdownItem<T>>(
                    dropdownColor: ThemeConfig.primaryCardColor,
                    borderRadius: BorderRadius.circular(5),
                    hint: Text(
                      hintText ?? '',
                      style: TextStyle(
                        color: ThemeConfig.primaryColor!,
                        fontSize: 14,
                      ),
                    ),
                    value: value,
                    onChanged: onChanged,
                    items: items?.map((CustomDropdownItem<T> item) {
                      return DropdownMenuItem<CustomDropdownItem<T>>(
                        value: item,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            item.key, // Displaying 'key' instead of 'value.toString()'
                            style: TextStyle(
                                color: ThemeConfig.primaryColor!, fontSize: 14), // Text color inside the dropdown
                          ),
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down_rounded, color: ThemeConfig.tertiaryTextColor1!),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
