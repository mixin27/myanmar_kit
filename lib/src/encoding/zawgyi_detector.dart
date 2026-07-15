/// Heuristic Zawgyi detection utilities.
///
/// The detector is not deterministic. It scores sequences that are more
/// common in Zawgyi than in Unicode Myanmar text and returns a confidence
/// value.
///
/// Earlier versions of this function also scored the mere *presence* of
/// U+1031 (vowel sign E) and U+103B–U+103E (medial consonants) on their
/// own. Both are extremely common in ordinary, correctly-encoded Unicode
/// Myanmar text — nearly every sentence containing a handful of everyday
/// words uses several of them — so scoring their presence alone produced
/// severe false positives: a plain, correctly-encoded Unicode sentence
/// could easily score above the [isLikelyZawgyi] threshold. This version
/// relies on *ordering* patterns instead, which are genuinely more common
/// in Zawgyi than in Unicode:
///
/// - U+1031 immediately followed by a base consonant. Unicode always
///   stores a base consonant before its vowel sign, even for vowels (like
///   U+1031) that render visually to the consonant's left. Zawgyi commonly
///   stores text closer to visual order, so this ordering is rare in valid
///   Unicode text but common in Zawgyi.
/// - U+103B immediately followed by U+103C, and U+1039 immediately
///   followed by U+1031 — both reflect Zawgyi's non-standard reuse of the
///   medial/vowel code point range.
double zawgyiConfidence(String text) {
  if (text.isEmpty) {
    return 0;
  }

  var score = 0.0;
  for (var i = 0; i < text.length; i++) {
    final code = text.codeUnitAt(i);
    if (code == 0x106A || code == 0x106B || code == 0x106C || code == 0x106D) {
      score += 0.25;
    }
    if (code == 0x108F || code == 0x1090 || code == 0x1091 || code == 0x1092) {
      score += 0.18;
    }
    if (i + 1 < text.length) {
      final next = text.codeUnitAt(i + 1);
      if (code == 0x1031 && next >= 0x1000 && next <= 0x1021) {
        score += 0.28;
      }
      if (code == 0x103B && next == 0x103C) {
        score += 0.12;
      }
      if (code == 0x1039 && next == 0x1031) {
        score += 0.10;
      }
    }
  }
  return score.clamp(0.0, 1.0).toDouble();
}

/// Returns whether [text] is likely encoded in Zawgyi.
bool isLikelyZawgyi(String text) => zawgyiConfidence(text) >= 0.45;
