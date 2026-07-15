import 'dart:collection';

import 'package:flutter/material.dart';

/// Calculates metric-based scale factors for Myanmar fonts versus Latin fonts.
class FontMetricsScaleCache {
  FontMetricsScaleCache._();

  static final FontMetricsScaleCache instance = FontMetricsScaleCache._();

  final Map<_ScaleKey, double> _cache = HashMap();

  /// Precomputes and stores the scale for the provided font pairing.
  double precomputeScale({
    required String myanmarFont,
    required String latinFont,
    required FontWeight weight,
    double minScale = 0.8,
    double maxScale = 1.0,
  }) {
    return getScale(
      myanmarFont: myanmarFont,
      latinFont: latinFont,
      weight: weight,
      minScale: minScale,
      maxScale: maxScale,
    );
  }

  /// Returns the cached or computed scale for the provided font pairing.
  double getScale({
    required String myanmarFont,
    required String latinFont,
    required FontWeight weight,
    double minScale = 0.8,
    double maxScale = 1.0,
  }) {
    final key = _ScaleKey(
      myanmarFont: myanmarFont,
      latinFont: latinFont,
      weight: weight.value,
      minScale: minScale,
      maxScale: maxScale,
    );
    return _cache.putIfAbsent(key, () {
      final latinHeight = _measureHeight(
        fontFamily: latinFont,
        weight: weight,
        sample: _latinProbe,
      );
      final myanmarBodyScale =
          latinHeight /
          _measureHeight(
            fontFamily: myanmarFont,
            weight: weight,
            sample: _myanmarBodyProbe,
          );
      final myanmarStressScale =
          latinHeight /
          _measureHeight(
            fontFamily: myanmarFont,
            weight: weight,
            sample: _myanmarStressProbe,
          );
      final rawScale = (myanmarBodyScale * 0.85) + (myanmarStressScale * 0.15);
      final clamped = rawScale.clamp(minScale, maxScale).toDouble();
      if (clamped != rawScale) {
        debugPrint(
          'myanmar_kit: clamped font scale $rawScale to $clamped for '
          '$myanmarFont vs $latinFont',
        );
      }
      return clamped;
    });
  }

  /// Clears every cached scale, forcing the next [getScale] call for each
  /// font pairing to re-measure from scratch.
  ///
  /// [getScale] measures with a real text layout, which requires the
  /// requested font to already be resolved. If a Myanmar font is loaded
  /// asynchronously (a custom asset that hasn't finished parsing on first
  /// frame, a package like `google_fonts`, `FontLoader.loadFont()`, etc.)
  /// and any `MMText` builds before that completes, the measurement quietly
  /// falls back to the platform default font and computes an incorrect
  /// scale — one that is normally cached for the lifetime of the app.
  ///
  /// Call this once you can guarantee the font has finished loading (for
  /// example, after awaiting the `Future` returned by `FontLoader.load()`,
  /// or after `GoogleFonts.pendingFonts()` completes) and trigger a rebuild
  /// of any visible `MMText` widgets so they pick up the corrected scale.
  void clear() => _cache.clear();

  /// Clears the cached scale for a single font pairing, weight, and clamp
  /// range, instead of clearing everything. Useful when only one font in a
  /// multi-font app finished loading late.
  void invalidate({
    required String myanmarFont,
    required String latinFont,
    required FontWeight weight,
    double minScale = 0.8,
    double maxScale = 1.0,
  }) {
    _cache.remove(
      _ScaleKey(
        myanmarFont: myanmarFont,
        latinFont: latinFont,
        weight: weight.value,
        minScale: minScale,
        maxScale: maxScale,
      ),
    );
  }
}

const String _myanmarBodyProbe = 'မြန်မာစာ';
const String _myanmarStressProbe = 'က္ကြွှံ့';
const String _latinProbe = 'Hamburgefons';

double _measureHeight({
  required String fontFamily,
  required FontWeight weight,
  required String sample,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: sample,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: 100,
        fontWeight: weight,
      ),
    ),
    textDirection: TextDirection.ltr,
    textScaler: TextScaler.noScaling,
    maxLines: 1,
  )..layout();
  final lines = painter.computeLineMetrics();
  if (lines.isEmpty) {
    return 100;
  }
  final line = lines.first;
  return line.ascent + line.descent;
}

class _ScaleKey {
  const _ScaleKey({
    required this.myanmarFont,
    required this.latinFont,
    required this.weight,
    required this.minScale,
    required this.maxScale,
  });

  final String myanmarFont;
  final String latinFont;
  final int weight;

  // minScale/maxScale must be part of the cache key. Two MMTextConfig
  // instances can request the same font pairing with different clamp
  // bounds; without these fields, whichever config computes the scale
  // first "wins" and every other config silently reuses its clamped
  // value instead of applying its own minScale/maxScale.
  final double minScale;
  final double maxScale;

  @override
  bool operator ==(Object other) {
    return other is _ScaleKey &&
        other.myanmarFont == myanmarFont &&
        other.latinFont == latinFont &&
        other.weight == weight &&
        other.minScale == minScale &&
        other.maxScale == maxScale;
  }

  @override
  int get hashCode =>
      Object.hash(myanmarFont, latinFont, weight, minScale, maxScale);
}
