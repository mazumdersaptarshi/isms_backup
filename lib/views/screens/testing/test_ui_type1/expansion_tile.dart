import 'package:flutter/material.dart';

// import 'package:isms/views/screens/testing/test_ui/themes.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

class ExpansionTileCard extends StatefulWidget {
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
      child: Container(
        decoration: _isExpanded
            ? expansionTileOn() // Use the theme when the tile is expanded
            : expansionTileOff(),
        child: ExpansionTile(
          title: Text(
            'Click to know more about Document AI',
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Document AI for lending(opens in a new tab) is a specialized solution designed for the mortgage space with industry-leading data accuracy. It processes income and asset documents to speed up loan applications – a notoriously slow and complex process. Document AI for lending leverages a set of specialized models, focused on document types used in mortgage lending, and automates many of the routine document reviews so mortgage servicers can focus on more value-added decisions.Document AI for procurement(opens in a new tab) helps companies automate one of their highest volume and highest value business processes – the procurement cycle. Google Cloud provides a group of AI-powered parsers, starting with invoices and receipts, that take documents in a variety of formats and return cleanly structured data.',
              ),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
        ),
      ),
    );
  }
}
