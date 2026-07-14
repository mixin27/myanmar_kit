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
  });

  final String myanmarFont;
  final String latinFont;
  final int weight;

  @override
  bool operator ==(Object other) {
    return other is _ScaleKey &&
        other.myanmarFont == myanmarFont &&
        other.latinFont == latinFont &&
        other.weight == weight;
  }

  @override
  int get hashCode => Object.hash(myanmarFont, latinFont, weight);
}
