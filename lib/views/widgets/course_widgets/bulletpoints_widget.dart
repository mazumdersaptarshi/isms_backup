import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/screens/testing/test_ui_type1/themes.dart';

import '../../../controllers/theme_management/app_theme.dart'; // Adjust the import path to your themes file

class BulletPointsWidget extends StatelessWidget {
  // Define the bullet points directly inside the widget
  final List<String> points = [
    'Over 4 trillion paper documents in the US, growing at 22% per year.',
    'Nearly 75% of a typical worker’s time is spent searching for and filing paper-based information.',
    '95% of corporate information exists on paper.',
    '75% of all documents get lost; 3% of the remainder are misfiled.',
    'Companies spend 20 in labor to file a document; 120 in labor to find a misfiled document; 220 in labor to recreate a lost document.',
  ];

  BulletPointsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildBulletPoints(),
    );
  }

  List<Widget> _buildBulletPoints() {
    return points
        .map((point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('•', style: ThemeConfig.bulletPointSymbolStyle),
                  SizedBox(width: 8), // Add space between the bullet and the text
                  Expanded(
                    child: Text(
                      point,
                      style: ThemeConfig.bulletPointTextStyle,
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
