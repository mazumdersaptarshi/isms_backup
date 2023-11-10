import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../themes/common_theme.dart';
import '../../../../userManagement/loggedInState.dart';

class CourseTile extends StatelessWidget {
  final int index;
  final String title;
  Function? onPressed;
  int modulesCount;
  double tileHeight;
  double tileWidth;
  Map<String, dynamic> courseData;
  CourseTile(
      {required this.index,
      required this.title,
      required this.onPressed,
      required this.modulesCount,
      required this.courseData,
      required this.tileHeight,
      required this.tileWidth});

  @override
  Widget build(BuildContext context) {
    int imageIndex = index % 4;
    double imgWebWidth = 120;
    double imgWebHeight = 120;
    if (tileWidth > 300) imgWebWidth = 100;
    if (tileHeight > 300) imgWebHeight = 500;
    return GestureDetector(
      child: Card(
        surfaceTintColor: white,
        elevation: 4,
        shape: customCardShape,
        color: white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: tileHeight,
            width: tileWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    "assets/images/courseIcons/courseIcon${imageIndex}.svg",
                    // height: kIsWeb ? imgWebHeight : 150,
                    // width: kIsWeb ? imgWebWidth : 150,
                    // fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          style: commonTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Container(width: 100, child: Divider()),
                      SizedBox(height: 10),
                      RichText(
                          text: TextSpan(
                              text: "Modules :",
                              style: customTheme.textTheme.labelMedium!
                                  .copyWith(color: Colors.grey, fontSize: 14),
                              children: [
                            TextSpan(
                                text: " ${modulesCount!}",
                                style: customTheme.textTheme.labelMedium),
                          ])),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey.shade100,
                                color: primaryColor.shade100,
                                value: courseData["courseCompPercent"] / 100,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text(
                              "${courseData['courseCompPercent']}%",
                              style: customTheme.textTheme.labelMedium!
                                  .copyWith(fontSize: 10),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        onPressed!();
      },
    );
  }
}
