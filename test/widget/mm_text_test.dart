import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/myanmar_kit.dart';

void main() {
  testWidgets('MMText renders plain Text for latin strings', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MMTextConfig(
          child: Scaffold(body: MMText(text: 'Hello')),
        ),
      ),
    );
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('MMText renders rich text for mixed strings', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MMTextConfig(
          child: Scaffold(body: MMText(text: 'Hello မြန်မာ')),
        ),
      ),
    );
    expect(find.byType(RichText), findsOneWidget);
  });

  testWidgets('MMText accepts fontSize directly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MMTextConfig(
          child: Scaffold(body: MMText(text: 'Hello မြန်မာ', fontSize: 24)),
        ),
      ),
    );
    expect(find.byType(RichText), findsOneWidget);
  });

  testWidgets('MMRichText accepts fontSize directly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MMTextConfig(
          child: Scaffold(
            body: MMRichText(
              textSpan: TextSpan(text: 'Hello မြန်မာ'),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    expect(find.byType(RichText), findsOneWidget);
  });

  group('textScaler is applied exactly once', () {
    // Regression tests: MMText used to bake an explicit textScaler into
    // each span's fontSize AND pass the same textScaler to the underlying
    // RichText, doubling the effect. Checking the Latin run specifically
    // keeps these tests independent of the Myanmar-vs-Latin font metric
    // ratio (which depends on which fonts are actually resolved in the
    // test environment).

    // ignore: no_leading_underscores_for_local_identifiers
    TextSpan _latinRun(WidgetTester tester) {
      final richText = tester.widget<RichText>(find.byType(RichText));
      final rootSpan = richText.text as TextSpan;
      return rootSpan.children!.cast<TextSpan>().firstWhere(
        (s) => s.text == 'Hi ',
      );
    }

    testWidgets('an explicit textScaler is not applied twice', (tester) async {
      const originalFontSize = 20.0;
      const scaleFactor = 1.5;
      await tester.pumpWidget(
        const MaterialApp(
          home: MMTextConfig(
            child: Scaffold(
              body: MMText(
                text: 'Hi မြန်',
                style: TextStyle(fontSize: originalFontSize),
                textScaler: TextScaler.linear(scaleFactor),
              ),
            ),
          ),
        ),
      );

      final latin = _latinRun(tester);
      expect(
        latin.style!.fontSize,
        closeTo(originalFontSize * scaleFactor, 0.001),
      );
    });

    testWidgets(
      'falls back to the ambient MediaQuery textScaler when none is given',
      (tester) async {
        const originalFontSize = 20.0;
        const ambientScaleFactor = 2.0;
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(ambientScaleFactor),
            ),
            child: const MaterialApp(
              home: MMTextConfig(
                child: Scaffold(
                  body: MMText(
                    text: 'Hi မြန်',
                    style: TextStyle(fontSize: originalFontSize),
                  ),
                ),
              ),
            ),
          ),
        );

        final latin = _latinRun(tester);
        expect(
          latin.style!.fontSize,
          closeTo(originalFontSize * ambientScaleFactor, 0.001),
        );
      },
    );
  });
}
