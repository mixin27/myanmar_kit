import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../text/font_metrics.dart';
import '../text/script_detector.dart';
import 'mm_text_config.dart';

/// A rich-text wrapper that applies Myanmar font scaling to a top-level span.
class MMRichText extends StatelessWidget {
  /// Creates a rich text widget backed by [RichText].
  const MMRichText({
    super.key,
    required this.textSpan,
    this.style,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.foreground,
    this.background,
    this.shadows,
    this.textBaseline,
    this.leadingDistribution,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.selectionRegistrar,
    this.selectionColor,
  });

  /// The text span tree to render.
  final InlineSpan textSpan;

  /// Mirrors [Text.style].
  final TextStyle? style;

  /// Mirrors [Text.style.color].
  final Color? color;

  /// Mirrors [Text.style.backgroundColor].
  final Color? backgroundColor;

  /// Mirrors [Text.style.fontSize].
  final double? fontSize;

  /// Mirrors [Text.style.fontWeight].
  final FontWeight? fontWeight;

  /// Mirrors [Text.style.fontStyle].
  final FontStyle? fontStyle;

  /// Mirrors [Text.style.letterSpacing].
  final double? letterSpacing;

  /// Mirrors [Text.style.wordSpacing].
  final double? wordSpacing;

  /// Mirrors [Text.style.height].
  final double? height;

  /// Mirrors [Text.style.decoration].
  final TextDecoration? decoration;

  /// Mirrors [Text.style.decorationColor].
  final Color? decorationColor;

  /// Mirrors [Text.style.decorationStyle].
  final TextDecorationStyle? decorationStyle;

  /// Mirrors [Text.style.decorationThickness].
  final double? decorationThickness;

  /// Mirrors [Text.style.fontFamily].
  final String? fontFamily;

  /// Mirrors [Text.style.fontFamilyFallback].
  final List<String>? fontFamilyFallback;

  /// Mirrors [Text.style.package].
  final String? package;

  /// Mirrors [Text.style.foreground].
  final Paint? foreground;

  /// Mirrors [Text.style.background].
  final Paint? background;

  /// Mirrors [Text.style.shadows].
  final List<Shadow>? shadows;

  /// Mirrors [Text.style.textBaseline].
  final TextBaseline? textBaseline;

  /// Mirrors [Text.style.leadingDistribution].
  final TextLeadingDistribution? leadingDistribution;

  /// Mirrors [TextAlign].
  final TextAlign? textAlign;

  /// Mirrors [TextDirection].
  final TextDirection? textDirection;

  /// Mirrors [Locale].
  final Locale? locale;

  /// Mirrors [Text.softWrap].
  final bool softWrap;

  /// Mirrors [TextOverflow].
  final TextOverflow overflow;

  /// Mirrors [Text.textScaler].
  final TextScaler? textScaler;

  /// Mirrors [Text.maxLines].
  final int? maxLines;

  /// Mirrors [RichText.semanticsLabel].
  final String? semanticsLabel;

  /// Mirrors [TextWidthBasis].
  final TextWidthBasis textWidthBasis;

  /// Mirrors [Text.textHeightBehavior].
  final TextHeightBehavior? textHeightBehavior;

  /// Mirrors [RichText.selectionRegistrar].
  final SelectionRegistrar? selectionRegistrar;

  /// Mirrors [RichText.selectionColor].
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final config = MMTextConfig.of(context);
    final baseStyle = _effectiveTextStyle(context);
    // Resolve the scaler the same way Text/RichText do by default (falling
    // back to the ambient MediaQuery), then bake it into every span's
    // fontSize in _scaleTextSpan. RichText itself always gets noScaling
    // below so those already-scaled sizes aren't scaled a second time.
    final resolvedTextScaler = textScaler ?? MediaQuery.textScalerOf(context);
    return RichText(
      text: _applyAmbientStyle(
        context: context,
        span: textSpan,
        config: config,
        textScaler: resolvedTextScaler,
        baseStyle: baseStyle,
      ),
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: TextScaler.noScaling,
      maxLines: maxLines,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
      selectionRegistrar: selectionRegistrar,
      selectionColor: selectionColor,
    );
  }

  TextStyle _effectiveTextStyle(BuildContext context) {
    final inheritedStyle = DefaultTextStyle.of(context).style;
    return inheritedStyle
        .merge(style)
        .copyWith(
          color: color,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          height: height,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          package: package,
          foreground: foreground,
          background: background,
          shadows: shadows,
          textBaseline: textBaseline,
          leadingDistribution: leadingDistribution,
        );
  }
}

InlineSpan _applyAmbientStyle({
  required BuildContext context,
  required InlineSpan span,
  required MMTextConfig config,
  required TextScaler textScaler,
  required TextStyle baseStyle,
}) {
  if (span is TextSpan) {
    return _scaleTextSpan(context, span, config, textScaler, baseStyle);
  }
  return span;
}

TextSpan _scaleTextSpan(
  BuildContext context,
  TextSpan span,
  MMTextConfig config,
  TextScaler textScaler,
  TextStyle baseStyle,
) {
  final mergedStyle = baseStyle.merge(span.style);
  final fontSize = mergedStyle.fontSize ?? 14;
  final fontWeight = mergedStyle.fontWeight ?? FontWeight.normal;
  final scaledBaseSize = textScaler.scale(fontSize);
  final scale = FontMetricsScaleCache.instance.getScale(
    myanmarFont: config.myanmarFont,
    latinFont: config.latinFont,
    weight: fontWeight,
    minScale: config.minScale,
    maxScale: config.maxScale,
  );
  final children = <InlineSpan>[
    if (span.text != null)
      ...splitRuns(span.text!).map((run) {
        final family =
            mergedStyle.fontFamily ??
            (run.isMyanmar ? config.myanmarFont : config.latinFont);
        final size = run.isMyanmar ? scaledBaseSize * scale : scaledBaseSize;
        return TextSpan(
          text: run.text,
          style: mergedStyle.copyWith(fontFamily: family, fontSize: size),
          recognizer: span.recognizer,
          mouseCursor: span.mouseCursor,
          semanticsLabel: span.semanticsLabel,
          locale: span.locale,
          spellOut: span.spellOut,
        );
      }),
    ...?span.children?.map((child) {
      if (child is TextSpan) {
        return _scaleTextSpan(context, child, config, textScaler, baseStyle);
      }
      return child;
    }),
  ];
  return TextSpan(
    style: mergedStyle,
    children: children,
    recognizer: span.recognizer,
    mouseCursor: span.mouseCursor,
    semanticsLabel: span.semanticsLabel,
    locale: span.locale,
    spellOut: span.spellOut,
  );
}
