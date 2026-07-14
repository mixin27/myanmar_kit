import 'mm_numerals.dart';

final RegExp _nrcPattern = RegExp(
  r'^(\d{1,2})/([A-Za-z]{2,12})(?:\(([NnEePp])\))?(\d{1,6})$',
);

/// Returns whether [input] looks like a valid Myanmar NRC number.
bool isValidNrc(String input) {
  return _nrcPattern.hasMatch(formatNrc(input));
}

/// Normalizes separators, spacing, and casing in an NRC number.
String formatNrc(String input) {
  final normalized = toArabicDigits(input)
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll('／', '/')
      .replaceAll('（', '(')
      .replaceAll('）', ')')
      .replaceAll('-', '');
  final match = _nrcPattern.firstMatch(normalized);
  if (match == null) {
    return normalized;
  }
  final region = match.group(1)!;
  final township = match.group(2)!.toUpperCase();
  final type = match.group(3)?.toUpperCase();
  final number = match.group(4)!;
  return '$region/$township${type == null ? '' : '($type)'}$number';
}
