// expantiontile.dart

import 'package:flutter/material.dart';
// import 'package:formatting1/format.dart';

class ExpansionTileCard extends StatefulWidget {
  final String closedTitle;
  final String expandedTitle;
  final List<Widget> content;

  ExpansionTileCard({
    required this.closedTitle,
    required this.expandedTitle,
    required this.content,
  });

  @override
  _ExpansionTileCardState createState() => _ExpansionTileCardState();
}

class _ExpansionTileCardState extends State<ExpansionTileCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black45,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_isExpanded ? 10.0 : 10.0),
                topRight: Radius.circular(_isExpanded ? 10.0 : 10.0),
              ),
            ),
            child: ListTile(
              title: Text(
                _isExpanded
                    ? '- ${widget.expandedTitle}'
                    : '+ ${widget.closedTitle}',
                style: TextStyle(
                  color: _isExpanded ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (Widget item in widget.content)
                    if (item is Text)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          item.data!,
                          style: item.style,
                          softWrap: true,
                        ),
                      )
                    else
                      item,
                ],
              ),
            ),
        ],
      ),
    );
  }
}
