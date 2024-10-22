import 'package:flutter/material.dart';
import 'package:flutter_fx/src/fx_suite/fx_colors.dart';

/// [FxButton] is a customizable button widget with a default friendly style.
class FxButton extends StatelessWidget {
  /// The text content of the button.
  final String content;

  /// An optional widget to display instead of the text content.
  final Widget? widgetContent;

  /// The minimum size of the button.
  final Size minimumSize;

  /// The maximum size of the button.
  final Size maximumSize;

  /// The margin around the button.
  final EdgeInsets margin;

  /// The padding inside the button.
  final EdgeInsets padding;

  /// The color of the button's content.
  final Color contentColor;

  /// The color of the button's overlay.
  final Color overlayColor;

  /// The background color of the button.
  final Color backgroundColor;

  /// The color of the button's border.
  final Color borderColor;

  /// The alignment of the button's content.
  final AlignmentGeometry alignment;

  /// The radius of the button's border.
  final double borderRadius;

  /// The color of the button when it is disabled.
  final Color disabledColor;

  /// Whether the button should be compact or not.
  final bool isCompact;

  /// The style of the button's text content.
  final TextStyle? textStyle;

  /// The function to call when the button is pressed.
  final Function()? onPressedF;

  const FxButton(
      {this.content = "",
      this.widgetContent,
      this.minimumSize = const Size(30.0, 30.0),
      this.maximumSize = const Size(double.maxFinite, 50),
      this.margin = const EdgeInsets.symmetric(vertical: 1, horizontal: 26),
      this.padding =
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      this.contentColor = FxColors.white,
      this.overlayColor = FxColors.mainDark,
      this.backgroundColor = FxColors.main,
      this.borderColor = FxColors.main,
      this.alignment = Alignment.center,
      this.borderRadius = 7.0,
      this.disabledColor = FxColors.disabled,
      this.isCompact = false,
      this.textStyle,
      required this.onPressedF,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      color: FxColors.transparent,
      padding: EdgeInsets.zero,
      child: FilledButton(
          style: ButtonStyle(
              visualDensity:
                  isCompact ? VisualDensity.compact : VisualDensity.comfortable,
              alignment: alignment,
              elevation: WidgetStateProperty.resolveWith((states) => 0),
              padding: WidgetStateProperty.resolveWith((states) => padding),
              tapTargetSize: isCompact
                  ? MaterialTapTargetSize.shrinkWrap
                  : MaterialTapTargetSize.padded,
              fixedSize: !isCompact
                  ? WidgetStateProperty.resolveWith((states) => maximumSize)
                  : null,
              minimumSize:
                  WidgetStateProperty.resolveWith((states) => minimumSize),
              maximumSize:
                  WidgetStateProperty.resolveWith((states) => maximumSize),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return disabledColor;
                }
                return backgroundColor;
              }),
              foregroundColor:
                  WidgetStateProperty.resolveWith((states) => contentColor),
              overlayColor:
                  WidgetStateProperty.resolveWith((states) => overlayColor),
              shape: WidgetStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius))),
              side: WidgetStateProperty.resolveWith((states) => BorderSide(
                  color: states.contains(WidgetState.disabled)
                      ? disabledColor
                      : borderColor))),
          onPressed: onPressedF,
          child: widgetContent ??
              Text(
                content,
                style: textStyle,
              )),
    );
  }
}

/// [FxTextField] is customizable text field widget with a default friendly style.
class FxTextField extends StatelessWidget {
  /// The blur radius of the text field's shadow.
  final double shadowBlurRadius;

  /// The offset of the text field's shadow.
  final Offset shadowOffset;

  /// The label of the text field.
  final String? label;

  /// Whether the text field should autofocus or not.
  final bool? autoFocus;

  /// The background color of the text field.
  final Color backgroundColor;

  /// Whether the text field's text should be obscured or not.
  final bool? obscureText;

  /// Whether the text field is enabled for input or not.
  final bool? enableInput;

  /// The maximum number of lines for the text field.
  final int? maxLines;

  /// The error text to display for the text field.
  final String? errorText;

  /// The suffix icon to display for the text field.
  final Widget? suffixIcon;

  /// The prefix icon to display for the text field.
  final Widget? prefixIcon;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// The placeholder text to display for the text field.
  final String? placeHolder;

  /// The text style for the text field.
  final TextStyle? textStyle;

