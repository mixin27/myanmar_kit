# myanmar_kit

`myanmar_kit` is a Flutter package for apps that need to render, format, and
edit Myanmar text mixed with Latin text.

It focuses on:

- Myanmar-aware text sizing with `MMText`
- Grapheme-safe text utilities
- Heuristic Zawgyi detection and conversion
- Myanmar digit conversion, NRC formatting, and lightweight collation helpers
- A grapheme-safe text field wrapper

## Why this package exists

Myanmar text has a few practical problems in Flutter apps:

- Myanmar fonts often render visually taller than Latin fonts at the same size.
- Zawgyi text still appears in real-world data, even though it is not Unicode.
- Grapheme clusters should be treated atomically for editing and truncation.
- Myanmar text commonly omits spaces, which makes line breaking harder.
- Myanmar digits and NRC numbers need dedicated formatting helpers.

`myanmar_kit` packages those concerns into a small public API.

## Installation

```yaml
dependencies:
  myanmar_kit: ^0.0.1
```

## Quick Start

Set app-wide defaults with `MMTextTheme` in `ThemeData.extensions`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      MMTextTheme(
        myanmarFont: 'Noto Sans Myanmar',
        latinFont: 'Roboto',
        minScale: 0.8,
        maxScale: 1.0,
      ),
    ],
  ),
  home: const HomePage(),
);
```

Use `MMText` instead of `Text`:

```dart
MMText(
  text: 'Hello မြန်မာ',
  style: const TextStyle(fontSize: 24),
)
```

Use `MMTextField` for Myanmar-safe editing:

```dart
MMTextField(
  decoration: const InputDecoration(labelText: 'Myanmar text'),
)
```

## Public API

### Text widgets

- `MMText`
- `MMText.rich`
- `MMRichText`
- `MMTextField`
- `MMTextConfig`
- `MMTextTheme`

### Encoding

- `isLikelyZawgyi`
- `zawgyiConfidence`
- `zawgyiToUnicode`
- `unicodeToZawgyi`

### Text utilities

- `graphemeLength`
- `toGraphemeClusters`
- `safeTruncate`
- `insertBreakHints`

### Formatting

- `toMyanmarDigits`
- `toArabicDigits`
- `compareMyanmar`
- `isValidNrc`
- `formatNrc`

## Known limitations

- Zawgyi detection is heuristic, not deterministic.
- Zawgyi conversion is a best-effort ordered mapping, not a full linguistic
  engine.
- The line-breaking helper inserts hints heuristically and is not ICU-grade.
- Myanmar collation here is lightweight and does not replace full ICU collation.
- Font-metric scaling depends on the requested fonts being loaded and available.

## Example

Run the example app in `example/lib/main.dart` to see side-by-side comparisons
and utility outputs.
