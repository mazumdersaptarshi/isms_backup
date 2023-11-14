import 'package:flutter/material.dart';

import '../../../../../models/course.dart';
import '../../../../../models/module.dart';

class ModuleTileWidget extends StatelessWidget {
  const ModuleTileWidget(
      {super.key, required this.course,
      required this.module,
      this.isModuleStarted = false,
      this.isModuleCompleted = false});
  final Course course;
  final Module module;
  final bool isModuleStarted;
  final bool isModuleCompleted;
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(module.title)]);
  }
}
