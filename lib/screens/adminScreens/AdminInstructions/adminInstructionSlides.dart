// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../adminManagement/adminProvider.dart';

class AdminInstructionSlides extends StatefulWidget {
  const AdminInstructionSlides(
      {super.key,
      required this.adminProvider,
      required this.category,
      required this.subCategory});
  final String category;
  final String subCategory;
  final AdminProvider adminProvider;

  @override
  State<AdminInstructionSlides> createState() => _AdminInstructionSlidesState();
}

class _AdminInstructionSlidesState extends State<AdminInstructionSlides> {
  List<dynamic>? slides;
  final PageController _controller = PageController();

  Future<List?> fetchSlidesList(
      AdminProvider adminProvider, String category, String subCategory) async {
    var slides = await adminProvider.fetchAdminInstructionsFromFirestore(
        category, subCategory);
    debugPrint('slidessdcd: $slides');
    return slides;
  }

  @override
  void initState() {
    super.initState();
    fetchSlidesList(widget.adminProvider, widget.category, widget.subCategory)
        .then((value) {
      setState(() {
        slides = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: slides != null
            ? Column(
                children: [
                  Expanded(
                    child: SlideList(
                      slides: slides,
                      controller: _controller,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: const Text("Previous"),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: const Text("Next"),
                      )
                    ],
                  )
                ],
              )
            : const CircularProgressIndicator());
  }
}

class SlideList extends StatelessWidget {
  final List<dynamic>? slides;
  final PageController? controller;

  const SlideList({super.key, this.slides, this.controller});
  @override
  Widget build(BuildContext context) {
    slides?.forEach((element) {
      debugPrint('yyyhn: $element');
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
        return const SafeArea(
            child: Center(child: Text('No content currently available! >__<')));
      }
    } else {
      return const Text('No data available');
    }
  }
}

class SlideItem extends StatelessWidget {
  final String? title;
  final String? content;
  final Color? color;

  const SlideItem({super.key, this.title, this.color, this.content});

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
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              content ?? 'n/a',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
