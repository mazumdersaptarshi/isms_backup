import 'package:flutter/material.dart';

import '../../../../themes/common_theme.dart';

class CourseTile extends StatelessWidget {
  final int index;
  final String title;
  final Function? onPressed;
  final int modulesCount;
  const CourseTile(
      {super.key,
      required this.index,
      required this.title,
      required this.onPressed,
      required this.modulesCount});

  @override
  Widget build(BuildContext context) {
    int imageIndex = index % 4;
    return SizedBox(
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/BookIcon$imageIndex.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                      // Image.network(
                      //   "https://www.shutterstock.com/image-vector/coding-vector-illustration-600w-687456625.jpg",
                      //   height: 120,
                      //   width: 120,
                      //   fit: BoxFit.cover,
                      // ),
                      const SizedBox(width: 20),
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
                      RichText(
                          text: TextSpan(
                              text: "Modules Count :",
                              style: customTheme.textTheme.labelMedium!
                                  .copyWith(color: Colors.grey, fontSize: 14),
                              children: [
                            TextSpan(
                                text: " $modulesCount",
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
