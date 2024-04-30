import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/widgets/shared_widgets/build_secondary_header.dart';

class AdminPanelItemCard extends StatefulWidget {
  AdminPanelItemCard({
    super.key,
    required this.height,
    required this.width,
    required this.title,
  });

  double width;
  double height;
  String title;

  @override
  State<AdminPanelItemCard> createState() => _AdminPanelItemCardState();
}

class _AdminPanelItemCardState extends State<AdminPanelItemCard> {
  bool _isHovered = false;

  void _onHover(PointerEvent details) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildSecondaryHeader(title: widget.title),
        ),
        SizedBox(height: 10),
        MouseRegion(
          onHover: _onHover,
          onExit: _onExit,
          child: Container(
            decoration: BoxDecoration(
              color: ThemeConfig.primaryCardColor,
              border: Border.all(color: _isHovered ? ThemeConfig.hoverBorderColor1! : Colors.transparent, width: 2
                  // isHoveringMap[index] == true ? primary! : Colors.grey.shade200,
                  ),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              boxShadow: [
                BoxShadow(
                  color: ThemeConfig.hoverShadowColor!,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            height: widget.height,
            width: widget.width,
          ),
        ),
      ],
    );
  }
}
