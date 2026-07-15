import 'package:flutter/widgets.dart';

import '../text/font_metrics.dart';
import '../text/script_detector.dart';
import 'mm_text_config.dart';
import 'mm_rich_text.dart';

/// A drop-in text widget that scales Myanmar script runs to match Latin text.
class MMText extends StatelessWidget {
  /// Creates a `MMText` widget.
  const MMText({
    super.key,
    required this.text,
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
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : textSpan = null;

  /// Creates a rich-text variant of `MMText`.
  const MMText.rich(
    this.textSpan, {
    super.key,
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
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : text = null,
       strutStyle = null;

  /// Plain text to render.
  final String? text;

  /// Rich text span tree to render.
  final InlineSpan? textSpan;

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

  /// Mirrors [Text.strutStyle].
  final StrutStyle? strutStyle;

  /// Mirrors [Text.textAlign].
  final TextAlign? textAlign;

  /// Mirrors [Text.textDirection].
  final TextDirection? textDirection;

  /// Mirrors [Text.locale].
  final Locale? locale;

  /// Mirrors [Text.softWrap].
  final bool? softWrap;

  /// Mirrors [Text.overflow].
  final TextOverflow? overflow;

  /// Mirrors [Text.textScaler].
  final TextScaler? textScaler;

  /// Mirrors [Text.maxLines].
  final int? maxLines;

  /// Mirrors [Text.semanticsLabel].
  final String? semanticsLabel;

  /// Mirrors [Text.textWidthBasis].
  final TextWidthBasis? textWidthBasis;

  /// Mirrors [Text.textHeightBehavior].
  final TextHeightBehavior? textHeightBehavior;

  /// Mirrors [Text.selectionColor].
  final Color? selectionColor;

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

  @override
  Widget build(BuildContext context) {
    if (textSpan != null) {
      return MMRichText(
        textSpan: textSpan!,
        style: style,
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
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.clip,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    }

    final value = text ?? '';
    final effectiveTextStyle = _effectiveTextStyle(context);
    if (!containsMyanmar(value)) {
      return Text(
        value,
        style: effectiveTextStyle,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    }

    final config = MMTextConfig.of(context);
    // Resolve the scaler the same way Text/RichText do by default (falling
    // back to the ambient MediaQuery) so MMText keeps respecting the
    // platform's accessibility text-size setting even when the caller
    // doesn't pass textScaler explicitly. The resolved scaler is baked into
    // effectiveFontSize below, so it must be applied here exactly once —
    // RichText itself is always given TextScaler.noScaling further down to
    // avoid scaling these already-scaled sizes a second time.
    final resolvedTextScaler = textScaler ?? MediaQuery.textScalerOf(context);
    final effectiveFontSize = resolvedTextScaler.scale(
      effectiveTextStyle.fontSize ?? 14,
    );
    final effectiveStrut =
        strutStyle ??
        StrutStyle.fromTextStyle(effectiveTextStyle, forceStrutHeight: true);
    final scale = FontMetricsScaleCache.instance.getScale(
      myanmarFont: config.myanmarFont,
      latinFont: config.latinFont,
      weight: effectiveTextStyle.fontWeight ?? FontWeight.normal,
      minScale: config.minScale,
      maxScale: config.maxScale,
    );
    final hasMyanmarOverride = effectiveTextStyle.fontFamily != null;
    final children = splitRuns(value)
        .map((run) {
          final family = hasMyanmarOverride
              ? effectiveTextStyle.fontFamily
              : (run.isMyanmar ? config.myanmarFont : config.latinFont);
          final size = effectiveFontSize * (run.isMyanmar ? scale : 1);
          return TextSpan(
            text: run.text,
            style: effectiveTextStyle.copyWith(
              fontFamily: family,
              fontSize: size,
            ),
          );
        })
        .toList(growable: false);

    final richText = RichText(
      text: TextSpan(style: effectiveTextStyle, children: children),
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      locale: locale,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      // Always noScaling: resolvedTextScaler was already baked into every
      // span's fontSize above. Passing a non-identity scaler here as well
      // would apply it a second time.
      textScaler: TextScaler.noScaling,
      maxLines: maxLines,
      strutStyle: effectiveStrut,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
    return semanticsLabel == null
        ? richText
        : Semantics(label: semanticsLabel, child: richText);
  }
}
