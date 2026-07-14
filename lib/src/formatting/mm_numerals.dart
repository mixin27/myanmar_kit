const List<String> _myanmarDigits = [
  '၀',
  '၁',
  '၂',
  '၃',
  '၄',
  '၅',
  '၆',
  '၇',
  '၈',
  '၉',
];

/// Converts ASCII digits to Myanmar digits.
String toMyanmarDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    final index = int.tryParse(ch);
    buffer.write(index == null ? ch : _myanmarDigits[index]);
  }
  return buffer.toString();
}

/// Converts Myanmar digits to ASCII digits.
String toArabicDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final index = _myanmarDigits.indexOf(String.fromCharCode(rune));
    buffer.write(index == -1 ? String.fromCharCode(rune) : index.toString());
  }
  return buffer.toString();
}
