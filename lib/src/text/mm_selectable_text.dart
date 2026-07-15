import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../text/font_metrics.dart';
import '../text/script_detector.dart';
import 'mm_text_config.dart';

/// A selectable text widget that scales Myanmar script runs to match Latin text.
class MMSelectableText extends StatelessWidget {
  /// Creates a selectable `MMSelectableText` widget.
  const MMSelectableText({
    super.key,
    required this.text,
    this.focusNode,
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
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.scrollBehavior,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
  }) : textSpan = null;

  /// Creates a rich-text selectable variant of `MMSelectableText`.
  const MMSelectableText.rich(
    this.textSpan, {
    super.key,
    this.focusNode,
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
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.scrollBehavior,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
  }) : text = null;

  /// Plain text to render.
  final String? text;

  /// Rich text span tree to render.
  final InlineSpan? textSpan;

  /// Mirrors [TextField.focusNode].
  final FocusNode? focusNode;

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

  /// Mirrors [Text.textScaler].
  final TextScaler? textScaler;

  /// Mirrors [SelectableText.showCursor].
  final bool showCursor;

  /// Mirrors [SelectableText.autofocus].
  final bool autofocus;

  /// Mirrors [SelectableText.minLines].
  final int? minLines;

  /// Mirrors [SelectableText.maxLines].
  final int? maxLines;

  /// Mirrors [SelectableText.cursorWidth].
  final double cursorWidth;

  /// Mirrors [SelectableText.cursorHeight].
  final double? cursorHeight;

  /// Mirrors [SelectableText.cursorRadius].
  final Radius? cursorRadius;

  /// Mirrors [SelectableText.cursorColor].
  final Color? cursorColor;

  /// Mirrors [SelectableText.selectionColor].
  final Color? selectionColor;

  /// Mirrors [SelectableText.selectionHeightStyle].
  final ui.BoxHeightStyle? selectionHeightStyle;

  /// Mirrors [SelectableText.selectionWidthStyle].
  final ui.BoxWidthStyle? selectionWidthStyle;

  /// Mirrors [SelectableText.dragStartBehavior].
  final DragStartBehavior dragStartBehavior;

  /// Mirrors [SelectableText.enableInteractiveSelection].
  final bool enableInteractiveSelection;

  /// Mirrors [SelectableText.selectionControls].
  final TextSelectionControls? selectionControls;

  /// Mirrors [SelectableText.onTap].
  final GestureTapCallback? onTap;

  /// Mirrors [SelectableText.scrollPhysics].
  final ScrollPhysics? scrollPhysics;

  /// Mirrors [SelectableText.scrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// Mirrors [SelectableText.semanticsLabel].
  final String? semanticsLabel;

  /// Mirrors [SelectableText.textHeightBehavior].
  final TextHeightBehavior? textHeightBehavior;

  /// Mirrors [SelectableText.textWidthBasis].
  final TextWidthBasis? textWidthBasis;

  /// Mirrors [SelectableText.onSelectionChanged].
  final SelectionChangedCallback? onSelectionChanged;

  /// Mirrors [SelectableText.contextMenuBuilder].
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Mirrors [SelectableText.magnifierConfiguration].
  final TextMagnifierConfiguration? magnifierConfiguration;

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
      return _buildSelectableRichText(context, textSpan!);
    }

    final value = text ?? '';
    final effectiveTextStyle = _effectiveTextStyle(context);
    if (!containsMyanmar(value)) {
      return SelectableText(
        value,
        focusNode: focusNode,
        style: effectiveTextStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        textScaler: textScaler,
        showCursor: showCursor,
        autofocus: autofocus,
        minLines: minLines,
        maxLines: maxLines,
        cursorWidth: cursorWidth,
        cursorHeight: cursorHeight,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        selectionColor: selectionColor,
        selectionHeightStyle: selectionHeightStyle,
        selectionWidthStyle: selectionWidthStyle,
        dragStartBehavior: dragStartBehavior,
        enableInteractiveSelection: enableInteractiveSelection,
        selectionControls: selectionControls,
        onTap: onTap,
        scrollPhysics: scrollPhysics,
        scrollBehavior: scrollBehavior,
        semanticsLabel: semanticsLabel,
        textHeightBehavior: textHeightBehavior,
        textWidthBasis: textWidthBasis,
        onSelectionChanged: onSelectionChanged,
        contextMenuBuilder: contextMenuBuilder,
        magnifierConfiguration: magnifierConfiguration,
      );
    }

    return _buildSelectableRichText(
      context,
      TextSpan(text: value, style: effectiveTextStyle),
    );
  }

  Widget _buildSelectableRichText(BuildContext context, InlineSpan rootSpan) {
    final config = MMTextConfig.of(context);
    final baseStyle = _effectiveTextStyle(context);
    final resolvedTextScaler = textScaler ?? MediaQuery.textScalerOf(context);
    return SelectableText.rich(
      _asTextSpan(
        _applyAmbientStyle(
          context: context,
          span: rootSpan,
          config: config,
          textScaler: resolvedTextScaler,
          baseStyle: baseStyle,
        ),
      ),
      focusNode: focusNode,
      style: baseStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: TextScaler.noScaling,
      showCursor: showCursor,
      autofocus: autofocus,
      minLines: minLines,
      maxLines: maxLines,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionColor: selectionColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTap: onTap,
      scrollPhysics: scrollPhysics,
      scrollBehavior: scrollBehavior,
      semanticsLabel: semanticsLabel,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      onSelectionChanged: onSelectionChanged,
      contextMenuBuilder: contextMenuBuilder,
      magnifierConfiguration: magnifierConfiguration,
    );
  }
}

TextSpan _asTextSpan(InlineSpan span) {
  return span is TextSpan ? span : TextSpan(children: [span]);
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
