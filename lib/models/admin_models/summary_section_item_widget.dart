import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

class SummarySectionItemWidget extends StatefulWidget {
  String title;
  String value;
  Icon? icon;

  SummarySectionItemWidget({super.key, required this.title, required this.value, this.icon});

  @override
  State<SummarySectionItemWidget> createState() => _SummarySectionItemWidgetState();
}

class _SummarySectionItemWidgetState extends State<SummarySectionItemWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 900) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.icon != null) widget.icon!,
            SizedBox(
              height: 10,
            ),
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              widget.value,
              style: TextStyle(
                fontSize: 24, color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Row(
          children: [
            if (widget.icon != null) widget.icon!,
            SizedBox(
              width: 20,
            ),
            Text(
              widget.title + ":",
              style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.value,
              style: TextStyle(
                fontSize: 24, color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      );
    }
  }
}
