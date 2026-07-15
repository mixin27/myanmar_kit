/// `myanmar_kit` is a Flutter package for rendering and editing Myanmar text
/// mixed with Latin text.
///
/// The package focuses on practical text handling for real apps:
///
/// - Myanmar-aware text sizing with `MMText` and `MMRichText`
/// - Grapheme-safe text editing with `MMTextField`
/// - Ambient font configuration with `MMTextConfig`
/// - Zawgyi detection and conversion helpers
/// - Myanmar digit conversion, NRC formatting, and light collation helpers
/// - Grapheme-aware truncation and line-break helpers
///
/// ## Quick start
///
/// Set app-wide defaults with [MMTextTheme] in `ThemeData.extensions`, or wrap
/// a subtree with [MMTextConfig] if you prefer an inherited widget:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       MMTextTheme(
///         myanmarFont: 'Noto Sans Myanmar',
///         latinFont: 'Roboto',
///       ),
///     ],
///   ),
///   home: Scaffold(
///     body: Center(
///       child: MMText(
///         text: 'Hello မြန်မာ',
///         fontSize: 18,
///       ),
///     ),
///   ),
/// );
/// ```
///
/// For rich text, use [MMText.rich] or [MMRichText]. For editing, use
/// [MMTextField] so Myanmar grapheme clusters stay intact. [MMTextConfig]
/// remains available for local overrides and runtime inspection.
///
/// See the example app for a news-style demo with live `MMTextConfig`
/// controls and mixed-script article content.
library;

export 'src/encoding/zawgyi_converter.dart';
export 'src/encoding/zawgyi_detector.dart';
export 'src/formatting/mm_collator.dart';
export 'src/formatting/mm_numerals.dart';
export 'src/formatting/nrc_formatter.dart';
export 'src/text/mm_rich_text.dart';
export 'src/text/mm_text.dart';
export 'src/text/mm_text_config.dart';
export 'src/text/mm_text_theme.dart';
export 'src/text/mm_text_field.dart';
export 'src/text_utils/grapheme_utils.dart';
export 'src/text_utils/line_breaker.dart';
