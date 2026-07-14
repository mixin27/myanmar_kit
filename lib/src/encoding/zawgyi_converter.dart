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

/// Converts common Zawgyi sequences to Unicode Myanmar.
///
/// This is a pragmatic, ordered replacement pipeline and does not claim full
/// coverage of all historical Zawgyi edge cases.
String zawgyiToUnicode(String text) {
  var result = text;
  for (final entry in _zg2uni) {
    result = result.replaceAll(entry.key, entry.value);
  }
  return result;
}

/// Converts common Unicode Myanmar sequences to Zawgyi.
///
/// This is only intended for legacy interop and round-tripping best effort.
String unicodeToZawgyi(String text) {
  var result = text;
  for (final entry in _uni2zg) {
    result = result.replaceAll(entry.key, entry.value);
  }
  return result;
}
