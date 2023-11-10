// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/common_theme.dart';

class HomePageItem extends StatelessWidget {
  const HomePageItem({super.key, required this.onTap, required this.title});
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    int randIndex = Random().nextInt(5);
    return Container(
      height: 300,
      width: 300,
      constraints: BoxConstraints(minWidth: 300),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/courseIcons/courseIcon${randIndex}.svg",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: customTheme.textTheme.labelMedium!.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
