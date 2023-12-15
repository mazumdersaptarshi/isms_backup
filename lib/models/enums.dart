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

/// All possible JSON schema keys for course and exam sections
enum SectionKeys {
  sectionId,
  sectionType,
  sectionTitle,
  sectionContent
}

/// All possible values for key `sectionType` in JSON schema of course and exam sections
enum SectionTypeValues {
  html,
  singleSelectionQuestion,
  multipleSelectionQuestion,
  flipCard,
  nextSectionButton
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
