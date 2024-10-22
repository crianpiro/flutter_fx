import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
final class FxScreen extends StatelessWidget {
  final Widget Function(BuildContext context, EdgeInsets screenPadding)
      screenBuilder;
  final Widget Function(BuildContext context, EdgeInsets screenPadding)?
      screenBackgroundBuilder;
  final Widget Function(BuildContext context)? screenOverlayBuilder;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final SystemUiOverlayStyle uiOverlayStyle;
  final Color? scaffoldBackgroundColor;
  final bool extendBodyBehindAppBar;
  final bool extendBodyBehindNavBar;
  final bool encapsulateScreen;
  final bool encapsulateBackground;
  final bool resizeToAvoidBottomInset;

  const FxScreen(
      {required this.screenBuilder,
      this.screenBackgroundBuilder,
      this.screenOverlayBuilder,
      this.appBar,
      this.drawer,
      this.bottomSheet,
      this.endDrawer,
      this.onDrawerChanged,
      this.onEndDrawerChanged,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.uiOverlayStyle = const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Color(0x00000000),
        systemNavigationBarColor: Color(0x00000000),
      ),
      this.scaffoldBackgroundColor,
      this.encapsulateScreen = true,
      this.encapsulateBackground = false,
      this.extendBodyBehindAppBar = false,
      this.extendBodyBehindNavBar = false,
      this.resizeToAvoidBottomInset = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    FlutterView window =
        WidgetsBinding.instance.platformDispatcher.views.single;
    ViewPadding windowPadding = window.viewPadding;
    double bottomPadding = windowPadding.bottom > 0
        ? windowPadding.bottom
        : window.viewInsets.bottom;

    EdgeInsets boundaries = EdgeInsets.only(
        bottom: bottomPadding / window.devicePixelRatio,
        top: windowPadding.top / window.devicePixelRatio);

    Widget encapsulatedScreen = screenBuilder(context, boundaries);
    Widget? encapsulatedBackground;

    if (encapsulateScreen) {
      encapsulatedScreen = Padding(
        padding: boundaries,
        child: screenBuilder(context, boundaries),
      );
    }

    if (screenBackgroundBuilder != null) {
      encapsulatedBackground = encapsulateBackground
          ? Padding(
              padding: boundaries,
              child: screenBackgroundBuilder!(context, boundaries),
            )
          : screenBackgroundBuilder!(context, boundaries);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: uiOverlayStyle,
      child: Scaffold(
        drawer: drawer,
        endDrawer: endDrawer,
        bottomSheet: bottomSheet,
        onDrawerChanged: onDrawerChanged,
        onEndDrawerChanged: onEndDrawerChanged,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        backgroundColor: scaffoldBackgroundColor,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        floatingActionButtonLocation: floatingActionButtonLocation,
        body: Stack(
          children: [
            if (encapsulatedBackground != null) encapsulatedBackground,
            encapsulatedScreen,
            if (screenOverlayBuilder != null) screenOverlayBuilder!(context),
          ],
        ),
        appBar: appBar,
        extendBody: extendBodyBehindNavBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}
