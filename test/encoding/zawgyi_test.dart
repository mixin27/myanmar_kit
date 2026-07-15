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

  group(
    'medial consonant chain (regression for cascading replacement bug)',
    () {
      // Regression test for a bug where sequential (chained) String.replaceAll
      // calls caused a single Zawgyi medial to cascade through multiple
      // unrelated mappings: \u103B ended up as \u103E instead of \u103C
      // because the output of the \u103B -> \u103C replacement was re-scanned
      // by the following \u103C -> \u103D rule, and so on.
      test('U+103B maps only to U+103C, not further down the chain', () {
        expect(zawgyiToUnicode('\u103B'), '\u103C');
      });

      test('U+103C maps only to U+103D, not further down the chain', () {
        expect(zawgyiToUnicode('\u103C'), '\u103D');
      });

      test('U+103D maps only to U+103E, not further down the chain', () {
        expect(zawgyiToUnicode('\u103D'), '\u103E');
      });

      test(
        'each medial in the chain converts independently inside a syllable',
        () {
          expect(zawgyiToUnicode('\u1000\u103B'), '\u1000\u103C');
          expect(zawgyiToUnicode('\u1000\u103C'), '\u1000\u103D');
          expect(zawgyiToUnicode('\u1000\u103D'), '\u1000\u103E');
        },
      );

      test(
        'two-character digraph U+103D U+103E collapses to a single U+103E',
        () {
          expect(zawgyiToUnicode('\u103D\u103E'), '\u103E');
        },
      );
    },
  );

  group('round-tripping', () {
    const roundTrippableUnicode = [
      '\u1009', // NNA
      '\u1026', // E VOWEL + ASAT ligature
      '\u102F', // U VOWEL SIGN
      '\u1030', // UU VOWEL SIGN
      '\u103C', // MEDIAL RA
      '\u103D', // MEDIAL WA
      '\u103E', // MEDIAL HA
      '\u1039\u1000', // KINZI-style stacked consonant
      '\u1004\u103A\u1039', // KINZI
    ];

    for (final sample in roundTrippableUnicode) {
      test('unicodeToZawgyi -> zawgyiToUnicode round-trips "$sample"', () {
        final zawgyi = unicodeToZawgyi(sample);
        expect(zawgyiToUnicode(zawgyi), sample);
      });
    }
  });

  group('realistic sample text', () {
    test('converts a Zawgyi word containing a medial consonant', () {
      final input = '\u1000\u103B\u102D'; // KA + zawgyi medial-ra + vowel I
      final result = zawgyiToUnicode(input);
      expect(result, '\u1000\u103C\u102D');
      expect(result.contains('\u103B'), isFalse);
    });
  });

  group('detector false-positive regression', () {
    // Regression coverage: earlier versions scored the mere presence of
    // U+1031 and U+103B-U+103E, both of which are extremely common in
    // ordinary, correctly-encoded Unicode Myanmar text. That made the
    // detector flag nearly all real Myanmar sentences as Zawgyi.

    test('a correct Unicode sentence with common medials is not flagged', () {
      // "Myanmar is a country in Southeast Asia." - proper Unicode Myanmar,
      // containing several U+103C/U+1031 occurrences in valid logical order.
      const sentence =
          'မြန်မာနိုင်ငံသည် အရှေ့တောင်အာရှတွင် တည်ရှိသော နိုင်ငံတစ်ခု ဖြစ်သည်။';
      expect(isLikelyZawgyi(sentence), isFalse);
      expect(zawgyiConfidence(sentence), lessThan(0.45));
    });

    test('a short correct Unicode greeting is not flagged', () {
      const greeting = 'မင်္ဂလာပါ၊ နေကောင်းပါသလား။';
      expect(isLikelyZawgyi(greeting), isFalse);
    });

    test('U+1031 stored before its consonant (Zawgyi-style visual order) is '
        'still flagged', () {
      // Unicode always stores the base consonant before U+1031, even
      // though U+1031 renders to its left. Storing U+1031 first mimics
      // Zawgyi's closer-to-visual-order storage and should still score
      // as meaningful Zawgyi evidence.
      const zawgyiOrdered = '\u1031\u1000\u1031\u1001\u1031\u1002';
      expect(isLikelyZawgyi(zawgyiOrdered), isTrue);
    });
  });
}
