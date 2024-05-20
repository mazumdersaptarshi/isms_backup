import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

class HoverableSectionContainer extends StatefulWidget {
  final Widget child;
  final Function(bool) onHover;
  Color? cardColor;

  HoverableSectionContainer({Key? key, required this.child, required this.onHover, this.cardColor}) : super(key: key);

  @override
  _HoverableSectionContainerState createState() => _HoverableSectionContainerState();
}

class _HoverableSectionContainerState extends State<HoverableSectionContainer> {
  bool _isHovered = false;

  void _onHover(PointerEvent details) {
    setState(() {
      _isHovered = true;
    });
    // widget.onHover(true);
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovered = false;
    });
    // widget.onHover(false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
        decoration: BoxDecoration(
          border: Border.all(color: _isHovered ? ThemeConfig.hoverBorderColor1! : Colors.transparent, width: 2
              // isHoveringMap[index] == true ? primary! : Colors.grey.shade200,
              ),
          borderRadius: BorderRadius.circular(6),
          color: widget.cardColor ?? ThemeConfig.primaryCardColor,
          boxShadow: [
            BoxShadow(
              color: ThemeConfig.hoverShadowColor!.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
