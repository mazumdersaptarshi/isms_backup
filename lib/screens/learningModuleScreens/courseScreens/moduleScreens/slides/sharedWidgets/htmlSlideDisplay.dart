// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HTMLSlideDisplay extends StatelessWidget {
  const HTMLSlideDisplay({super.key, required this.htmlString});
  final String htmlString;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: HtmlWidget(
        '''
            $htmlString
            ''',
      ),
    );
  }
}
