import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/src/shared/unicode_ranges.dart';
import 'package:myanmar_kit/src/text/script_detector.dart';

void main() {
  test('Myanmar boundary checks', () {
    expect(isMyanmarCodePoint(0x1000), isTrue);
    expect(isMyanmarCodePoint(0x109F), isTrue);
    expect(isMyanmarCodePoint(0xAA60), isTrue);
    expect(isMyanmarCodePoint(0xA9E0), isTrue);
    expect(isMyanmarCodePoint(0x10A0), isFalse);
  });

  test('containsMyanmar detects mixed strings', () {
    expect(containsMyanmar('hello'), isFalse);
    expect(containsMyanmar('မြန်မာ'), isTrue);
    expect(containsMyanmar('hello မြန်မာ'), isTrue);
  });

  test('splitRuns keeps runs contiguous', () {
    final runs = splitRuns('abမြန်မာcd');
    expect(runs.length, 3);
    expect(runs[0].text, 'ab');
    expect(runs[1].isMyanmar, isTrue);
    expect(runs[2].text, 'cd');
  });
}
