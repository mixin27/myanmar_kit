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
}
