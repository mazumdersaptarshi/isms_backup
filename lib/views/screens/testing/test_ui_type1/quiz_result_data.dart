final List<Map<String, dynamic>> dataScienceMCQsWithResponses = [
  {

    "questionId": "q1",
    "questionText": "Which of the following is a supervised machine learning method? (single question, correct answer)",
    "options": [
      {"optionId": "a", "optionText": "K-means Clustering"},
      {"optionId": "b", "optionText": "Principal Component Analysis"},
      {"optionId": "c", "optionText": "Linear Regression"},
      {"optionId": "d", "optionText": "Apriori Algorithm"}
    ],
    "correctAnswers": ["c"],
    "userResponse": ["c"], // User selected the correct answer
  },
  {
    "questionId": "q2",
    "questionText": "Which Python library is used for data manipulation and analysis? (single question, wrong answer)",
    "options": [
      {"optionId": "a", "optionText": "NumPy"},
      {"optionId": "b", "optionText": "Pandas"},
      {"optionId": "c", "optionText": "Matplotlib"},
      {"optionId": "d", "optionText": "Scikit-learn"}
    ],
    "correctAnswers": ["b"],
    "userResponse": ["d"], // User selected the wrong answer
  },
  {
    "questionId": "q3",
    "questionText": "What is the main purpose of the train-test split in machine learning models? (multiple questions, both correct answers)",
    "options": [
      {"optionId": "a", "optionText": "Feature selection"},
      {"optionId": "b", "optionText": "Algorithm selection"},
      {"optionId": "c", "optionText": "Model evaluation"},
      {"optionId": "d", "optionText": "Data cleaning"}
    ],
    "correctAnswers": ["c","a"],
    "userResponse": ["c","a"], // User selected the correct answer
  },
  {
    "questionId": "q4",
    "questionText": "Which metric can be used to evaluate a regression model's performance? (multiple questions, both wrong answers)",
    "options": [
      {"optionId": "a", "optionText": "Accuracy"},
      {"optionId": "b", "optionText": "Recall"},
      {"optionId": "c", "optionText": "Mean Squared Error (MSE)"},
      {"optionId": "d", "optionText": "F1 Score"}
    ],
    "correctAnswers": ["c", "b"],
    "userResponse": ["a", "d"], // User selected the wrong answer
  },
  {
    "questionId": "q5",
    "questionText": "Which of the following is true about 'Big Data'? (multiple questions, one correct answer)",
    "options": [
      {"optionId": "a", "optionText": "Only refers to the volume of data"},
      {"optionId": "b", "optionText": "Refers to datasets that are too large to be processed by traditional data processing applications"},
      {"optionId": "c", "optionText": "Is only about the variety of data"},
      {"optionId": "d", "optionText": "All of the above"}
    ],
    "correctAnswers": ["b", "a"],
    "userResponse": ["b", "c"], // User selected the correct answer
  },
  // Add more questions and responses as needed
];
