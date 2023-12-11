// ignore_for_file: file_names

import 'dart:math';

String generateRandomString(int len) {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

String generateRandomId() {
  return generateRandomString(5);
}

String generateRandomEventId() {
  return generateRandomString(5);
}
