// ignore_for_file: constant_identifier_names

enum SectionType {
  Html,
  SingleSelectionQuestion,
  MultipleSelectionQuestion,
  FlipCard,
  NextSectionButton
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
