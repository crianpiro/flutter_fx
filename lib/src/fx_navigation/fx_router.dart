import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_fx/src/fx_navigation/models/enums.dart';
import 'package:flutter_fx/src/fx_navigation/models/navigation_arguments.dart';

import 'fx_app.dart';

/// The [FxRouter] class provides a simple and efficient way to manage navigation
/// in your Flutter app by using a [GlobalKey] over the [NavigatorState].
///
/// It allows you to define routes, navigate between them, and handle navigation
/// history.
@immutable
final class FxRouter {
  /// Controls whether the default transition should be used when going to a new
  /// route.
  ///
  /// If [value] is true, the default transition will be used.
  ///
  /// If [value] is false, the transition for the new route will be determined by
  /// the [NavigationArguments] passed.
  ///
  /// The default transition is a [RouteTransition.animated] transition.
  ///
  /// The default value is true.
  static useDefaultTransition(bool value) => FxRouterInternal.useDefaultTransition = value;

  /// Sets whether the navigation history should be saved.
  ///
  /// If [value] is true, each new route navigated to will be added to the
  /// history, allowing for back navigation.
  ///
  /// If [value] is false, the routes will not be saved to history.
  static saveHistory(bool value) => FxRouterInternal.saveHistory = value;

  /// Pushes the given [path] onto the navigator.
  ///
  /// The [arguments] are used to generate the [PageRouteBuilder] for the new
  /// route.
  ///
  /// If [saveHistory] is true, the new route is saved to the history.
  /// 
  /// If [whenInRoute] is not null, the new route is pushed only if the current
  /// route is [whenInRoute].
  ///
  /// Returns a [Future] which resolves to the result of the route when it is
  /// popped from the navigator.
  ///
  /// See also:
  ///
  /// * [saveHistory], which controls whether the new route is saved to the
  ///   history.
  /// * [goToAndReplace], which pushes the given [path] onto the navigator and
  ///   replaces the current route.
  static Future<T?> goTo<T extends Object?>(String path, {NavigationArguments? arguments, String? whenInRoute}) =>
      FxRouterInternal.goTo(path, arguments: arguments, whenInRoute: whenInRoute);

  /// Pushes the given [path] onto the navigator and replaces the current route.
  ///
  /// The [arguments] are used to generate the [PageRouteBuilder] for the new
  /// route.
  ///
  /// If [saveHistory] is true, the new route is saved to the history.
  /// 
  /// If [whenInRoute] is not null, the new route is pushed only if the current
  /// route is [whenInRoute].
  ///
  /// Returns a [Future] which resolves to the result of the route when it is
  /// popped from the navigator.
  static Future<T?> goToAndReplace<T extends Object?>(String path, {NavigationArguments? arguments, String? whenInRoute}) =>
      FxRouterInternal.goToAndReplace(path, arguments: arguments, whenInRoute: whenInRoute);

  /// Removes all the top-most routes until the [predicate] returns `true`.
  ///
  /// The [predicate] is called with the current route as argument. If the
  /// predicate returns `true`, the navigator pops the route and stops. If the
  /// predicate returns `false`, the navigator continues to the next route.
  ///
  /// If the [predicate] is `null`, the navigator pops all routes until it has
  /// none left.
  static FutureOr<void> backUntil(bool Function(Route<dynamic>) predicate) => FxRouterInternal.backUntil(predicate);

  /// Pops the top-most route off the navigator.
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [back].
  static FutureOr<void> back() => FxRouterInternal.back();

  /// Pops the top-most route off the navigator that most tightly encloses the
  /// given [BuildContext] if possible.
  ///
  /// Returns `true` if the route was popped, `false` otherwise.
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [maybeBack].
  static FutureOr<bool> maybeBack() => FxRouterInternal.maybeBack();

