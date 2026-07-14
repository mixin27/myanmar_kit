import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/src/text_utils/line_breaker.dart';

void main() {
  test('does not break short Myanmar words aggressively', () {
    expect(insertBreakHints('မြန်မာ'), 'မြန်မာ');
  });

  test('inserts hint at script and punctuation transitions', () {
    expect(insertBreakHints('Hello မြန်မာ။').contains('\u200B'), isTrue);
  });
}
