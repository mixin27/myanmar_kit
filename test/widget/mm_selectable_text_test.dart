import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/myanmar_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MMSelectableText renders a selectable text widget', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MMTextConfig(
          child: Scaffold(body: MMSelectableText(text: 'Hello မြန်မာ')),
        ),
      ),
    );

    expect(find.byType(SelectableText), findsOneWidget);
  });

  testWidgets('MMSelectableText accepts fontSize directly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MMTextConfig(
          child: Scaffold(
            body: MMSelectableText.rich(
              TextSpan(text: 'Hello မြန်မာ'),
              fontSize: 24,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SelectableText), findsOneWidget);
  });

  testWidgets('MMSelectableText accepts textHeightBehavior directly', (
    tester,
  ) async {
    const behavior = TextHeightBehavior(
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: false,
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: MMTextConfig(
          child: Scaffold(
            body: MMSelectableText(text: 'Hello', textHeightBehavior: behavior),
          ),
        ),
      ),
    );

    final selectable = tester.widget<SelectableText>(
      find.byType(SelectableText),
    );
    expect(selectable.textHeightBehavior, behavior);
  });
}
