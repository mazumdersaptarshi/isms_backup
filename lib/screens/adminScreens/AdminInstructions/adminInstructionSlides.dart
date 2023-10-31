import 'package:flutter/material.dart';

import '../../../adminManagement/adminProvider.dart';

class AdminInstructionSlides extends StatefulWidget {
  AdminInstructionSlides(
      {super.key,
      required this.adminProvider,
      required this.category,
      required this.subCategory});
  List<dynamic>? slides;
  String category;
  String subCategory;
  AdminProvider adminProvider;

  @override
  State<AdminInstructionSlides> createState() => _AdminInstructionSlidesState();
}

class _AdminInstructionSlidesState extends State<AdminInstructionSlides> {
  final PageController _controller = PageController();

  Future<List?> fetchSlidesList(
      AdminProvider adminProvider, String category, String subCategory) async {
    var slides = await adminProvider?.fetchAdminInstructionsFromFirestore(
        category!, subCategory);
    print('slidessdcd: ${slides}');
    return slides ?? [];
  }

  @override
  void initState() {
    super.initState();
    fetchSlidesList(widget.adminProvider!, widget.category!, widget.subCategory)
        .then((value) {
      setState(() {
        widget.slides = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.slides != null
            ? Column(
                children: [
                  Expanded(
                    child: SlideList(
                      slides: widget.slides,
                      controller: _controller,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _controller.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: Text("Previous"),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: Text("Next"),
                      )
                    ],
                  )
                ],
              )
            : const CircularProgressIndicator());
  }
}

class SlideList extends StatelessWidget {
  List<dynamic>? slides;
  final PageController? controller;

  SlideList({this.slides, this.controller});
  @override
  Widget build(BuildContext context) {
    slides?.forEach((element) {
      print('yyyhn: $element');
    });
    if (slides != null && slides!.isNotEmpty) {
      try {
        return PageView(
          // Control the scroll direction, default is horizontal
          controller: controller,

          scrollDirection: Axis.horizontal,

          children: [
            for (var slide in slides!)
              SlideItem(
                  title: slide['title'] ?? 'n/a',
                  content: slide['content'] ?? 'n/a',
                  color: Colors.deepPurpleAccent.shade200),
          ],
        );
      } catch (e) {
        return SafeArea(
            child: Center(child: Text('No content currently available! >__<')));
      }
    } else {
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
