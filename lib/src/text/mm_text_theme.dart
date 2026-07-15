import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'font_metrics.dart';

/// Theme-level configuration for `myanmar_kit` text widgets.
@immutable
class MMTextTheme extends ThemeExtension<MMTextTheme> {
  /// Creates a theme extension with explicit font families and scale bounds.
  const MMTextTheme({
    this.myanmarFont = 'Noto Sans Myanmar',
    this.latinFont = 'Roboto',
    this.minScale = 0.8,
    this.maxScale = 1.0,
  });

  /// Creates a platform-aware default theme extension.
  MMTextTheme.adaptive({this.minScale = 0.8, this.maxScale = 1.0})
    : myanmarFont = switch (defaultTargetPlatform) {
        TargetPlatform.iOS || TargetPlatform.macOS => 'Myanmar Sangam MN',
        _ => 'Noto Sans Myanmar',
      },
      latinFont = switch (defaultTargetPlatform) {
        TargetPlatform.iOS || TargetPlatform.macOS => 'Helvetica Neue',
        _ => 'Roboto',
      };

  /// Font family used for Myanmar script runs.
  final String myanmarFont;

  /// Font family used for Latin script runs.
  final String latinFont;

  /// Minimum allowed scale factor for Myanmar text.
  final double minScale;

  /// Maximum allowed scale factor for Myanmar text.
  final double maxScale;

  /// Returns the nearest [MMTextTheme] or a platform-aware default.
  static MMTextTheme of(BuildContext context) {
    return Theme.of(context).extension<MMTextTheme>() ?? MMTextTheme.adaptive();
  }

  /// Returns the computed Myanmar scaling factor for this configuration.
  double scaleFor({required FontWeight weight}) {
    return FontMetricsScaleCache.instance.getScale(
      myanmarFont: myanmarFont,
      latinFont: latinFont,
      weight: weight,
      minScale: minScale,
      maxScale: maxScale,
    );
  }

  @override
  MMTextTheme copyWith({
    String? myanmarFont,
    String? latinFont,
    double? minScale,
    double? maxScale,
  }) {
    return MMTextTheme(
      myanmarFont: myanmarFont ?? this.myanmarFont,
      latinFont: latinFont ?? this.latinFont,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
    );
  }

  @override
  MMTextTheme lerp(ThemeExtension<MMTextTheme>? other, double t) {
    if (other is! MMTextTheme) {
      return this;
    }
    return MMTextTheme(
      myanmarFont: t < 0.5 ? myanmarFont : other.myanmarFont,
      latinFont: t < 0.5 ? latinFont : other.latinFont,
      minScale: minScale + (other.minScale - minScale) * t,
      maxScale: maxScale + (other.maxScale - maxScale) * t,
    );
  }
}
