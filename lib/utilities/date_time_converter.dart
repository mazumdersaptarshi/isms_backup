import 'package:intl/intl.dart';

class DateTimeConverter {
  static String convertToReadableDateTime(String rawDateTime) {
    DateTime dateTime = DateTime.parse(rawDateTime);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
    String formattedDateTime = '$formattedDate  $formattedTime';
    return formattedDateTime;
  }
}
