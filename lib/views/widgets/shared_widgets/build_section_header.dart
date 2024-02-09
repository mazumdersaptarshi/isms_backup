import 'package:flutter/material.dart';

Widget buildSectionHeader({required String title}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(150, 30, 150, 0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 30,
        color: Colors.grey.shade600,
      ),
    ),
  );
}
