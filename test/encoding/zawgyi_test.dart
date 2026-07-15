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

  group('medial consonant chain (regression for cascading replacement bug)', () {
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

    test('each medial in the chain converts independently inside a syllable', () {
      // A base consonant followed by a Zawgyi medial should only have the
      // medial re-mapped, not cascade to a different medial entirely.
      expect(zawgyiToUnicode('\u1000\u103B'), '\u1000\u103C');
      expect(zawgyiToUnicode('\u1000\u103C'), '\u1000\u103D');
      expect(zawgyiToUnicode('\u1000\u103D'), '\u1000\u103E');
    });

    test('two-character digraph U+103D U+103E collapses to a single U+103E',
        () {
      expect(zawgyiToUnicode('\u103D\u103E'), '\u103E');
    });
  });

  group('round-tripping', () {
    // These would have caught the cascading-replacement bug immediately,
    // since a corrupted forward conversion breaks the round trip.
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
      // A common Zawgyi rendering of a consonant + medial-ra + vowel cluster.
      // Previously, the medial would cascade to the wrong target codepoint.
      final input = '\u1000\u103B\u102D'; // KA + zawgyi medial-ra + vowel I
      final result = zawgyiToUnicode(input);
      expect(result, '\u1000\u103C\u102D');
      // Sanity check: no leftover Zawgyi-only medial code points remain.
      expect(result.contains('\u103B'), isFalse);
    });
  });
}
