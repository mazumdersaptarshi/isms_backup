import 'package:flutter/material.dart';
import 'format.dart';

class VerticalSection extends StatelessWidget {
  final String header;
  final List<Widget> contentList;

  VerticalSection({
    required this.header,
    required this.contentList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header.isNotEmpty)
            Text(
              header,
              style: Format.headline,
            ),
          SizedBox(height: 10),
          ...contentList,
          SizedBox(height: 100)
        ],
      ),
    );
  }
}
