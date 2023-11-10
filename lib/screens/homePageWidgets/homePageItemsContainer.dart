import 'package:flutter/material.dart';

class HomePageItemsContainer extends StatelessWidget {
  HomePageItemsContainer({super.key, this.homePageItems});
  List<Widget>? homePageItems;
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 800
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(10, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: homePageItems!.length,
                itemBuilder: (BuildContext contenxt, int index) {
                  return homePageItems![index];
                },
              ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: homePageItems!,
            ),
          );
  }
}
