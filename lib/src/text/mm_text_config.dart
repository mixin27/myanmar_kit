import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'font_metrics.dart';
import 'mm_text_theme.dart';

/// Ambient configuration for `myanmar_kit` text widgets.
class MMTextConfig extends InheritedWidget {
  /// Creates an ambient font configuration.
  const MMTextConfig({
    super.key,
    required super.child,
    this.myanmarFont = 'Noto Sans Myanmar',
    this.latinFont = 'Roboto',
    this.minScale = 0.8,
    this.maxScale = 1.0,
  });

  /// Font family used for Myanmar script runs.
  final String myanmarFont;

  /// Font family used for Latin script runs.
  final String latinFont;

  /// Minimum allowed scale factor for Myanmar text.
  final double minScale;

  /// Maximum allowed scale factor for Myanmar text.
  final double maxScale;

  /// Returns the nearest [MMTextConfig] or a built-in default.
  static MMTextConfig of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<MMTextConfig>();
    if (inherited != null) {
      return inherited;
    }
    final theme = Theme.of(context).extension<MMTextTheme>();
    if (theme != null) {
      return MMTextConfig(
        myanmarFont: theme.myanmarFont,
        latinFont: theme.latinFont,
        minScale: theme.minScale,
        maxScale: theme.maxScale,
        child: const SizedBox.shrink(),
      );
    }
    return MMTextConfig.adaptive(child: const SizedBox.shrink());
  }

  /// Creates a platform-aware default font configuration.
  ///
  /// This is a better out-of-the-box choice than hard-coding font families that
  /// may not exist on the current device.
  MMTextConfig.adaptive({
    super.key,
    required super.child,
    this.minScale = 0.8,
    this.maxScale = 1.0,
  }) : myanmarFont = switch (defaultTargetPlatform) {
         TargetPlatform.iOS || TargetPlatform.macOS => 'Myanmar Sangam MN',
         _ => 'Noto Sans Myanmar',
       },
       latinFont = switch (defaultTargetPlatform) {
         TargetPlatform.iOS || TargetPlatform.macOS => 'Helvetica Neue',
         _ => 'Roboto',
       };

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
  bool updateShouldNotify(MMTextConfig oldWidget) {
    return oldWidget.myanmarFont != myanmarFont ||
        oldWidget.latinFont != latinFont ||
        oldWidget.minScale != minScale ||
        oldWidget.maxScale != maxScale;
  }
}
