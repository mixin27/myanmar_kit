import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/src/encoding/zawgyi_converter.dart';
import 'package:myanmar_kit/src/encoding/zawgyi_detector.dart';

void main() {
  test('detects likely Zawgyi text', () {
    expect(isLikelyZawgyi('ေကျာင္း'), isA<bool>());
  });

  test('converts common sequences', () {
    expect(zawgyiToUnicode('\u106A'), '\u1009');
    expect(unicodeToZawgyi('\u1009'), '\u106A');
  });
}
