// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/utilityWidgets/modulesList/moduleExpandedItem.dart';

class ModuleTile extends StatelessWidget {
  final Course course;
  final Module module;
  final bool isModuleStarted;
  final bool isModuleCompleted;

  const ModuleTile(
      {super.key,
      required this.course,
      required this.module,
      this.isModuleStarted = false,
      this.isModuleCompleted = false});

  @override
  Widget build(BuildContext context) {
    int imageIndex = (module.index ?? 0) % 4;
    return GestureDetector(
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 4,
        shape: customCardShape,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: module.title,
                          style: customTheme.textTheme.labelMedium!.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Icon(
                      isModuleCompleted
                          ? Icons.check_circle
                          : (isModuleStarted
                              ? Icons.circle
                              : Icons.unpublished),
                      color: isModuleCompleted
                          ? Colors.green
                          : Colors.orangeAccent,
                    )
                  ],
                ),
                const Divider(thickness: 1, color: Colors.grey),
                Expanded(
                    child: Text(
                  module.contentDescription,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            )),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleDetails(
              course: course,
              module: module,
              isModuleStarted: isModuleStarted,
            ),
          ),
        );
      },
    );
  }
}
