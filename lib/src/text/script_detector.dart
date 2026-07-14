import 'dart:collection';

import 'package:characters/characters.dart';

import '../shared/unicode_ranges.dart';

/// A contiguous text run split by Myanmar/non-Myanmar script boundaries.
class TextRun {
  /// Creates a text run.
  const TextRun(this.text, this.isMyanmar);

  /// The run text.
  final String text;

  /// Whether the run is Myanmar script.
  final bool isMyanmar;
}

const int splitRunsCacheLimit = 500;

final LinkedHashMap<String, List<TextRun>> _splitRunsCache = LinkedHashMap();

/// Returns whether [text] contains any Myanmar code point.
bool containsMyanmar(String text) {
  for (var i = 0; i < text.length; i++) {
    final codeUnit = text.codeUnitAt(i);
    if (codeUnit >= 0xD800 && codeUnit <= 0xDBFF && i + 1 < text.length) {
      final codePoint =
          0x10000 +
          (((codeUnit - 0xD800) << 10) | (text.codeUnitAt(++i) - 0xDC00));
      if (isMyanmarCodePoint(codePoint)) {
        return true;
      }
      continue;
    }
    if (isMyanmarCodePoint(codeUnit)) {
      return true;
    }
  }
  return false;
}

/// Splits [text] into contiguous Myanmar and non-Myanmar runs.
///
/// Combining marks are kept with their current run and orphaned marks are
/// attached to the preceding run when possible.
List<TextRun> splitRuns(String text) {
  final cached = _splitRunsCache[text];
  if (cached != null) {
    return cached;
  }

  if (text.isEmpty) {
    return const <TextRun>[];
  }

  final runs = <TextRun>[];
  final buffer = StringBuffer();
  bool? currentMyanmar;

  void flush() {
    if (buffer.isEmpty || currentMyanmar == null) {
      buffer.clear();
      return;
    }
    final runIsMyanmar = currentMyanmar == true;
    runs.add(TextRun(buffer.toString(), runIsMyanmar));
    buffer.clear();
  }

  for (final cluster in text.characters) {
    final codePoint = cluster.runes.isNotEmpty ? cluster.runes.first : 0;
    final clusterMyanmar =
        isMyanmarCodePoint(codePoint) ||
        (isMyanmarCombiningMark(codePoint) && currentMyanmar == true);

    if (currentMyanmar == null) {
      currentMyanmar = clusterMyanmar;
      buffer.write(cluster);
      continue;
    }

    final orphanCombiningMark =
        isMyanmarCombiningMark(codePoint) && !clusterMyanmar;
    if (orphanCombiningMark) {
      buffer.write(cluster);
      continue;
    }

    if (clusterMyanmar != currentMyanmar) {
      flush();
      currentMyanmar = clusterMyanmar;
    }

    buffer.write(cluster);
  }

  flush();

  if (_splitRunsCache.length >= splitRunsCacheLimit) {
    _splitRunsCache.remove(_splitRunsCache.keys.first);
  }
  final value = List<TextRun>.unmodifiable(runs);
  _splitRunsCache[text] = value;
  return value;
}
