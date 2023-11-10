import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../themes/common_theme.dart';

class CourseTile extends StatelessWidget {
  final int index;
  final String title;
  Function? onPressed;
  int modulesCount;
  // double tileHeight;
  double tileWidth;
  dynamic? modulesCompleted;
  dynamic? latestModule;
  Map<String, dynamic> courseData;
  CourseTile(
      {required this.index,
      required this.title,
      required this.onPressed,
      required this.modulesCount,
      required this.courseData,
      required this.tileWidth,
      this.modulesCompleted,
      this.latestModule});

  @override
  Widget build(BuildContext context) {
    int imageIndex = index % 4;
    double imgWebWidth = 120;
    double imgWebHeight = 120;
    if (tileWidth > 300) imgWebWidth = 100;
    // if (tileHeight > 300) imgWebHeight = 500;
    double tileHeight = 200;
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/images/courseIcons/courseIcon${imageIndex}.svg",
                      // height: kIsWeb ? imgWebHeight : 150,
                      // width: kIsWeb ? imgWebWidth : 150,
                      // fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Colors.grey.shade200, width: 2)),
                        color: Colors.grey.shade50,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title,
                              style: commonTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Container(width: 100, child: Divider()),
                          SizedBox(height: 5),
                          RichText(
                              text: TextSpan(
                                  // text: " ${modulesCount}",
                                  text: "${latestModule}",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Poppins'))),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(right: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(20),
                                  minHeight: 15,
                                  backgroundColor: Colors.grey.shade100,
                                  color: primaryColor.shade100,
                                  value: courseData["courseCompPercent"] / 100,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Overall Progress ${courseData['courseCompPercent']}%',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontFamily: 'Poppins'),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
