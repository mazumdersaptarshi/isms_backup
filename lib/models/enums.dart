enum QUESTIONTYPE {
  MCQ, // Single correct answer
  Checkbox, // Multiple correct answers
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
