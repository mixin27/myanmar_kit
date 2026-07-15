import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/myanmar_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MMTextConfig resolves theme extension values', (tester) async {
    late MMTextConfig resolvedConfig;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const [
            MMTextTheme(
              myanmarFont: 'Demo Myanmar',
              latinFont: 'Demo Latin',
              minScale: 0.9,
              maxScale: 1.05,
            ),
          ],
        ),
        home: Builder(
          builder: (context) {
            resolvedConfig = MMTextConfig.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolvedConfig.myanmarFont, 'Demo Myanmar');
    expect(resolvedConfig.latinFont, 'Demo Latin');
    expect(resolvedConfig.minScale, closeTo(0.9, 0.0001));
    expect(resolvedConfig.maxScale, closeTo(1.05, 0.0001));
  });
}
