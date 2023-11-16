// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget loadingWidget({Widget? textWidget}) {
  return Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        textWidget ??
            Text(
              "Loading",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
        Lottie.asset(
          'assets/images/loading_animation.json',
          width: 100,
          height: 100,
        ),
      ],
    ),
  );
}
