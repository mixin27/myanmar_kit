import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text field that keeps Myanmar grapheme clusters intact when editing.
class MMTextField extends StatelessWidget {
  /// Creates a Myanmar-safe text field.
  const MMTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decorationText,
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
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.keyboardAppearance,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.enableIMEPersonalizedLearning = true,
    this.cursorOpacityAnimates,
    this.mouseCursor,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionControls,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.scrollPhysics,
    this.scrollController,
    this.autofillHints,
    this.restorationId,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.forceErrorText,
  });

  /// Mirrors [TextField.controller].
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decorationText;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final String? package;
  final Paint? foreground;
  final Paint? background;
  final List<Shadow>? shadows;
  final TextBaseline? textBaseline;
  final TextLeadingDistribution? leadingDistribution;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final bool? showCursor;
  final bool autofocus;
  final Brightness? keyboardAppearance;
  final bool obscureText;
  final String obscuringCharacter;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final bool enableIMEPersonalizedLearning;
  final bool? cursorOpacityAnimates;
  final MouseCursor? mouseCursor;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final TextSelectionControls? selectionControls;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final String? forceErrorText;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = _effectiveTextStyle(context);
    final formatters = <TextInputFormatter>[
      ...?inputFormatters,
      MyanmarGraphemeFormatter(),
    ];
    final useFormField =
        validator != null || onSaved != null || forceErrorText != null;
    if (useFormField) {
      return TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: decoration,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        style: effectiveStyle,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        textDirection: textDirection,
        readOnly: readOnly,
        showCursor: showCursor,
        autofocus: autofocus,
        keyboardAppearance: keyboardAppearance,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        autocorrect: autocorrect,
        smartDashesType: smartDashesType,
        smartQuotesType: smartQuotesType,
        enableSuggestions: enableSuggestions,
        enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
        cursorOpacityAnimates: cursorOpacityAnimates,
        mouseCursor: mouseCursor,
        maxLines: maxLines,
        minLines: minLines,
        expands: expands,
        maxLength: maxLength,
        maxLengthEnforcement: maxLengthEnforcement,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        inputFormatters: formatters,
        enabled: enabled,
        cursorWidth: cursorWidth,
        cursorHeight: cursorHeight,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        cursorErrorColor: cursorErrorColor,
        selectionControls: selectionControls,
        scrollPadding: scrollPadding,
        enableInteractiveSelection: enableInteractiveSelection,
        scrollPhysics: scrollPhysics,
        scrollController: scrollController,
        autofillHints: autofillHints,
        restorationId: restorationId,
        validator: validator,
        onSaved: onSaved,
        autovalidateMode: autovalidateMode,
        forceErrorText: forceErrorText,
      );
    }
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: effectiveStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      keyboardAppearance: keyboardAppearance,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      cursorOpacityAnimates: cursorOpacityAnimates,
      mouseCursor: mouseCursor,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      inputFormatters: formatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      cursorErrorColor: cursorErrorColor,
      selectionControls: selectionControls,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      scrollPhysics: scrollPhysics,
      scrollController: scrollController,
      autofillHints: autofillHints,
      restorationId: restorationId,
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
          decoration: decorationText,
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

class MyanmarGraphemeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final selection = _snapSelection(newValue.text, newValue.selection);
    return TextEditingValue(
      text: newValue.text,
      selection: selection,
      composing: newValue.composing,
    );
  }

  TextSelection _snapSelection(String text, TextSelection selection) {
    int snap(int offset) {
      if (offset <= 0) {
        return 0;
      }
      var current = 0;
      for (final cluster in text.characters) {
        final next = current + cluster.length;
        if (offset == current || offset == next) {
          return offset;
        }
        if (offset > current && offset < next) {
          return current;
        }
        current = next;
      }
      return text.length;
    }

    return selection.copyWith(
      baseOffset: snap(selection.baseOffset),
      extentOffset: snap(selection.extentOffset),
    );
  }
}
