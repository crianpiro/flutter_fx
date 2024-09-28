import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FxCustomTextField extends StatelessWidget {
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final String? label;
  final bool? autoFocus;
  final Color backgroundColor;
  final bool? obscureText;
  final bool? enableInput;
  final int? maxLines;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final String? placeHolder;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final EdgeInsets? inputPadding;
  final TextInputType? inputType;
  final InputBorder? inputBorder;
  final double? maxWidth;
  final double? maxHeight;
  final Color? cursorColor;
  final bool autoUnfocus;
  final EdgeInsetsGeometry margin;
  final TextEditingController? inputController;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  final TextStyle defaultTextStyle = const TextStyle(
      height: 1, fontSize: 15, color: Color.fromARGB(255, 204, 204, 204));

  const FxCustomTextField({
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
    this.backgroundColor = const Color.fromARGB(255, 96, 96, 96),
  });

  final Color warning = const Color.fromARGB(255, 124, 42, 42);
  final Color black = const Color.fromARGB(255, 0, 0, 0);
  final Color white = const Color.fromARGB(255, 255, 255, 255);

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
            errorStyle: errorStyle ?? defaultTextStyle.copyWith(color: warning),
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
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
            constraints: BoxConstraints(
                maxWidth: maxWidth ?? double.maxFinite,
                minHeight: 40.0,
                maxHeight: maxHeight ?? 90.0),
            hintText: placeHolder,
            prefixIcon: prefixIcon,
            hintStyle: textStyle ?? defaultTextStyle,
            labelStyle: textStyle ?? defaultTextStyle,
            suffixIconConstraints: const BoxConstraints(maxWidth: 60.0),
            iconColor: white,
            suffixIcon: suffixIcon,
          ),
          textCapitalization: TextCapitalization.words,
          maxLines: maxLines,
          cursorColor: cursorColor,
          cursorErrorColor: warning,
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
