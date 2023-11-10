// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';
import 'package:isms/models/course.dart';
import 'package:isms/themes/common_theme.dart';

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
    int imageIndex = module.index % 4;
    return SizedBox(
      child: GestureDetector(
        child: Card(
          surfaceTintColor: Colors.white,
          elevation: 4,
          shape: customCardShape,
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(children: [
                Positioned(
                  // will be positioned in the top right of the container
                  top: 0,
                  left: 0,
                  child: Icon(
                    isModuleCompleted
                        ? Icons.check_circle
                        : (isModuleStarted ? Icons.circle : Icons.unpublished),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        "assets/images/moduleIcons/ModuleIcon${imageIndex + 1}.svg",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: module.title,
                                style: customTheme.textTheme.labelMedium!
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ])),
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
      ),
    );
  }
}
