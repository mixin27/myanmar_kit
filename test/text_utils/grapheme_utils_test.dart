import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/src/text_utils/grapheme_utils.dart';

void main() {
  test('counts and truncates graphemes', () {
    expect(graphemeLength('မြန်မာ'), greaterThan(0));
    expect(toGraphemeClusters('a\u{1F1FA}\u{1F1F3}'), isNotEmpty);
    expect(safeTruncate('မြန်မာစာ', 2), endsWith('…'));
  });
}
