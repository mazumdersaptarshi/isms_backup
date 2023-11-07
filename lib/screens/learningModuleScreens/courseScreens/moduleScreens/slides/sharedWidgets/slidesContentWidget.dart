import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'htmlSlideDisplay.dart';

class SlidesContentWidget extends StatelessWidget {
  SlidesContentWidget(
      {super.key,
      required this.pageController,
      required this.cardItems,
      required this.currentIndex});
  PageController pageController;
  List<Map<String, dynamic>> cardItems;
  int currentIndex;
  final isWeb = kIsWeb;
  @override
  Widget build(BuildContext context) {
    print(cardItems);
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: isWeb ? MediaQuery.of(context).size.height - 260 : 500,
              child: PageView(
                controller: pageController,
                children: cardItems.map((item) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      height: 400,
                      child: ListView(
                        children: [
                          Text(
                            '${item['title']}:',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          SizedBox(height: 20),
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
                    icon: Icon(
                      Icons.arrow_left,
                      size: 30,
                    ),
                    onPressed: () {
                      if (currentIndex > 0) {
                        pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_right,
                      size: 30,
                    ),
                    onPressed: () {
                      if (currentIndex < cardItems.length - 1) {
                        pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              alignment: Alignment.bottomCenter,
              child: Text(
                'Slide ${currentIndex + 1} of ${cardItems.length}',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