  /// The error text style for the text field.
  final TextStyle? errorStyle;

  /// The padding inside the text field.
  final EdgeInsets? inputPadding;

  /// The type of keyboard to display for the text field.
  final TextInputType? inputType;

  /// The border for the text field.
  final InputBorder? inputBorder;

  /// The maximum width for the text field.
  final double? maxWidth;

  /// The maximum height for the text field.
  final double? maxHeight;

  /// The color of the cursor.
  final Color? cursorColor;

  /// Whether the text field should auto-unfocus or not.
  final bool autoUnfocus;

  /// The margin around the text field.
  final EdgeInsetsGeometry margin;

  /// The text controller for the text field.
  final TextEditingController? inputController;

  /// The callback function for when the text field's text changes.
  final Function(String)? onChanged;

  /// The callback function for when the text field's text is submitted.
  final Function(String)? onSubmitted;

  final TextStyle defaultTextStyle =
      const TextStyle(height: 1, fontSize: 15, color: FxColors.gray);

  const FxTextField({
    super.key,
    required this.inputController,
    this.cursorColor,
    this.maxHeight,
    this.maxWidth,
    this.autoUnfocus = false,
    this.maxLines = 1,
    this.shadowBlurRadius = 10.0,
    this.shadowOffset = const Offset(0, 5),
    this.placeHolder,
    this.focusNode,
    this.inputType,
    this.onChanged,
    this.onSubmitted,
    this.inputPadding,
    this.textStyle,
    this.label,
    this.errorStyle,
    this.enableInput,
    this.errorText,
    this.inputBorder,
    this.autoFocus,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.margin = const EdgeInsets.symmetric(vertical: 5.0),
    this.backgroundColor = FxColors.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: TextField(
          textInputAction: TextInputAction.done,
          onTapOutside: (event) {
            if (autoUnfocus) {
              focusNode?.unfocus();
            }
          },
          decoration: InputDecoration(
            errorText: errorText,
            label: (label != null) ? Text(label!) : null,
            errorStyle:
                errorStyle ?? defaultTextStyle.copyWith(color: backgroundColor),
            fillColor: backgroundColor,
            filled: true,
            focusedBorder: inputBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(color: backgroundColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
            enabledBorder: inputBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(color: backgroundColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
            border: inputBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(color: backgroundColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
            isDense: true,
            contentPadding: inputPadding ??
                const EdgeInsets.symmetric(horizontal: 12.5, vertical: 12.5),
            constraints: BoxConstraints(
                maxWidth: maxWidth ?? double.maxFinite,
                minHeight: 40.0,
                maxHeight: maxHeight ?? 90.0),
            hintText: placeHolder,
            prefixIcon: prefixIcon,
            hintStyle: textStyle ?? defaultTextStyle,
            labelStyle: textStyle ?? defaultTextStyle,
            suffixIconConstraints: const BoxConstraints(maxWidth: 50.0),
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 5.0),
              child: suffixIcon,
            ),
          ),
          textCapitalization: TextCapitalization.words,
          maxLines: maxLines,
          cursorColor: cursorColor,
          cursorErrorColor: FxColors.warning,
          keyboardType: inputType ?? TextInputType.text,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          autofocus: autoFocus ?? false,
          obscureText: obscureText ?? false,
          focusNode: focusNode,
          controller: inputController,
          enabled: enableInput,
          style: textStyle ?? defaultTextStyle),
    );
  }
}

/// [FxTextButton] is a customizable text button widget with a default friendly style.
class FxTextButton extends StatelessWidget {
  /// The text content to display on the button.
  final String textContent;

  /// The text style for the button's text.
  final TextStyle? textStyle;

  /// The callback function to call when the button is pressed.
  final Function() onPressedF;

  const FxTextButton(
      {required this.textContent,
      required this.onPressedF,
      this.textStyle,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        alignment: Alignment.center,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        iconColor: WidgetStateProperty.resolveWith((states) => FxColors.main),
        padding: WidgetStateProperty.resolveWith(
            (states) => const EdgeInsets.all(5)),
        foregroundColor:
            WidgetStateProperty.resolveWith((states) => FxColors.main),
        overlayColor:
            WidgetStateProperty.resolveWith((states) => FxColors.transparent),
      ),
      onPressed: onPressedF,
      child: Text(
        textContent,
        style: textStyle,
      ),
    );
  }
}
