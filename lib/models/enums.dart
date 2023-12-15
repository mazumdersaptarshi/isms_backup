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
  singleSelectionQuestion,
  multipleSelectionQuestion,
  flipCard,
  nextSectionButton
}

/// All possible JSON schema keys for questions
enum QuestionKeys {
  questionText,
  questionAnswers
}

/// All possible JSON schema keys for answers
enum AnswerKeys {
  answerText,
  answerCorrect
}

/// All possible JSON schema keys for flipcards
enum FlipCardKeys {
  flipCardFront,
  flipCardBack
}

class EnumToString {
  static String? getStringValue<T>(T value) {
    if (value == null) {
      return null;
    }
    return value.toString().split('.').last;
  }

  static T? fromString<T>(Iterable<T> values, String? value) {
    if (value == null) {
      return null;
    }
    return values.firstWhere(
      (v) => value.toLowerCase() == getStringValue(v)?.toLowerCase(),
      orElse: () =>
          null as T, // Use type casting to ensure the correct return type
    );
  }
}
