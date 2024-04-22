import 'package:flutter/cupertino.dart';

enum ValueType { percentage, string, number }

class UserSummary {
  String summaryTitle;

  dynamic value;
  String? type;
  Icon? icon;

  UserSummary({required this.summaryTitle, this.value, this.type, this.icon});
}
