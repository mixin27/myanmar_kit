import '../shared/unicode_ranges.dart';

/// Myanmar sign virama (U+1039). When it immediately precedes a consonant,
/// that consonant is a stacked/subjoined consonant (common in Pali/Sanskrit
/// loanwords) and belongs to the same syllable as what came before it.
const int _virama = 0x1039;

/// Myanmar sign asat (U+103A). When it immediately follows a consonant,
/// that consonant is a syllable-final "killed" consonant and belongs to the
/// syllable it closes, not to a following one.
const int _asat = 0x103A;

/// Inserts optional break hints into Myanmar text.
///
/// Latin text has spaces to guide line wrapping, but Myanmar text is
/// conventionally written without spaces between words, and often without
/// spaces between syllables either. Without any soft-break opportunities,
/// a long unbroken Myanmar run has nowhere to wrap and will overflow its
/// container instead.
///
/// This inserts [hint] (a zero-width space by default) at:
/// - Script transitions (Myanmar <-> non-Myanmar)
/// - Punctuation and whitespace boundaries
/// - Heuristically detected Myanmar syllable boundaries, so long unbroken
///   Myanmar runs still gain wrap opportunities
///
/// Syllable detection is heuristic, not a full syllable segmenter. A code
/// point is treated as the start of a new syllable when it is a Myanmar
/// base consonant or independent vowel (not a combining mark) and:
/// - it is not immediately preceded by [_virama], since virama + consonant
///   forms a stacked consonant that belongs to the previous syllable, and
/// - it is not immediately followed by [_asat], since a consonant
///   immediately killed by asat is itself a syllable-final consonant that
///   closes the current syllable rather than starting a new one.
///
/// This will not match every edge case of Burmese orthography, but it
/// avoids the two most common ways a naive per-character heuristic breaks
/// visually valid syllables apart.
String insertBreakHints(String text, {String hint = '\u200B'}) {
  final buffer = StringBuffer();
  final runes = text.runes.toList(growable: false);
  final length = runes.length;
  int? previousRune;

  for (var i = 0; i < length; i++) {
    final current = runes[i];
    final next = i + 1 < length ? runes[i + 1] : null;

    final currentIsMyanmar = isMyanmarCodePoint(current);
    final previousIsMyanmar =
        previousRune != null && isMyanmarCodePoint(previousRune);
    final currentIsWhitespace = String.fromCharCode(current).trim().isEmpty;
    final previousIsWhitespace =
        previousRune != null &&
        String.fromCharCode(previousRune).trim().isEmpty;
    final currentIsPunctuation = _isBreakPunctuation(current);
    final previousIsPunctuation =
        previousRune != null && _isBreakPunctuation(previousRune);
    final currentIsSyllableStart =
        currentIsMyanmar &&
        !isMyanmarCombiningMark(current) &&
        previousRune != _virama &&
        next != _asat;

    if (previousRune != null) {
      final scriptTransition = previousIsMyanmar != currentIsMyanmar;
      final punctTransition =
          previousIsPunctuation ||
          currentIsPunctuation ||
          previousIsWhitespace ||
          currentIsWhitespace;
      final syllableTransition =
          previousIsMyanmar && currentIsMyanmar && currentIsSyllableStart;
      if (scriptTransition || punctTransition || syllableTransition) {
        buffer.write(hint);
      }
    }
    buffer.writeCharCode(current);
    previousRune = current;
  }
  return buffer.toString();
}

bool _isBreakPunctuation(int codePoint) {
  return switch (codePoint) {
    0x002C || // ,
    0x002E || // .
    0x003A || // :
    0x003B || // ;
    0x104A || // Myanmar little section
    0x104B || // Myanmar section
    0x104C || // Myanmar comma
    0x104D || // Myanmar full stop
    0x104E || // Myanmar symbol
    0x104F => // Myanmar symbol
    true,
    _ => false,
  };
}
