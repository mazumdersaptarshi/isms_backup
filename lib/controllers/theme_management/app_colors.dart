import 'package:flutter/material.dart';

class AppColors {
  static final Color? primary = getPrimaryColorShade(700);

  static Color? getPrimaryColorShade(int shade) {
    return Colors.blue[shade];
  }
}
