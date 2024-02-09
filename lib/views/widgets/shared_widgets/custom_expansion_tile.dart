import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget titleWidget;
  final dynamic contentWidget;
  final int? index;
  final int? length;
  final bool? hasHoverBorder;

  const CustomExpansionTile({
    Key? key,
    required this.titleWidget,
    required this.contentWidget,
    this.index,
    this.length,
    this.hasHoverBorder,
  }) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  bool _isHovered = false;

  BorderRadius _determineBorderRadius() {
    if (widget.index == 0) {
      return BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20));
    } else if (widget.index == (widget.length ?? 1) - 1) {
      return BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20));
    }
    return BorderRadius.circular(1);
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      border: widget.hasHoverBorder ?? false
          ? Border.all(
              color: _isHovered || _isExpanded ? getPrimaryColorShade(300)! : Colors.transparent,
              width: 1,
            )
          : null,
      borderRadius: _determineBorderRadius(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: _buildContainerDecoration(),
        child: ClipRRect(
          borderRadius: _determineBorderRadius(),
          child: Material(
            color: Colors.transparent,
            child: _buildExpansionTile(),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile() {
    return Theme(
      data: ThemeData(
        fontFamily: fontFamily,
        splashColor: Colors.transparent,
        hoverColor: getPrimaryColorShade(50),
        highlightColor: getPrimaryColorShade(50),
        dividerColor: getPrimaryColorShade(50),
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: primary,
          // collapsedIconColor: primary,

          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
        ),
      ),
      child: ExpansionTile(
        title: AnimatedDefaultTextStyle(
          style: TextStyle(
            color: _isHovered || _isExpanded ? primary : Colors.black,
            fontFamily: fontFamily,
          ),
          duration: const Duration(milliseconds: 300),
          child: widget.titleWidget,
        ),
        children: widget.contentWidget is List<Widget> ? widget.contentWidget : [widget.contentWidget],
        onExpansionChanged: (bool expanded) => setState(() => _isExpanded = expanded),
      ),
    );
  }
}
