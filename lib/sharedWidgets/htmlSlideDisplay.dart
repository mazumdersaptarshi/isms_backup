import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HTMLSlideDisplay extends StatelessWidget {
  HTMLSlideDisplay({required this.htmlString});
  String htmlString;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: HtmlWidget(
        '''
            ${htmlString}
            ''',
      ),
    );
  }
}
