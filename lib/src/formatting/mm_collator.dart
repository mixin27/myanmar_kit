import 'dart:collection';

import 'mm_numerals.dart';

/// Compares strings using a lightweight Myanmar-aware sort key.
int compareMyanmar(String a, String b) {
  final left = _sortKey(a);
  final right = _sortKey(b);
  return left.compareTo(right);
}

String _sortKey(String input) {
  final buffer = StringBuffer();
  for (final rune in toArabicDigits(input).toLowerCase().runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(_weight[ch] ?? ch.codeUnitAt(0).toString().padLeft(6, '0'));
    buffer.write('-');
  }
  return buffer.toString();
}

final Map<String, String> _weight = HashMap.of({
  'က': '010',
  'ခ': '011',
  'ဂ': '012',
  'ဃ': '013',
  'င': '014',
  'စ': '020',
  'ဆ': '021',
  'ဇ': '022',
  'ဈ': '023',
  'ည': '024',
  'တ': '030',
  'ထ': '031',
  'ဒ': '032',
  'ဓ': '033',
  'န': '034',
  'ပ': '040',
  'ဖ': '041',
  'ဗ': '042',
  'ဘ': '043',
  'မ': '044',
  'ယ': '050',
  'ရ': '051',
  'လ': '052',
  'ဝ': '053',
  'သ': '054',
  'ဟ': '055',
  'အ': '056',
});
