import 'package:flutter/material.dart';

import '../../../../themes/common_theme.dart';

class CourseTile extends StatelessWidget {
  final int index;
  final String title;
  final Function? onPressed;
  const CourseTile(
      {super.key, required this.index, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: GestureDetector(
        child: Card(
          surfaceTintColor: Colors.white,
          elevation: 4,
          shape: customCardShape,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    "https://www.shutterstock.com/image-vector/coding-vector-illustration-600w-687456625.jpg",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                          child: Text(title,
                              style: commonTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
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
