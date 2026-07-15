import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/src/text_utils/line_breaker.dart';

void main() {
  group('syllable boundaries inside continuous Myanmar text', () {
    // Regression coverage: earlier versions of insertBreakHints only added
    // hints at script transitions or punctuation/whitespace, never *inside*
    // a continuous Myanmar run. That meant a long Myanmar sentence with no
    // spaces had no wrap opportunities at all and would simply overflow.

    test('inserts exactly one hint between two syllables of one word', () {
      // "မြန်မာ" (Myanmar) is two syllables: "မြန်" + "မာ".
      final result = insertBreakHints('မြန်မာ');
      expect('\u200B'.allMatches(result).length, 1);
      expect(result, 'မြန်\u200Bမာ');
    });

    test('inserts a hint between concatenated words with no space', () {
      // "မြန်မာစာ" ("Myanmar" + "language") has no space between the two
      // words, which is normal in Burmese. There should be at least one
      // break opportunity between them.
      final result = insertBreakHints('မြန်မာစာ');
      expect('\u200B'.allMatches(result).length, greaterThanOrEqualTo(2));
    });

    test('does not break a stacked (virama) consonant from its base', () {
      // "ဝိဇ္ဇာ" contains a virama-joined stacked consonant (ဇ + virama +
      // ဇ). The stacked consonant must stay attached to what precedes it.
      final result = insertBreakHints('ဝိဇ\u1039ဇာ');
      expect(result.contains('ဇ\u200B\u1039'), isFalse);
      expect(result.contains('\u1039\u200Bဇ'), isFalse);
    });

    test('does not break a closed syllable apart at its final consonant', () {
      // "စိမ်း" (green) is a single closed syllable: consonant + vowel
      // sign + a second consonant immediately killed by asat. The killed
      // consonant must stay part of the same syllable, not start a new one.
      final result = insertBreakHints('စိမ်း');
      expect(result, 'စိမ်း');
    });
  });

  test('does not break short Myanmar words aggressively', () {
    // A single closed syllable should never gain an internal hint.
    expect(insertBreakHints('စက်'), 'စက်');
  });

  test('inserts hint at script and punctuation transitions', () {
    expect(insertBreakHints('Hello မြန်မာ။').contains('\u200B'), isTrue);
  });
}
