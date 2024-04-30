import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget titleWidget;
  final dynamic contentWidget;
  final int? index;
  final int? length;
  final bool? hasHoverBorder;
  final Color? expansionTileCardColor;
  final Future<void> Function()? onDataFetch;

  CustomExpansionTile({
    Key? key,
    required this.titleWidget,
    required this.contentWidget,
    this.index,
    this.length,
    this.hasHoverBorder,
    this.onDataFetch,
    this.expansionTileCardColor,
  }) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  bool _isHovered = false;

  // BorderRadius _determineBorderRadius() {
  //   if (widget.index == 0) {
  //     return BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20));
  //   } else if (widget.index == (widget.length ?? 1) - 1) {
  //     return BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20));
  //   }
  //   return BorderRadius.circular(1);
  // }

  // BoxDecoration _buildContainerDecoration() {
  //   return BoxDecoration(
  //     border: widget.hasHoverBorder ?? false
  //         ? Border.all(
  //             color: _isHovered || _isExpanded ? ThemeConfig.getPrimaryColorShade(300)! : Colors.transparent,
  //             width: 1,
  //           )
  //         : null,
  //     borderRadius: _determineBorderRadius(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: _buildExpansionTile(),
    );
  }

  Widget _buildExpansionTile() {
    return Container(
      decoration: BoxDecoration(
        color: widget.expansionTileCardColor ?? ThemeConfig.primaryCardColor,
        border: Border.all(
          color: _isHovered ? ThemeConfig.hoverBorderColor1! : Colors.transparent, // Blue border on hover
          width: 2, // Border width
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: ThemeConfig.hoverShadowColor!.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Making unnecessary built-in dividers transparent
        ),
        child: ExpansionTile(
          title: AnimatedDefaultTextStyle(
            style: TextStyle(
              color: _isHovered || _isExpanded ? ThemeConfig.secondaryTextColor : ThemeConfig.primaryTextColor,
              fontFamily: fontFamily,
            ),
            duration: const Duration(milliseconds: 300),
            child: widget.titleWidget,
          ),
          children: widget.contentWidget is List<Widget> ? widget.contentWidget : [widget.contentWidget],
          onExpansionChanged: (bool expanded) async {
            if (widget.onDataFetch != null) {
              await widget.onDataFetch!();
            }
            setState(() => _isExpanded = expanded);
          },
        ),
      ),
    );
  }
}
