import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/src/text/mm_text_field.dart';

void main() {
  test('formatter preserves composing text and caret position', () {
    final formatter = MyanmarGraphemeFormatter();
    final value = formatter.formatEditUpdate(
      const TextEditingValue(text: ''),
      const TextEditingValue(
        text: 'Hello',
        selection: TextSelection.collapsed(offset: 5),
        composing: TextRange(start: 0, end: 5),
      ),
    );
    expect(value.text, 'Hello');
    expect(value.selection.baseOffset, 5);
    expect(value.selection.extentOffset, 5);
    expect(value.composing, const TextRange(start: 0, end: 5));
  });

  test('formatter keeps Myanmar text intact', () {
    final formatter = MyanmarGraphemeFormatter();
    final value = formatter.formatEditUpdate(
      const TextEditingValue(text: ''),
      const TextEditingValue(
        text: 'မြန်မာ',
        selection: TextSelection.collapsed(offset: 6),
      ),
    );
    expect(value.text, 'မြန်မာ');
    expect(value.selection.baseOffset, 6);
  });

  test('formatter preserves boundaries between latin and Myanmar text', () {
    final formatter = MyanmarGraphemeFormatter();
    final value = formatter.formatEditUpdate(
      const TextEditingValue(text: 'Hell မြန်မာ'),
      const TextEditingValue(
        text: 'Hell မြန်မာ',
        selection: TextSelection.collapsed(offset: 4),
      ),
    );
    expect(value.selection.baseOffset, 4);
  });

  testWidgets('MMTextField accepts fontSize directly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MMTextField(fontSize: 18, decoration: InputDecoration()),
        ),
      ),
    );
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('MMTextField passes through common text field knobs', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MMTextField(
            decoration: InputDecoration(),
            obscureText: true,
            obscuringCharacter: 'x',
            keyboardAppearance: Brightness.dark,
            enableIMEPersonalizedLearning: false,
            cursorOpacityAnimates: true,
            mouseCursor: SystemMouseCursors.text,
          ),
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
    expect(field.obscuringCharacter, 'x');
    expect(field.keyboardAppearance, Brightness.dark);
    expect(field.enableIMEPersonalizedLearning, isFalse);
    expect(field.cursorOpacityAnimates, isTrue);
    expect(field.mouseCursor, SystemMouseCursors.text);
  });
}
