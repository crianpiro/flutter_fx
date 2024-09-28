import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

@immutable
final class ViewArguments {
  final SystemUiOverlayStyle uiOverlayStyle;
  final bool extendBodyBehindAppBar;
  final bool extendBodyBehindNavBar;
  final bool applyViewPaddings;
  final bool resizeToAvoidBottomInset;
  const ViewArguments(
      {required this.uiOverlayStyle,
      this.applyViewPaddings = true,
      this.extendBodyBehindAppBar = false,
      this.extendBodyBehindNavBar = false,
      this.resizeToAvoidBottomInset = false});
}
