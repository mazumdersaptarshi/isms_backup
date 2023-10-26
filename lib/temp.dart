import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('CustomScrollView Example'),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('CustomScrollView Example'),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ExpansionTile(
                    title: Text('Item $index'),
                    children: <Widget>[
                      ListView.builder(
                        itemCount: 50, // Adjust the item count as needed
                        shrinkWrap:
                            true, // Allow the inner list to take up minimum space
                        physics:
                            ClampingScrollPhysics(), // Prevent inner list from scrolling
                        itemBuilder: (BuildContext context, int innerIndex) {
                          // Replace this with your custom item widget
                          return ListTile(
                            title: Text('Subitem $innerIndex'),
                          );
                        },
                      ),
                    ],
                  );
                },
                childCount: 20, // Change this count as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
