import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

Widget buildSecondaryHeader({required String title}) {
  print('hjv');
  return Container(
    // margin: const EdgeInsets.fromLTRB(100, 30, 100, 0),
    child: ConstrainedBox(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 16,
                color: ThemeConfig.tertiaryTextColor1,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
