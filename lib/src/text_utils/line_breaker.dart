import 'package:characters/characters.dart';

import '../shared/unicode_ranges.dart';

/// Inserts optional break hints into Myanmar text.
///
/// This is heuristic, not a full word segmenter.
String insertBreakHints(String text, {String hint = '\u200B'}) {
  final buffer = StringBuffer();
  String? previousCluster;
  for (final cluster in text.characters) {
    final first = cluster.runes.isNotEmpty ? cluster.runes.first : 0;
    final previousFirst = previousCluster == null
        ? 0
        : (previousCluster.runes.isNotEmpty ? previousCluster.runes.first : 0);
    final currentIsMyanmar = isMyanmarCodePoint(first);
    final previousIsMyanmar =
        previousCluster != null && isMyanmarCodePoint(previousFirst);
    final currentIsWhitespace = cluster.trim().isEmpty;
    final previousIsWhitespace = previousCluster?.trim().isEmpty ?? false;
    final currentIsPunctuation = _isBreakPunctuation(first);
    final previousIsPunctuation =
        previousCluster != null && _isBreakPunctuation(previousFirst);

    if (previousCluster != null) {
      final scriptTransition = previousIsMyanmar != currentIsMyanmar;
      final punctTransition =
          previousIsPunctuation ||
          currentIsPunctuation ||
          previousIsWhitespace ||
          currentIsWhitespace;
      if (scriptTransition || punctTransition) {
        buffer.write(hint);
      }
    }
    buffer.write(cluster);
    previousCluster = cluster;
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
