import 'package:characters/characters.dart';

/// Returns the number of user-perceived grapheme clusters in [text].
int graphemeLength(String text) => text.characters.length;

/// Returns the grapheme clusters of [text] as a list.
List<String> toGraphemeClusters(String text) => text.characters.toList();

/// Truncates [text] to [maxGraphemes] grapheme clusters.
String safeTruncate(String text, int maxGraphemes, {String ellipsis = '…'}) {
  if (maxGraphemes <= 0) {
    return text.isEmpty ? '' : ellipsis;
  }
  final clusters = text.characters;
  if (clusters.length <= maxGraphemes) {
    return text;
  }
  return clusters.take(maxGraphemes).toString() + ellipsis;
}
