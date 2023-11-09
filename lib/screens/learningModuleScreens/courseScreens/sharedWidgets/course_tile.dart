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
  Map<String, dynamic> courseData;
  CourseTile({
    required this.index,
    required this.title,
    required this.onPressed,
    required this.modulesCount,
    required this.courseData,
  });

  @override
  Widget build(BuildContext context) {
    int imageIndex = index % 4;
    return Container(
      height: 150,
      child: GestureDetector(
        child: Card(
          surfaceTintColor: white,
          elevation: 4,
          shape: customCardShape,
          color: white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/courseIcons/courseIcon${imageIndex}.svg",
                        height: kIsWeb ? 180 : 150,
                        width: kIsWeb ? 180 : 150,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                Expanded(
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
                            TextSpan(
                                text: " - ${courseData["courseCompPercent"]!}%",
                                style: customTheme.textTheme.labelMedium)
                          ]))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          onPressed!();
        },
      ),
    );
  }
}
