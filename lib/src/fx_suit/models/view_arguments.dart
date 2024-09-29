import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

@immutable
final class ViewArguments {
  final SystemUiOverlayStyle uiOverlayStyle;
  final Color scaffoldBackgroundColor;
  final bool extendBodyBehindAppBar;
  final bool extendBodyBehindNavBar;
  final bool applyViewPaddings;
  final bool applyBacklayerPaddings;
  final bool resizeToAvoidBottomInset;
  const ViewArguments(
      {this.uiOverlayStyle = const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Color(0x00000000),
        systemNavigationBarColor: Color(0x00000000),
      ),
      this.scaffoldBackgroundColor = const Color.fromARGB(255, 255, 255, 255),
      this.applyViewPaddings = true,
      this.applyBacklayerPaddings = false,
      this.extendBodyBehindAppBar = false,
      this.extendBodyBehindNavBar = false,
      this.resizeToAvoidBottomInset = false});
}
