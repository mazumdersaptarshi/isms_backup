// page_title.dart

import 'package:flutter/material.dart';
import 'format.dart';

class PageTitle extends StatelessWidget {
  final String title;

  PageTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Text(
            title,
            style: Format.pageTitle,
            textAlign: TextAlign.center, // 中央寄せに修正
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
