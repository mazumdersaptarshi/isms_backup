import 'package:flutter/material.dart';
import 'format.dart';

class HorizontalSection extends StatelessWidget {
  final bool isImageFirst;
  final String imagePath;
  final double imageFlex;
  final double contentFlex;
  final List<Widget> contentList;

  HorizontalSection({
    required this.isImageFirst,
    required this.imagePath,
    required this.imageFlex,
    required this.contentFlex,
    required this.contentList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isImageFirst) _buildImageSection(),
          Expanded(
            flex: contentFlex.toInt(),
            child: _buildTextSection(),
          ),
          if (!isImageFirst) _buildImageSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: imageFlex.toInt(),
      child: Image.asset(
        imagePath,
        width: 300,
        height: 300,
        alignment: isImageFirst ? Alignment.topCenter : Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildTextSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...contentList,
        SizedBox(height: 100),
      ],
    );
  }
}