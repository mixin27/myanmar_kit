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
}
