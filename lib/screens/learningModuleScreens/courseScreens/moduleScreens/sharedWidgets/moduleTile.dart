import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/utilityWidgets/modulesList/moduleExpandedItem.dart';

class ModuleTile extends StatelessWidget {
  Course course;
  Module module;
  bool isModuleStarted;
  bool isModuleCompleted;

  ModuleTile(
      {super.key,
      required this.course,
      required this.module,
      this.isModuleStarted = false,
      this.isModuleCompleted = false});

  @override
  Widget build(BuildContext context) {
    int imageIndex = (module.index ?? 0) % 4;
    return Container(
      height: 150,
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
                          SizedBox(width: 20),
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
