import 'dart:ui';
import 'package:flutter/widgets.dart';

extension FxScaleSize on double {
  static final FlutterView _window =
      WidgetsBinding.instance.platformDispatcher.views.single;

  static final Size _logicalSize =
      _window.physicalSize / _window.devicePixelRatio;

  static final ViewPadding _windowPadding =
      WidgetsBinding.instance.platformDispatcher.views.single.viewPadding;

  static double targetViewportWidth = 414;
  static double targetViewportHeight = 896;

  double get scaleSize => _getHorizontalSize(this);
  double get scaleVerticalSize => _getVerticalSize(this);

  static const double _mobileWidth = 414;

  static const double _tabletWidth = 768;
  static const double _tabletHeight = 924;

  static const double _desktopWidth = 1024;
  static const double _desktopHeight = 900;

  bool get isDesktop =>
      _logicalSize.width >= _desktopWidth &&
      _logicalSize.height >= _desktopHeight;

  bool get isTablet =>
      _logicalSize.width >= _tabletWidth &&
      _logicalSize.height >= _tabletHeight &&
      !isDesktop;

  bool get isTabletLandscape =>
      _isLandscape &&
      _logicalSize.width >= _tabletHeight &&
      _logicalSize.height >= _tabletWidth;

  bool get isMobile =>
      _logicalSize.width < _tabletWidth && _logicalSize.height < _tabletHeight;

  bool get isMobileLandscape =>
      _isLandscape && _logicalSize.height < _tabletWidth;

  bool get _isLandscape => _logicalSize.width > _logicalSize.height;

  /// This function takes a horizontal size in pixels and scales it to the
  /// size of the device's screen width.
  ///
  /// The function first calculates the target proportion of the screen width
  /// to the target viewport width. This is done by subtracting the view padding
  /// from the logical screen width and then dividing the result by the
  /// target viewport width.
  ///
  /// If the target proportion is greater than 1.1, the function then checks
  /// the type of device and scales the size accordingly. If the device is a
  /// desktop, the size is scaled to the desktop width. If the device is a
  /// tablet or in landscape mode, the size is scaled to the tablet width.
  /// If the device is a mobile or in landscape mode, the size is scaled to
  /// the mobile width.
  ///
  /// If the target proportion is not greater than 1.1, the size is scaled
  /// by the target proportion.
  double _getHorizontalSize(double px) {
    final double viewPaddings =
        (_windowPadding.left + _windowPadding.right) / _window.devicePixelRatio;
    final double screenWidth = _logicalSize.width - viewPaddings;

    double proportion = (screenWidth / targetViewportWidth);
    double scaled = px * proportion;

    if (proportion > 1.1) {
      if (isDesktop) {
        proportion = screenWidth / _desktopWidth; 
        scaled = px * proportion;
      } else if (isTablet || isTabletLandscape) {
        proportion = screenWidth / _tabletWidth; 
        scaled = px * proportion;
      } else if (isMobile || isMobileLandscape) {
        proportion = screenWidth / _mobileWidth; 
        scaled = px * proportion;
      }

      if (proportion > 1.1) {
        return px * 1;
      }
    }

    return scaled;
  }

  /// This function takes a vertical size in pixels and scales it to the
  /// size of the device's screen height.
  ///
  /// The function first calculates the target proportion of the screen height
  /// to the target viewport height. This is done by subtracting the view padding
  /// from the logical screen height and then dividing the result by the
  /// target viewport height.
  ///
  /// If the target proportion is greater than 1.2, the function returns 1.
  /// Otherwise, the size is scaled by the target proportion.
  double _getVerticalSize(double px) {
    final double viewPaddings =
        (_windowPadding.top + _windowPadding.bottom) / _window.devicePixelRatio;
    final double screenHeight = _logicalSize.height - viewPaddings;

    double targetProportion = (screenHeight / targetViewportHeight);
    double scaled = px * targetProportion;

    if (targetProportion > 1.2) {
      return 1;
    }

    return scaled;
  }
}
