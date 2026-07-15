const List<MapEntry<String, String>> _zg2uni = [
  MapEntry('\u106A', '\u1009'),
  MapEntry('\u1025\u103A', '\u1026'),
  MapEntry('\u1025\u102E', '\u1026'),
  MapEntry('\u1033', '\u102F'),
  MapEntry('\u1034', '\u1030'),
  MapEntry('\u103D\u103E', '\u103E'),
  MapEntry('\u103B', '\u103C'),
  MapEntry('\u103C', '\u103D'),
  MapEntry('\u103D', '\u103E'),
  MapEntry('\u1060', '\u1039\u1000'),
  MapEntry('\u1061', '\u1039\u1001'),
  MapEntry('\u1062', '\u1039\u1002'),
  MapEntry('\u1063', '\u1039\u1003'),
  MapEntry('\u1064', '\u1004\u103A\u1039'),
  MapEntry('\u1065', '\u1039\u1005'),
  MapEntry('\u1066', '\u1039\u1006'),
  MapEntry('\u1067', '\u1039\u1007'),
  MapEntry('\u1068', '\u1039\u1008'),
  MapEntry('\u1069', '\u1039\u1009'),
];

const List<MapEntry<String, String>> _uni2zg = [
  MapEntry('\u1009', '\u106A'),
  MapEntry('\u1026', '\u1025\u103A'),
  MapEntry('\u102F', '\u1033'),
  MapEntry('\u1030', '\u1034'),
  MapEntry('\u103C', '\u103B'),
  MapEntry('\u103D', '\u103C'),
  MapEntry('\u103E', '\u103D'),
  MapEntry('\u1039\u1000', '\u1060'),
  MapEntry('\u1039\u1001', '\u1061'),
  MapEntry('\u1039\u1002', '\u1062'),
  MapEntry('\u1039\u1003', '\u1063'),
  MapEntry('\u1004\u103A\u1039', '\u1064'),
];

/// [_zg2uni] sorted by descending key length so multi-character sequences
/// (e.g. `\u1025\u103A`) are matched before their single-character prefixes
/// (e.g. `\u1025`) at the same text position.
final List<MapEntry<String, String>> _zg2uniByLength =
    List<MapEntry<String, String>>.of(_zg2uni)
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

/// [_uni2zg] sorted by descending key length, for the same reason.
final List<MapEntry<String, String>> _uni2zgByLength =
    List<MapEntry<String, String>>.of(_uni2zg)
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

/// Applies [pairs] to [text] in a single left-to-right pass over the
/// *original* text.
///
/// Earlier implementations chained multiple `String.replaceAll` calls, each
/// one scanning the output of the previous call. Because several patterns
/// here overlap (for example `\u103B -> \u103C` followed by
/// `\u103C -> \u103D`), that approach re-matched characters that had already
/// been produced by an earlier substitution, cascading a single character
/// through multiple unrelated replacements (`\u103B` ended up as `\u103E`
/// instead of the intended `\u103C`).
///
/// Resolving all patterns in one pass over the original text — trying the
/// longest pattern first at each position — means every input character is
/// consumed and replaced at most once, so replacement outputs are never
/// re-scanned for further matches.
String _applyOrderedReplacements(
  String text,
  List<MapEntry<String, String>> patternsByDescendingLength,
) {
  final buffer = StringBuffer();
  var i = 0;
  final length = text.length;
  while (i < length) {
    MapEntry<String, String>? match;
    for (final pair in patternsByDescendingLength) {
      if (text.startsWith(pair.key, i)) {
        match = pair;
        break;
      }
    }
    if (match != null) {
      buffer.write(match.value);
      i += match.key.length;
    } else {
      buffer.write(text[i]);
      i += 1;
    }
  }
  return buffer.toString();
}

/// Converts common Zawgyi sequences to Unicode Myanmar.
///
/// This is a pragmatic, single-pass, longest-match-first replacement and
/// does not claim full coverage of all historical Zawgyi edge cases.
String zawgyiToUnicode(String text) =>
    _applyOrderedReplacements(text, _zg2uniByLength);

/// Converts common Unicode Myanmar sequences to Zawgyi.
///
/// This is only intended for legacy interop and round-tripping best effort.
String unicodeToZawgyi(String text) =>
    _applyOrderedReplacements(text, _uni2zgByLength);
