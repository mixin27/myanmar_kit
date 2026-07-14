import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_kit/src/formatting/mm_collator.dart';
import 'package:myanmar_kit/src/formatting/mm_numerals.dart';
import 'package:myanmar_kit/src/formatting/nrc_formatter.dart';

void main() {
  test('digit conversion handles mixed strings', () {
    expect(toMyanmarDigits('Room 12'), 'Room ၁၂');
    expect(toArabicDigits('၁၂၃abc'), '123abc');
  });

  test('collator provides stable ordering', () {
    expect(compareMyanmar('က', 'ခ'), lessThan(0));
  });

  test('NRC formatter normalizes formatting', () {
    expect(formatNrc('12 / mahta na (n) 123456'), '12/MAHTANA(N)123456');
    expect(isValidNrc('12/MAHTANA(N)123456'), isTrue);
  });
}
