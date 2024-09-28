import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fx/src/fx_navigation/models/view_arguments.dart';

@immutable
final class FxView extends StatelessWidget {
  final ViewArguments arguments;
  final Widget Function(BuildContext context) viewBuilder;
  final Widget Function(BuildContext context)? viewBackgroundBuilder;
  final Widget Function(BuildContext context)? viewOverlayBuilder;
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

  const FxView(
      {required this.viewBuilder,
      this.viewBackgroundBuilder,
      this.viewOverlayBuilder,
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
      this.arguments = const ViewArguments(
          uiOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      )),
      super.key});

  @override
  Widget build(BuildContext context) {
    Widget encapsuledChild = viewBuilder(context);
    if (arguments.applyViewPaddings) {
      FlutterView window =
          WidgetsBinding.instance.platformDispatcher.views.single;
      ViewPadding windowPadding = window.viewPadding;
      double bottomPadding = windowPadding.bottom > 0
          ? windowPadding.bottom
          : window.viewInsets.bottom;
      encapsuledChild = Padding(
        padding: EdgeInsets.only(
            bottom: bottomPadding / window.devicePixelRatio,
            top: windowPadding.top / window.devicePixelRatio),
        child: viewBuilder(context),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: arguments.uiOverlayStyle,
      child: Scaffold(
        drawer: drawer,
        endDrawer: endDrawer,
        bottomSheet: bottomSheet,
        onDrawerChanged: onDrawerChanged,
        onEndDrawerChanged: onEndDrawerChanged,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        backgroundColor: arguments.scaffoldBackgroundColor,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        floatingActionButtonLocation: floatingActionButtonLocation,
        body: Stack(
          children: [
            if (viewBackgroundBuilder != null) viewBackgroundBuilder!(context),
            encapsuledChild,
            if (viewOverlayBuilder != null) viewOverlayBuilder!(context),
          ],
        ),
        appBar: appBar,
        extendBody: arguments.extendBodyBehindNavBar,
        extendBodyBehindAppBar: arguments.extendBodyBehindAppBar,
        resizeToAvoidBottomInset: arguments.resizeToAvoidBottomInset,
      ),
    );
  }
}
