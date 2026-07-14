/// Canonical Myanmar Unicode ranges used throughout `myanmar_kit`.
library;

/// Myanmar block in Unicode 3.0 and later.
const int myanmarBlockStart = 0x1000;

/// Myanmar block in Unicode 3.0 and later.
const int myanmarBlockEnd = 0x109F;

/// Myanmar Extended-A block in Unicode 6.1.
const int myanmarExtendedAStart = 0xAA60;

/// Myanmar Extended-A block in Unicode 6.1.
const int myanmarExtendedAEnd = 0xAA7F;

/// Myanmar Extended-B block in Unicode 7.0.
const int myanmarExtendedBStart = 0xA9E0;

/// Myanmar Extended-B block in Unicode 7.0.
const int myanmarExtendedBEnd = 0xA9FF;

/// Returns whether [codePoint] is in any Myanmar Unicode block used by the package.
bool isMyanmarCodePoint(int codePoint) {
  return (codePoint >= myanmarBlockStart && codePoint <= myanmarBlockEnd) ||
      (codePoint >= myanmarExtendedAStart &&
          codePoint <= myanmarExtendedAEnd) ||
      (codePoint >= myanmarExtendedBStart && codePoint <= myanmarExtendedBEnd);
}

/// Returns whether [codePoint] is a Myanmar combining mark or virama-like sign.
bool isMyanmarCombiningMark(int codePoint) {
  return switch (codePoint) {
    0x102B ||
    0x102C ||
    0x102D ||
    0x102E ||
    0x102F ||
    0x1030 ||
    0x1031 ||
    0x1032 ||
    0x1036 ||
    0x1037 ||
    0x1038 ||
    0x1039 ||
    0x103A ||
    0x103B ||
    0x103C ||
    0x103D ||
    0x103E ||
    0x105E ||
    0x105F ||
    0x1060 ||
    0x1061 ||
    0x1062 ||
    0x1063 ||
    0x1064 ||
    0x1067 ||
    0x1068 ||
    0x1069 ||
    0x106C ||
    0x106D ||
    0x1071 ||
    0x1072 ||
    0x1073 ||
    0x1074 ||
    0x1082 ||
    0x1085 ||
    0x1086 ||
    0x108D ||
    0xAA7B ||
    0xAA7C ||
    0xAA7D ||
    0xAA7E ||
    0xAA7F => true,
    _ => false,
  };
}