  /// Removes the given [route] from the history.
  ///
  /// This method is used by [FxRouter.backUntil] and [FxRouter.back] to remove
  /// the top-most route from the history.
  ///
  /// Returns a [Future] which resolves when the route is removed from the
  /// history.
  static FutureOr<void> removeRoute<T extends Object?>(Route<T> route) => FxRouterInternal.removeRoute(route);
}

@immutable
final class FxRouterInternal {
  /// Determines whether to use the default transition animation when navigating
  /// between routes. The default transition is set to [RouteTransition.animated],
  /// using [TransitionDirection.leftToRight] and [Curves.linear].
  ///
  /// If set to `false`, a custom transition animation can be used.
  /// If set to `false` and no custom transition is provided, then the navigation will be [RouteTransition.none].
  static bool useDefaultTransition = true;

  /// Controls whether the navigation history is saved or not.
  ///
  /// If set to `true`, the [FxRouter] will store the navigation history, allowing for
  /// features like back navigation and track routes, this will be released soon.
  static bool saveHistory = false;

  /// Holds a reference to the `NavigatorState` key, which is used to access the
  /// navigator's state.
  ///
  /// This key is used to perform navigation operations.
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Stores the navigation history as a list of `Route` objects.
  ///
  /// This list is used to keep track of the routes that have been navigated to.
  static final List<Route> _routesHistory = [];

  /// Holds a reference to a function that builds a widget for a given route.
  ///
  /// This function is used to create the widget tree for each route.
  static Widget Function(String route)? _routeBuilder;

  /// Stores the current route as a string.
  ///
  /// This variable is used to keep track of the currently active route.
  static String _currentRoute = '';

  static FxRouterInternal? _singleton;

  const FxRouterInternal._();

  factory FxRouterInternal.init(GlobalKey<NavigatorState>? navigatorKey, Widget Function(String route) buildRoute) {
    _navigatorKey = navigatorKey;
    _routeBuilder = buildRoute;
    return _singleton ??= const FxRouterInternal._();
  }

