// ignore_for_file: constant_identifier_names

/// All possible JSON schema keys for courses
enum CourseKeys {
  courseId,
  courseTitle,
  courseDescription,
  courseSections
}

/// All possible JSON schema keys for exams
enum ExamKeys {
  courseId,
  examId,
  examTitle,
  examDescription,
  examRequiredCorrectAnswers,
  examAllowedAttempts,
  examSections
}

/// All possible JSON schema keys for course and exam sections
enum SectionKeys {
  sectionId,
  sectionTitle,
  sectionElements
}

/// All possible JSON schema keys for course and exam elements
enum ElementKeys {
  elementId,
  elementType,
  elementTitle,
  elementContent
}

/// All possible values for key `elementType` in JSON schema of course and exam elements
enum ElementTypeValues {
  html,
  question,
  flipCard
}

/// All possible JSON schema keys for questions
enum QuestionKeys {
  questionId,
  questionType,
  questionText,
  questionAnswers
}

/// All possible values for key `questionType` in JSON schema of question elements
enum QuestionTypeValues {
  singleSelectionQuestion,
  multipleSelectionQuestion
}

/// All possible JSON schema keys for answers
enum AnswerKeys {
  answerId,
  answerText,
  answerCorrect
}

/// All possible JSON schema keys for flipcards
enum FlipCardKeys {
  flipCardId,
  flipCardFront,
  flipCardBack
}