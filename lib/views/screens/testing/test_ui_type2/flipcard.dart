import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'format.dart';

class CustomFlipCard extends StatelessWidget {
  final String imagePath;
  final String frontText;
  final String backText;

  CustomFlipCard({
    required this.imagePath,
    required this.frontText,
    required this.backText,
  });

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      front: _buildFront(),
      back: _buildBack(),
    );
  }

  Widget _buildFront() {
    return Container(
      height: 300,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 180,
              height: 180,
            ),
            SizedBox(height: 20),
            Text(
              frontText,
              style: Format.flipCardText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      height: 300,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            backText,
            style: Format.flipCardText,
          ),
        ),
      ),
    );
  }
}
