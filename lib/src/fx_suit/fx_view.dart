import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fx/src/fx_suit/models/view_arguments.dart';

@immutable
final class FxView extends StatelessWidget {
  final ViewArguments arguments;
  final Widget Function(BuildContext context) viewBuilder;
  final Widget Function(BuildContext context)? viewBacklayerBuilder;
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
      this.viewBacklayerBuilder,
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
    Widget? encapsuledBacklayer;

    FlutterView window =
        WidgetsBinding.instance.platformDispatcher.views.single;
    ViewPadding windowPadding = window.viewPadding;
    double bottomPadding = windowPadding.bottom > 0
        ? windowPadding.bottom
        : window.viewInsets.bottom;

    EdgeInsets boundaries = EdgeInsets.only(
        bottom: bottomPadding / window.devicePixelRatio,
        top: windowPadding.top / window.devicePixelRatio);

    if (arguments.applyViewPaddings) {
      encapsuledChild = Padding(
        padding: boundaries,
        child: viewBuilder(context),
      );
    }

    if (viewBacklayerBuilder != null) {
      encapsuledBacklayer = arguments.applyBacklayerPaddings
          ? Padding(
              padding: boundaries,
              child: viewBacklayerBuilder!(context),
            )
          : viewBacklayerBuilder!(context);
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
            if (encapsuledBacklayer != null) encapsuledBacklayer,
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
