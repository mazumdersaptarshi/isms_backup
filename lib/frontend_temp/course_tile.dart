import 'package:flutter/material.dart';

import '../themes/common_theme.dart';

class CourseTile extends StatelessWidget {
  final int index;
  final String title;
  Function? onPressed;
  CourseTile(
      {required this.index, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: customCardShape,
      color: primaryColor,
      child: ListTile(
        title: Text(title, style: commonTextStyle),
        trailing: Icon(Icons.arrow_forward_ios, color: secondaryColor),
        onTap: () {
          onPressed!();
        },
      ),
    );
  }
}
