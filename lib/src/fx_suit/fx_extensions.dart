import 'dart:ui';
import 'package:flutter/widgets.dart';

extension ScaleSize on double {
  static final FlutterView _window =
      WidgetsBinding.instance.platformDispatcher.views.single;

  static final Size _logicalSize =
      _window.physicalSize / _window.devicePixelRatio;

  static final ViewPadding _windowPadding =
      WidgetsBinding.instance.platformDispatcher.views.single.viewPadding;

  static double viewPortSize = 414;

  double get scaleSize => _getHorizontalSize(this);
  double get scaleVerticalSize => _getVerticalSize(this);

  /// This function scales a size given in pixels to a size scaled to the width
  /// of the current screen. The width of the screen is defined as the logical
  /// width of the screen minus the total horizontal padding of the screen.
  double _getHorizontalSize(double px) {
    final double viewPaddings =
        (_windowPadding.left + _windowPadding.right) / _window.devicePixelRatio;
    final double screenWidth = _logicalSize.width - viewPaddings;
    return px * (screenWidth / viewPortSize);
  }

  /// This function scales a size given in pixels to a size scaled to the height
  /// of the current screen. The height of the screen is defined as the logical
  /// height of the screen minus the total vertical padding of the screen.
  double _getVerticalSize(double px) {
    final double viewPaddings =
        (_windowPadding.top + _windowPadding.bottom) / _window.devicePixelRatio;
    final double screenHeight = _logicalSize.height - viewPaddings;
    return px * (screenHeight / viewPortSize);
  }
}
