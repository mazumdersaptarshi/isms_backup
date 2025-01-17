// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'htmlSlideDisplay.dart';

class SlidesContentWidget extends StatelessWidget {
  const SlidesContentWidget(
      {super.key,
      required this.pageController,
      required this.cardItems,
      required this.currentIndex});
  final PageController pageController;
  final List<Map<String, dynamic>> cardItems;
  final int currentIndex;
  final isWeb = kIsWeb;
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: PageView(
                controller: pageController,
                children: cardItems.map((item) {
                  print('iohoiooih:${item['title'].length}');
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: 400,
                      child: ListView(
                        children: [
                          (item['title'].length > 0 &&
                                  item['title'] != null &&
                                  item['title'] != " ")
                              ? Text(
                                  '${item['title']}',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )
                              : SizedBox(
                                  height: 0.1,
                                ),
                          const SizedBox(height: 20),
                          (item['title'].length > 0 &&
                                  item['title'] != null &&
                                  item['title'] != " ")
                              ? const Divider(
                                  height: 2,
                                  color: Colors.grey,
                                  thickness: 2,
                                )
                              : SizedBox(
                                  height: 0.1,
                                ),
                          const SizedBox(height: 20),
                          HTMLSlideDisplay(htmlString: item['text'])
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (isWeb) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_left,
                      size: 30,
                    ),
                    onPressed: () {
                      if (currentIndex > 0) {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_right,
                      size: 30,
                    ),
                    onPressed: () {
                      if (currentIndex < cardItems.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              alignment: Alignment.bottomCenter,
              child: Text(
                'Slide ${currentIndex + 1} of ${cardItems.length}',
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
