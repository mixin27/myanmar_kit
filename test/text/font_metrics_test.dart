import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/src/text/font_metrics.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('font metric scale is clamped and cached', () {
    final first = FontMetricsScaleCache.instance.getScale(
      myanmarFont: 'Roboto',
      latinFont: 'Roboto',
      weight: FontWeight.normal,
    );
    final second = FontMetricsScaleCache.instance.getScale(
      myanmarFont: 'Roboto',
      latinFont: 'Roboto',
      weight: FontWeight.normal,
    );
    expect(first, closeTo(second, 0.0001));
    expect(first, inInclusiveRange(0.8, 1.0));
  });

  test(
    'cache key includes minScale/maxScale so different configs do not collide',
    () {
      // Regression test: the cache key used to be (font, font, weight) only,
      // so whichever MMTextConfig computed a scale for a given font pairing
      // first would "poison" the cached value for every other config using
      // the same font pairing but a different clamp range.
      //
      // Two disjoint, narrow clamp ranges guarantee each call must be
      // clamped into its own distinct range, regardless of what the raw
      // unclamped ratio happens to be in the test environment.
      final narrow = FontMetricsScaleCache.instance.getScale(
        myanmarFont: 'Arial',
        latinFont: 'Arial',
        weight: FontWeight.w300,
        minScale: 0.30,
        maxScale: 0.35,
      );
      final wide = FontMetricsScaleCache.instance.getScale(
        myanmarFont: 'Arial',
        latinFont: 'Arial',
        weight: FontWeight.w300,
        minScale: 0.60,
        maxScale: 0.65,
      );
      expect(narrow, inInclusiveRange(0.30, 0.35));
      expect(wide, inInclusiveRange(0.60, 0.65));
      expect(narrow, isNot(closeTo(wide, 0.001)));
    },
  );

  test('invalidate clears only the targeted cache entry', () {
    final untouchedBefore = FontMetricsScaleCache.instance.getScale(
      myanmarFont: 'Georgia',
      latinFont: 'Georgia',
      weight: FontWeight.w600,
      minScale: 0.4,
      maxScale: 0.45,
    );
    FontMetricsScaleCache.instance.getScale(
      myanmarFont: 'Georgia',
      latinFont: 'Georgia',
      weight: FontWeight.w500,
      minScale: 0.4,
      maxScale: 0.45,
    );

    FontMetricsScaleCache.instance.invalidate(
      myanmarFont: 'Georgia',
      latinFont: 'Georgia',
      weight: FontWeight.w500,
      minScale: 0.4,
      maxScale: 0.45,
    );

    final recomputed = FontMetricsScaleCache.instance.getScale(
      myanmarFont: 'Georgia',
      latinFont: 'Georgia',
      weight: FontWeight.w500,
      minScale: 0.4,
      maxScale: 0.45,
    );
    final untouchedAfter = FontMetricsScaleCache.instance.getScale(
      myanmarFont: 'Georgia',
      latinFont: 'Georgia',
      weight: FontWeight.w600,
      minScale: 0.4,
      maxScale: 0.45,
    );

    expect(recomputed, inInclusiveRange(0.4, 0.45));
    // The untouched weight-600 entry must be unaffected by invalidating the
    // weight-500 entry.
    expect(untouchedAfter, untouchedBefore);
  });

  test('clear() forces every entry to be recomputed on next access', () {
    FontMetricsScaleCache.instance.getScale(
      myanmarFont: 'Verdana',
      latinFont: 'Verdana',
      weight: FontWeight.w400,
      minScale: 0.5,
      maxScale: 0.55,
    );
    FontMetricsScaleCache.instance.clear();
    final afterClear = FontMetricsScaleCache.instance.getScale(
      myanmarFont: 'Verdana',
      latinFont: 'Verdana',
      weight: FontWeight.w400,
      minScale: 0.5,
      maxScale: 0.55,
    );
    expect(afterClear, inInclusiveRange(0.5, 0.55));
  });
}
