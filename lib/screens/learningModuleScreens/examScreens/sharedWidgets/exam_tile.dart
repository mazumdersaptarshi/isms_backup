import 'package:flutter/material.dart';

import '../../../../themes/common_theme.dart';

class ExamTile extends StatelessWidget {
  final String title;
  final int questionCount;
  final Function? onPressed;
  const ExamTile(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.questionCount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: GestureDetector(
        child: Card(
          surfaceTintColor: white,
          elevation: 4,
          shadowColor: secondaryColor,
          shape: customCardShape,
          color: white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                          child: Text(title,
                              style: commonTextStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: black))),
                    ],
                  ),
                ),
                const Icon(
                  Icons.question_answer,
                  color: secondaryColor,
                  size: 15,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Total questions: ${questionCount.toString()}",
                  style: const TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                      fontWeight: FontWeight.bold),
                ),
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
