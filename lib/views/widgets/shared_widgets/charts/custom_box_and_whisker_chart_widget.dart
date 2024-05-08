import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_scores_variation_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBoxAndWhiskerChartWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CustomBoxAndWhiskerChartWidget({Key? key, required this.allData}) : super(key: key);
  final List<CustomScoresVariationData> allData;

  @override
  _CustomBoxAndWhiskerChartWidgetState createState() => _CustomBoxAndWhiskerChartWidgetState();
}

class _CustomBoxAndWhiskerChartWidgetState extends State<CustomBoxAndWhiskerChartWidget> {
  late List<CustomScoresVariationData> data; // Data for current page
  late TooltipBehavior _tooltip;
  int currentPage = 0;
  static const int pageSize = 5;

  void setPageData() {
    final startIndex = currentPage * pageSize;
    final endIndex = min(startIndex + pageSize, widget.allData.length);
    data = widget.allData.sublist(startIndex, endIndex);
  }

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    setPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 800,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  color: ThemeConfig.primaryTextColor,
                  fontSize: 12,
                ),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 100,
                interval: 10,
                labelStyle: TextStyle(
                  color: ThemeConfig.primaryTextColor,
                  fontSize: 12,
                ),
              ),
              tooltipBehavior: _tooltip,
              series: <CartesianSeries<CustomScoresVariationData, String>>[
                BoxAndWhiskerSeries<CustomScoresVariationData, String>(
                  dataSource: data,
                  xValueMapper: (CustomScoresVariationData data, _) => data.x,
                  yValueMapper: (CustomScoresVariationData data, _) => data.y,
                  name: 'Users Scores',
                  color: ThemeConfig.getPrimaryColorShade(400),
                  borderWidth: 1,
                  borderColor: ThemeConfig.primaryTextColor,
                  gradient: LinearGradient(colors: [
                    ThemeConfig.getPrimaryColorShade(200)!,
                    ThemeConfig.getPrimaryColorShade(400)!,
                    ThemeConfig.getPrimaryColorShade(700)!,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: currentPage > 0
                    ? () => setState(() {
                          currentPage--;
                          setPageData();
                        })
                    : null,
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  // 'Showing ${currentPage + 1} of ${(widget.allData.length / pageSize).ceil()}',
                  '${AppLocalizations.of(context)?.showingPages(currentPage + 1, (widget.allData.length / pageSize).ceil())}',

                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeConfig.primaryTextColor,
                  ),
                ),
              ),
              ElevatedButton(
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: currentPage < (widget.allData.length / pageSize).ceil() - 1
                    ? () => setState(() {
                          currentPage++;
                          setPageData();
                        })
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
