import 'package:flutter/material.dart';

class AdminInstructionSlides extends StatelessWidget {
  AdminInstructionSlides({super.key, this.slides});
  List<dynamic>? slides;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlideList(
      slides: slides,
    ));
  }
}

class SlideList extends StatelessWidget {
  List<dynamic>? slides;
  SlideList({this.slides});
  @override
  Widget build(BuildContext context) {
    slides?.forEach((element) {
      print('yyyhn: $element');
    });
    if (slides != []) {
      try {
        return PageView(
          // Control the scroll direction, default is horizontal
          scrollDirection: Axis.horizontal,

          children: [
            for (var slide in slides!)
              SlideItem(
                  title: slide['title'] ?? 'n/a',
                  content: slide['content'] ?? 'n/a',
                  color: Colors.red),
          ],
        );
      } catch (e) {
        return SafeArea(
            child: Center(child: Text('No content currently available! >__<')));
      }
    }
    else{
      return Text('No data available');
    }
  }
}

class SlideItem extends StatelessWidget {
  final String? title;
  final String? content;
  final Color? color;

  SlideItem({this.title, this.color, this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title!,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              content ?? 'n/a',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
