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
    return GestureDetector(
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 4,
        shape: customCardShape,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(module.title,
                          style: customTheme.textTheme.labelMedium!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary)),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          module.contentDescription,
                          maxLines: 3,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     ListView.builder(
                    //         shrinkWrap: true,
                    //         itemCount: 1,
                    //         itemBuilder: (BuildContext context, int index) {
                    //           print(module.slides);
                    //           return Text('${module.slides?[0].title}');
                    //         })
                    //   ],
                    // )
                  ],
                )),
              ],
            ),
          ],
        ),
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
