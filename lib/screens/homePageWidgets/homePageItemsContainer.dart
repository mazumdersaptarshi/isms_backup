// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/themes/common_theme.dart';

class HomePageItemsContainer extends StatelessWidget {
  const HomePageItemsContainer({super.key, this.homePageItems});
  final List<Widget>? homePageItems;
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > HOME_PAGE_WIDGETS_COLLAPSE_WIDTH
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(

                  // color: Color.fromARGB(10, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(vertical: 10),
              // margin: EdgeInsets.only(
              //     left: MediaQuery.of(context).size.width * 0.1),
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
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: homePageItems!,
              ),
            ),
          );
  }
}
