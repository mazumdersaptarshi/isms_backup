import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

Widget buildSectionHeader({required String title, Widget? actionWidget}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(100, 30, 100, 0),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 30,
            color: ThemeConfig.primaryTextColor,
            // color: Colors.grey.shade600,
          ),
        ),
        if (actionWidget != null)
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              actionWidget,
            ],
          )
      ],
    ),
  );
}
