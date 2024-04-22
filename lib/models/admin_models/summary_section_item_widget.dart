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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.icon!,
          SizedBox(
            height: 10,
          ),
          Text(
            widget.title,
            style: TextStyle(fontSize: 18, color: ThemeConfig.primaryTextColor),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            widget.value,
            style: TextStyle(
              fontSize: 24, color: ThemeConfig.primaryColor,
              // fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
