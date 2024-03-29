import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

class HoverableSectionContainer extends StatefulWidget {
  final Widget child;
  final Function(bool) onHover;

  const HoverableSectionContainer({Key? key, required this.child, required this.onHover}) : super(key: key);

  @override
  _HoverableSectionContainerState createState() => _HoverableSectionContainerState();
}

class _HoverableSectionContainerState extends State<HoverableSectionContainer> {
  bool _isHovered = false;

  void _onHover(PointerEvent details) {
    setState(() {
      _isHovered = true;
    });
    widget.onHover(true);
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovered = false;
    });
    widget.onHover(false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
        decoration: BoxDecoration(
          border: Border.all(color: ThemeConfig.borderColor1!, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: ThemeConfig.hoverShadowColor!,
                    spreadRadius: 3,
                    blurRadius: 40,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
