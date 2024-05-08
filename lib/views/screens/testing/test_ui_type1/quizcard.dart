import 'package:flutter/material.dart';

// import 'package:isms/views/screens/testing/test_ui/themes.dart';
import 'package:isms/views/screens/testing/test_ui_type1/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizCard extends StatefulWidget {
  @override
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  int _selectedChoice = -1; // Variable to track the selected choice
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        // Apply the custom Card theme
        data: Theme.of(context).copyWith(cardTheme: AppThemes.quizCard),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Identify some of the industries that use Document AI to transform their businesses.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              _buildChoiceTile('Engineering, Manufacturing, and Construction', 0),
              SizedBox(height: 20),
              _buildChoiceTile('Supply Chain', 1),
              SizedBox(height: 20),
              _buildChoiceTile('Sports', 2),
              SizedBox(height: 20),
              _buildChoiceTile('Health Care and Life Sciences', 3),
              SizedBox(height: 20), // Spacing before the submit button
              Center(
                // Centering the button
                child: ElevatedButton(
                  style: AppThemes.elevatedButtonStyle,
                  onPressed: () {
                    // TODO: Add submit action
                  },
                  child: Text('${AppLocalizations.of(context)?.submit}', style: TextStyle(fontSize: 16)), // Button size
                ),
              ),
              SizedBox(height: 20), // Spacing after the submit button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceTile(String title, int index) {
    bool isHovered = _hoveredIndex == index;
    return MouseRegion(
      onEnter: (_) => _setHoveredIndex(index),
      onExit: (_) => _setHoveredIndex(null),
      child: Container(
        color: isHovered ? Colors.grey.shade100 : Colors.transparent,
        child: ListTile(
          title: Text(title),
          leading: Radio(
            value: index,
            groupValue: _selectedChoice,
            onChanged: (int? value) {
              setState(() {
                _selectedChoice = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  void _setHoveredIndex(int? index) {
    setState(() {
      _hoveredIndex = index;
    });
  }
}
