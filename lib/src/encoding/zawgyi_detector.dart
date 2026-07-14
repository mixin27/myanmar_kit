/// Heuristic Zawgyi detection utilities.
///
/// The detector is not deterministic. It scores sequences that are more common
/// in Zawgyi than in Unicode Myanmar text and returns a confidence value.
double zawgyiConfidence(String text) {
  if (text.isEmpty) {
    return 0;
  }

  var score = 0.0;
  for (var i = 0; i < text.length; i++) {
    final code = text.codeUnitAt(i);
    if (code == 0x1031) {
      score += 0.12;
    }
    if (code == 0x103B || code == 0x103C || code == 0x103D || code == 0x103E) {
      score += 0.10;
    }
    if (code == 0x106A || code == 0x106B || code == 0x106C || code == 0x106D) {
      score += 0.25;
    }
    if (code == 0x108F || code == 0x1090 || code == 0x1091 || code == 0x1092) {
      score += 0.18;
    }
    if (i + 1 < text.length) {
      final next = text.codeUnitAt(i + 1);
      if (code == 0x1031 && next >= 0x1000 && next <= 0x1021) {
        score += 0.20;
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
