import 'package:flutter/material.dart';

import '../../../../themes/common_theme.dart';

class ExamTile extends StatelessWidget {
  final String title;
  final int questionCount;
  Function? onPressed;
  ExamTile({ required this.title, required this.onPressed,required this.questionCount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
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
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(title,
                              style: commonTextStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: black))),
                    ],
                  ),
                ),
                Icon(Icons.question_answer,color: secondaryColor,size: 15,),
                SizedBox(width: 8,),
                Text("Total questions: ${questionCount.toString()}",
                  style: TextStyle(fontSize: 12, color: secondaryColor,fontWeight: FontWeight.bold),
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
