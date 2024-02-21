import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

class ChartMetricSelectWidget extends StatefulWidget {
  const ChartMetricSelectWidget({super.key, required this.onMetricSelected});

  final Function(String?) onMetricSelected;

  @override
  State<ChartMetricSelectWidget> createState() =>
      _ChartMetricSelectWidgetState();
}

class _ChartMetricSelectWidgetState extends State<ChartMetricSelectWidget> {
  Map<String, String> _chartMetrics = {
    'avgScore': 'Average',
    'maxScore': 'Maximum',
    'minScore': 'Minimum'
  };

  String? _selectedMetric;

  @override
  Widget build(BuildContext context) {
    return CustomDropdownButton(context);
  }

  //Not in use, keeping it for reference
  Widget DropdownWidget(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedMetric,
        hint: Text("Select Metric"),
        icon: Icon(Icons.arrow_drop_down_circle, color: primary),
        items: _chartMetrics.keys.map((String metricKey) {
          return DropdownMenuItem<String>(
            value: metricKey,
            child: Text(_chartMetrics[metricKey]!),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedMetric = value;
            widget.onMetricSelected(value);
          });
        },
        style: TextStyle(color: Colors.black, fontSize: 16),
        borderRadius: BorderRadius.circular(10),
        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      ),
    );
  }

  Widget CustomDropdownButton(BuildContext context) {
    List<String> displayItems =
        _chartMetrics.entries.map((entry) => "${entry.value}").toList();
    int? _hoveredIndex; // To track the hovered item index

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Metric',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          SizedBox(
            height: 10,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 200, // Set your minimum width here
              maxWidth: 500, // Set your maximum width here
            ),
            child: CustomDropdown<String>.search(
              hintText: 'Select Metrics',
              items: displayItems,
              overlayHeight: 342,
              onChanged: (value) {
                String? selectedKey;
                for (var entry in _chartMetrics.entries) {
                  if (entry.value == value) {
                    selectedKey = entry.key;
                    break;
                  }
                }
                setState(() {
                  _selectedMetric = selectedKey;
                  widget.onMetricSelected(selectedKey);
                });
              },
              decoration: customDropdownDecoration,
            ),
          ),
        ],
      ),
    );
  }
}
