import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class CustomFlipCard extends StatefulWidget {
  @override
  _CustomFlipCardState createState() => _CustomFlipCardState();
}

class _CustomFlipCardState extends State<CustomFlipCard> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      direction: FlipDirection.HORIZONTAL,
      onFlipDone: (isFlipped) {
        setState(() {
          _isFlipped = isFlipped;
        });
      },
      front: _buildSide(
        text: 'example',
        color: Colors.black,
      ),
      back: _buildSide(
        text: 'text',
        color: Colors.black,
        addBorder: true,
      ),
    );
  }

  Widget _buildSide(
      {required String text, required Color color, bool addBorder = false}) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(4, 4),
          ),
        ],
        border: addBorder && _isFlipped
            ? Border.all(color: Colors.blue, width: 3.0)
            : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: color),
        ),
      ),
    );
  }
}
