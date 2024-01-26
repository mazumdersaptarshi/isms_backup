import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color valueColor;
  final double height;

  CustomLinearProgressIndicator({
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
    this.height = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(height / 2)), // Round corners for the entire bar
      child: Stack(
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
          ),
          FractionallySizedBox(
            widthFactor: value,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: valueColor,
                // border: Border.all(width: 10, color: Colors.white),
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(height / 2), // Rounded right border for the filled part
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
