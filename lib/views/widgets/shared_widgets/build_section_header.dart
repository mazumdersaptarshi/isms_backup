import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/widgets/shared_widgets/search_bar_widget.dart';

Widget buildSectionHeader({
  required String title,
  Widget? actionWidget1,
  Widget? actionWidget2,
}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(100, 30, 100, 0),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            color: ThemeConfig.primaryTextColor,
            // color: Colors.grey.shade600,
          ),
        ),
        if (actionWidget1 != null) actionWidget1,
        Spacer(), // This pushes the action widget to the end of the row
        if (actionWidget2 != null) actionWidget2,
      ],
    ),
  );
}
