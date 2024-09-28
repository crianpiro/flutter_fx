import 'package:flutter/material.dart';
import 'package:flutter_fx/src/fx_suit/fx_extensions.dart';

class FxCustomTextField extends StatelessWidget {
  final bool hasShadow;
  final String? label;
  final bool? autoFocus;
  final double? maxWidth;
  final Color? fillColor;
  final bool? obscureText;
  final bool? enableInput;
  final String? errorText;
  final Widget? suffixIcon;
  final EdgeInsets? margin;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final String? placeHolder;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final EdgeInsets? inputPadding;
  final TextInputType? inputType;
  final Alignment? alignment;
  final InputBorder? inputBorder;
  final BoxConstraints? constraints;
  final TextEditingController? inputController;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const FxCustomTextField({
    super.key,
    required this.inputController,
    this.constraints,
    this.hasShadow = false,
    this.placeHolder,
    this.focusNode,
    this.alignment,
    this.inputType,
    this.onChanged,
    this.onSubmitted,
    this.margin,
    this.maxWidth,
    this.inputPadding,
    this.textStyle,
    this.hintStyle,
    this.label,
    this.errorStyle,
    this.enableInput,
    this.errorText,
    this.inputBorder,
    this.autoFocus,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
  });

  final Color white = const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.center,
      child: Container(
          margin: margin ??
              EdgeInsets.symmetric(vertical: 7.0.scaleSize, horizontal: 0),
          padding: const EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            boxShadow: hasShadow
                ? [
                    const BoxShadow(
                        color: Color(0x19000000),
                        offset: Offset(0, 5),
                        blurRadius: 6,
                        spreadRadius: 0.2,
                        blurStyle: BlurStyle.normal)
                  ]
                : null,
          ),
          child: TextField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                errorText: errorText,
                alignLabelWithHint: true,
                label: (label != null) ? Text(label!) : null,
                errorStyle: textStyle,
                fillColor: fillColor ?? white,
                filled: true,
                isDense: true,
                isCollapsed: true,
                focusedBorder: inputBorder ??
                    OutlineInputBorder(
                      borderSide: BorderSide(color: fillColor ?? white),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                enabledBorder: inputBorder ??
                    OutlineInputBorder(
                      borderSide: BorderSide(color: fillColor ?? white),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                border: inputBorder ??
                    OutlineInputBorder(
                      borderSide: BorderSide(color: fillColor ?? white),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                hintText: placeHolder,
                prefixIcon: prefixIcon,
                contentPadding: inputPadding ??
                    EdgeInsets.symmetric(
                        horizontal: 15.0.scaleSize, vertical: 12.0.scaleSize),
                constraints: constraints ??
                    BoxConstraints(
                        maxWidth: 260.0.scaleSize,
                        maxHeight: 40.0.scaleSize,
                        minHeight: 40.0.scaleSize),
                prefixIconConstraints: BoxConstraints(
                    minWidth: 10.0,
                    maxWidth: 60.0,
                    maxHeight: (constraints?.maxHeight ?? 40).scaleSize),
                suffixIconConstraints: BoxConstraints(
                    minWidth: 10.0,
                    maxWidth: 60.0,
                    maxHeight: (constraints?.maxHeight ?? 40).scaleSize),
                iconColor: white,
                focusColor: white,
                hintStyle: hintStyle,
                suffixIcon: suffixIcon,
              ),
              maxLines: 1,
              cursorHeight: ((constraints?.maxHeight ?? 35) - 15).scaleSize,
              keyboardType: inputType ?? TextInputType.text,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              autofocus: autoFocus ?? false,
              obscureText: obscureText ?? false,
              focusNode: focusNode,
              controller: inputController,
              enabled: enableInput,
              style: textStyle)),
    );
  }
}
