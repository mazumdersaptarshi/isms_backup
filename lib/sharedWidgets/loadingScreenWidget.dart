import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget loadingWidget() {
  return Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Loading",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 100,
          height: 100,
          child: Lottie.asset('assets/images/loading_animation.json'),
        ),
      ],
    ),
  );
}
