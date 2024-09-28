import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_fx/src/fx_navigation/models/enums.dart';
import 'package:flutter_fx/src/fx_navigation/models/navigation_arguments.dart';

import 'fx_app.dart';

@immutable
final class FxRouter {
  static bool useDefaultTransition = true;
  static GlobalKey<NavigatorState>? _navigatorKey;
  static Widget Function(String route)? _routeBuilder;

  static FxRouter? _singleton;

  const FxRouter._();

  factory FxRouter.init(GlobalKey<NavigatorState>? navigatorKey,
      Widget Function(String route) buildRoute) {
    _navigatorKey = navigatorKey;
    _routeBuilder = buildRoute;
    return _singleton ??= const FxRouter._();
  }

  /// Ensures that the [FxRouter] is used properly.
  ///
  /// Before using the [FxRouter] you must call [FxRouter.init] to initialize it.
  ///
  /// This method is used internally by the [FxRouter] to check if it is used
  /// properly. You should not call this method directly.
  ///
  /// If the [FxRouter] is used improperly, a [FlutterError] will be thrown.
  ///
  /// See also:
  ///
  /// * [FxRouter.init], which initializes the [FxRouter].
  /// * [FxApp], which is the main widget that uses the [FxRouter].
  static void ensureProperUse() {
    final FlutterError error = FlutterError("""Improper use of a [FxRouter].
        * The [FxRouter] must be initialized.
        * To use [FxRouter] your main Widget must be a [FxApp].""");
    assert(
        _navigatorKey != null &&
            _navigatorKey!.currentState != null &&
            _routeBuilder != null,
        error);

    bool safe = false;

    _navigatorKey!.currentContext?.visitAncestorElements((element) {
      if (element.widget is FxApp) {
        safe = true;
        return false;
      }
      return true;
    });

    if (!safe) {
      throw error;
    }
  }

  /// Pushes the given [route] onto the navigator.
  ///
  /// The [arguments] are used to generate the [PageRouteBuilder] for the new
  /// route.
  ///
  /// If the [arguments] are not provided, the default transition is used.
  static FutureOr<void> goTo(String route, {NavigationArguments? arguments}) {
    ensureProperUse();
    _navigatorKey!.currentState?.push(_getPageRouteBuilder(
        route, getRouteArguments(navArguments: arguments)));
  }

  /// Pushes the given [route] onto the navigator and replaces the current route.
  ///
  /// The [arguments] are used to generate the [PageRouteBuilder] for the new
  /// route.
  ///
  /// If the [arguments] are not provided, the default transition is used.
  ///
  /// The [predicate] is called with the current route as argument. If the
  /// predicate returns `true`, the navigator pops the route and stops. If the
  /// predicate returns `false`, the navigator continues to the next route.
  static FutureOr<void> goToAndReplace(String route,
      {NavigationArguments? arguments}) {
    ensureProperUse();
    _navigatorKey!.currentState?.pushReplacement(_getPageRouteBuilder(
        route, getRouteArguments(navArguments: arguments)));
  }

  /// Removes all the top-most routes until the [predicate] returns `true`.
  ///
  /// The [predicate] is called with the current route as argument. If the
  /// predicate returns `true`, the navigator pops the route and stops. If the
  /// predicate returns `false`, the navigator continues to the next route.
  ///
  /// If the [predicate] is `null`, the navigator pops all routes until it has
  /// none left.
  static FutureOr<void> backUntil(bool Function(Route<dynamic>) predicate) {
    ensureProperUse();
    _navigatorKey!.currentState?.popUntil(predicate);
  }

  /// Pops the top-most route off the navigator that most tightly encloses the
  /// given [BuildContext].
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [back].
  static FutureOr<void> back() {
    ensureProperUse();
    _navigatorKey!.currentState?.pop();
  }

  /// This callback is used by [WidgetsApp] to generate a route for a given
  /// [RouteSettings].
  ///
  /// The [RouteSettings.name] is the name of the route, and the
  /// [RouteSettings.arguments] are the arguments passed to the route.
  ///
  /// The returned [Route] is the route that will be used to generate the route.
  ///
  /// The [FxRouter] will generate the route using the [_getPageRouteBuilder]
  /// method.
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    String routeName = routeSettings.name ?? "/";

    return _getPageRouteBuilder(
        routeName, getRouteArguments(routeSettings: routeSettings));
  }

  /// Gets the [NavigationArguments] for the given [RouteSettings] or
  /// [NavigationArguments].
  ///
  /// If [useDefaultTransition] is false and the given [arguments] is not a
  /// [NavigationArguments], then a [NavigationArguments] with no transition
  /// with the given [arguments] is returned.
  ///
  /// If [arguments] is a [NavigationArguments], then it is returned as is.
  ///
  /// Otherwise, a [NavigationArguments] with the given [arguments] is
  /// returned.
  static NavigationArguments getRouteArguments(
      {RouteSettings? routeSettings, NavigationArguments? navArguments}) {
    final Object? arguments = routeSettings?.arguments ?? navArguments;
    NavigationArguments routeArguments = const NavigationArguments();

    if ((arguments == null || arguments is! NavigationArguments) &&
        !useDefaultTransition) {
      routeArguments = NavigationArguments.noTransition(arguments);
    }

    if (arguments is NavigationArguments) {
      routeArguments = arguments;
    }

    return routeArguments;
  }

  /// Generates a [PageRouteBuilder] for the given [route] and [arguments].
  ///
  /// The [transitionsBuilder] is set to use the [SlideTransition] if the
  /// [routeTransition] property of the given [arguments] is
  /// [RouteTransition.animated].
  ///
  /// If the [routeTransition] property of the given [arguments] is
  /// [RouteTransition.none], then the [transitionsBuilder] does not include the animaction, just returngs.
  static PageRouteBuilder _getPageRouteBuilder(
      String route, NavigationArguments arguments) {
    return PageRouteBuilder(
      settings: RouteSettings(name: route, arguments: arguments.payload),
      pageBuilder: (context, animation, secondaryAnimation) =>
          _routeBuilder!(route),
      opaque: false,
      barrierColor: arguments.barrierColor,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (arguments.routeTransition == RouteTransition.animated) {
          return SlideTransition(
            position: _getTransition(
                animation, arguments.transitionDirection, arguments.curve),
            child: child,
          );
        } else {
          return child;
        }
      },
    );
  }

  /// Generates an [Animation] for the given [TransitionDirection].
  ///
  /// The animation is a [Tween] that goes from the [begin] offset to the
  /// [end] offset.
  ///
  /// The [begin] and [end] offsets are determined by the given
  /// [TransitionDirection].
  ///
  /// The animation is then animated with the given [animation] and
  /// [curve].
  static Animation<Offset> _getTransition(Animation<double> animation,
      TransitionDirection transition, Curve curve) {
    Offset begin;
    Offset end;

    switch (transition) {
      case TransitionDirection.bottomToTop:
        begin = const Offset(0.0, 1.0);
        end = Offset.zero;
        break;
      case TransitionDirection.topToBottom:
        begin = const Offset(0.0, -1.0);
        end = Offset.zero;
        break;
      case TransitionDirection.leftToRight:
        begin = const Offset(-1.0, 0.0);
        end = Offset.zero;
        break;
      default:
        begin = const Offset(1.0, 0.0);
        end = Offset.zero;
        break;
    }

    final tween = Tween(begin: begin, end: end);

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return tween.animate(curvedAnimation);
  }
}
