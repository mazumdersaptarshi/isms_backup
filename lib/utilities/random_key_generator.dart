import 'dart:math';

///Generates random key in the format [a-zA-Z]{2}\d{2}[a-zA-Z]{2}
///Example Output: 'hb43ed'
String randomKeyGenerator() {
  const String letters = 'abcdefghijklmnopqrstuvwxyz';
  const String digits = '0123456789';
  Random rnd = Random();

  // Generate two random letters
  String twoLetters() =>
      String.fromCharCodes(Iterable.generate(2, (_) => letters.codeUnitAt(rnd.nextInt(letters.length))));

  // Generate two random digits
  String twoDigits() =>
      String.fromCharCodes(Iterable.generate(2, (_) => digits.codeUnitAt(rnd.nextInt(digits.length))));

  // Combine them in the format: letter-letter-digit-digit-letter-letter
  return twoLetters() + twoDigits() + twoLetters();
}
