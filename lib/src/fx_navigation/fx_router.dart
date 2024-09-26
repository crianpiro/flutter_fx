import 'dart:async';
import 'package:flutter/widgets.dart';

enum RouteTransition { none, animated }

enum TransitionDirection {
  none,
  leftToRight,
  rightToLeft,
  bottomToTop,
  topToBottom
}

@immutable
final class NavigationArguments {
  final dynamic payload;
  final Curve curve;
  final Color? barrierColor;
  final RouteTransition routeTransition;
  final TransitionDirection transitionDirection;

  const NavigationArguments(
      {this.payload,
      this.curve = Curves.linear,
      this.barrierColor = const Color.fromARGB(0, 0, 0, 0),
      this.routeTransition = RouteTransition.animated,
      this.transitionDirection = TransitionDirection.rightToLeft});

  factory NavigationArguments.noTransition(dynamic payload) {
    return NavigationArguments(
        payload: payload,
        barrierColor: const Color.fromARGB(255, 0, 0, 0),
        transitionDirection: TransitionDirection.none,
        routeTransition: RouteTransition.none);
  }
}

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

  static FutureOr<void> goTo(String route, {NavigationArguments? arguments}) {
    assert(
        _navigatorKey != null &&
            _navigatorKey!.currentState != null &&
            _routeBuilder != null,
        "Application router must be initialized.");
    _navigatorKey!.currentState?.push(_getPageRouteBuilder(
        route, getRouteArguments(navArguments: arguments)));
  }

  static FutureOr<void> goToAndReplace(String route,
      {NavigationArguments? arguments}) {
    assert(
        _navigatorKey != null &&
            _navigatorKey!.currentState != null &&
            _routeBuilder != null,
        "Application router must be initialized.");
    _navigatorKey!.currentState?.pushReplacement(_getPageRouteBuilder(
        route, getRouteArguments(navArguments: arguments)));
  }

  static FutureOr<void> backUntil(bool Function(Route<dynamic>) predicate) {
    assert(
        _navigatorKey != null &&
            _navigatorKey!.currentState != null &&
            _routeBuilder != null,
        "Application router must be initialized.");
    _navigatorKey!.currentState?.popUntil(predicate);
  }

  static FutureOr<void> back() {
    assert(
        _navigatorKey != null &&
            _navigatorKey!.currentState != null &&
            _routeBuilder != null,
        "Application router must be initialized.");
    _navigatorKey!.currentState?.pop();
  }

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    String routeName = routeSettings.name ?? "/";

    return _getPageRouteBuilder(
        routeName, getRouteArguments(routeSettings: routeSettings));
  }

  static NavigationArguments getRouteArguments(
      {RouteSettings? routeSettings, NavigationArguments? navArguments}) {
    final Object? arguments = routeSettings?.arguments ?? navArguments;
    NavigationArguments routeArguments = const NavigationArguments();

    if ((arguments == null || arguments is! NavigationArguments) &&
        !useDefaultTransition) {
      routeArguments = NavigationArguments.noTransition(arguments);
    }

    if (arguments is NavigationArguments) {
      routeArguments = routeSettings?.arguments as NavigationArguments;
    }

    return routeArguments;
  }

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
        begin = const Offset(1.0, 0.0);
        end = Offset.zero;
        break;
      case TransitionDirection.leftToRight:
        begin = const Offset(0.0, 0.0);
        end = const Offset(1.0, 0.0);
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
