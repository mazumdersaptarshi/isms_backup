import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/course/flip_card.dart' as flip_card_model;

class CustomFlipCard extends StatelessWidget {
  final flip_card_model.FlipCard content;
  final dynamic Function(dynamic selectedValue) onCardFlipped;

  // final String imagePath;

  const CustomFlipCard({Key? key, required this.content, required this.onCardFlipped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      front: _buildFront(),
      back: _buildBack(),
      // Dynamic anonymous function used to expose the flipped card's ID to the caller scope
      onFlip: () => onCardFlipped(content.flipCardId),
    );
  }

  Widget _buildFront() {
    return Container(
      height: 300,
      width: 200,
      decoration: ThemeConfig.flipCardBoxDecorationBack,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   imagePath,
              //   width: 180,
              //   height: 180,
              // ),
              // const SizedBox(height: 20),
              Text(
                content.flipCardFront,
                // style: Format.flipCardText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      height: 300,
      width: 200,
      decoration: ThemeConfig.flipCardBoxDecorationBack,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            content.flipCardBack,
            // style: Format.flipCardText,
          ),
        ),
      ),
    );
  }
}
