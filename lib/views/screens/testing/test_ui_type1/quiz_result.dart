import 'package:flutter/material.dart';
import 'quiz_result_data.dart';
import '../../../widgets/shared_widgets/custom_app_bar.dart';

class QuizResultPage extends StatelessWidget {
  const QuizResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IsmsAppBar(context: context),
      body: ListView.builder(
        itemCount: dataScienceMCQsWithResponses.length,
        itemBuilder: (context, index) {
          return _buildQuizItem(dataScienceMCQsWithResponses[index]);
        },
      ),
    );
  }

  Widget _buildQuizItem(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 80, left: 80),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildQuestionText(data['questionText']),
              const SizedBox(height: 16),
              _buildOptions(data['options'], data['correctAnswers'], data['userResponse']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionText(String questionText) {
    return Text(
      questionText,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOptions(List<Map<String, dynamic>> options, List<String> correctAnswers, List<String> userResponse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        return _buildOption(option, correctAnswers, userResponse);
      }).toList(),
    );
  }

  Widget _buildOption(Map<String, dynamic> option, List<String> correctAnswers, List<String> userResponse) {
    bool isCorrect = correctAnswers.contains(option['optionId']);
    bool isUserSelected = userResponse.contains(option['optionId']);

    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '${option['optionId']}. ',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '${option['optionText']}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: isCorrect
                      ? isUserSelected
                      ? Colors.blue // Blue for correct, user-selected options
                      : Colors.black // black for correct, unselected options
                      : isUserSelected
                      ? Colors.red // Red for wrong, user-selected options
                      : Colors.black, // Black for neutral options
                  fontWeight: isUserSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              // Always show "(Correct answer)" for correct options, with separate styling:
              if (isCorrect)
                const TextSpan(
                  text: ' (Correct answer)',
                  style: TextStyle(
                    fontSize: 16.0, // Adjust font size for distinction
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.normal, // Ensure normal font weight
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8), // Add 8 point spacing between options
      ],
    );
  }
}