  /// Ensures that the [FxRouterInternal] is used properly.
  ///
  /// Before using the [FxRouterInternal] you must call [FxRouter.init] to initialize it.
  ///
  /// This method is used internally by the [FxRouterInternal] to check if it is used
  /// properly. You should not call this method directly.
  ///
  /// If the [FxRouterInternal] is used improperly, a [FlutterError] will be thrown.
  ///
  /// See also:
  ///
  /// * [FxRouter.init], which initializes the [FxRouterInternal].
  /// * [FxApp], which is the main widget that uses the [FxRouterInternal].
  static void _ensureProperUse() {
    final FlutterError error = FlutterError("""Improper use of a [FxRouter].
        * The [FxRouter] must be initialized.
        * To use [FxRouter] your main Widget must be a [FxApp].""");
    assert(_navigatorKey != null && _navigatorKey!.currentState != null && _routeBuilder != null, error);

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


  /// Pushes the given [path] onto the navigator.
  ///
  /// The [arguments] are used to generate the [PageRouteBuilder] for the new
  /// route.
  ///
  /// If [saveHistory] is true, the new route is saved to the history.
  ///
  /// If [whenInRoute] is not null, the new route is pushed only if the current
  /// route is [whenInRoute].
  ///
  /// Returns a [Future] which resolves to the result of the route when it is
  /// popped from the navigator.
  static Future<T?> goTo<T extends Object?>(String path, {NavigationArguments? arguments, String? whenInRoute}) {
    _ensureProperUse();

    if (whenInRoute != null && _currentRoute != whenInRoute) {
      return Future.value(null);
    }

    Route<T> route = _getPageRouteBuilder(path, _getRouteArguments(navArguments: arguments));

    if (saveHistory) {
      _routesHistory.add(route);
    }

    return _navigatorKey!.currentState!.push(route);
  }


  /// Pushes the given [path] onto the navigator and replaces the current route.
  ///
  /// The [arguments] are used to generate the [PageRouteBuilder] for the new
  /// route.
  ///
  /// If [saveHistory] is true, the new route is saved to the history.
  ///
  /// If [whenInRoute] is not null, the new route is pushed only if the current
  /// route is [whenInRoute].
  ///
  /// Returns a [Future] which resolves to the result of the route when it is
  /// popped from the navigator.
  static Future<T?> goToAndReplace<T extends Object?>(String path, {NavigationArguments? arguments, String? whenInRoute}) {
    _ensureProperUse();

    if (whenInRoute != null && _currentRoute != whenInRoute) {
      return Future.value(null);
    }

    Route<T> route = _getPageRouteBuilder(path, _getRouteArguments(navArguments: arguments));

    if (saveHistory) {
      _routesHistory.removeLast();
      _routesHistory.add(route);
    }
    return _navigatorKey!.currentState!.pushReplacement(route);
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
    _ensureProperUse();
    if (saveHistory) {
      _routesHistory.removeWhere(predicate);
    }
    _navigatorKey!.currentState!.popUntil(predicate);
  }

  /// Pops the top-most route off the navigator that most tightly encloses the
  /// given [BuildContext].
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [back].
  static FutureOr<void> back() {
    _ensureProperUse();
    if (saveHistory) {
      _routesHistory.removeLast();
    }
    _navigatorKey!.currentState?.pop();
  }

  /// Removes a route from the navigator.
  ///
  /// The given [route] will be removed from the navigator.
  ///
  /// This method is used internally by the [FxRouterInternal] to remove routes. You
  /// should not call this method directly.
  ///
  /// If the navigator does not contain the given [route], this method does
  /// nothing.
  ///
  /// See also:
  ///
  /// * [Navigator.removeRoute], which is the method that this method calls.
  static FutureOr<void> removeRoute<T extends Object?>(Route<T> route) {
    _ensureProperUse();
    _navigatorKey!.currentState?.removeRoute(route);
  }

  /// Pops the top-most route off the navigator that most tightly encloses the
  /// given [BuildContext] if possible.
  ///
  /// Returns `true` if the route was popped, `false` otherwise.
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [maybeBack].
  static Future<bool> maybeBack() {
    _ensureProperUse();
    return _navigatorKey!.currentState!.maybePop();
  }

  /// This callback is used by [WidgetsApp] to generate a route for a given
  /// [RouteSettings].
  ///
  /// The [RouteSettings.name] is the name of the route, and the
  /// [RouteSettings.arguments] are the arguments passed to the route.
  ///
  /// The returned [Route] is the route that will be used to generate the route.
  ///
  /// The [FxRouterInternal] will generate the route using the [_getPageRouteBuilder]
  /// method.
  static Route<T> onGenerateRoute<T extends Object?>(RouteSettings routeSettings) {
    String routeName = routeSettings.name ?? "/";

    _currentRoute = routeName;

    return _getPageRouteBuilder(routeName, _getRouteArguments(routeSettings: routeSettings));
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
  static NavigationArguments _getRouteArguments({RouteSettings? routeSettings, NavigationArguments? navArguments}) {
    final Object? arguments = routeSettings?.arguments ?? navArguments;
    NavigationArguments routeArguments = const NavigationArguments();

    if ((arguments == null || arguments is! NavigationArguments) && !useDefaultTransition) {
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
  static PageRouteBuilder<T> _getPageRouteBuilder<T extends Object?>(String route, NavigationArguments arguments) {
    return PageRouteBuilder(
      settings: RouteSettings(name: route, arguments: arguments.payload),
      pageBuilder: (context, animation, secondaryAnimation) => _routeBuilder!(route),
      opaque: false,
      barrierColor: arguments.barrierColor,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (arguments.routeTransition == RouteTransition.animated) {
          return SlideTransition(
            position: _getTransition(animation, arguments.transitionDirection, arguments.curve),
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
  static Animation<Offset> _getTransition(Animation<double> animation, TransitionDirection transition, Curve curve) {
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
