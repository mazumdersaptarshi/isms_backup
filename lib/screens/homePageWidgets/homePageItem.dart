import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/common_theme.dart';

class HomePageItem extends StatelessWidget {
  HomePageItem({super.key, required this.onTap, required this.title});
  Function onTap;
  String title;
  int randIndex = Random().nextInt(5);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      constraints: const BoxConstraints(minWidth: 300),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/courseIcons/courseIcon$randIndex.svg",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 20),
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
