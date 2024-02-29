enum ValueType { percentage, string, number }

class UserSummary {
  String summaryTitle;

  dynamic value;
  String? type;

  UserSummary({required this.summaryTitle, this.value, this.type});
}
