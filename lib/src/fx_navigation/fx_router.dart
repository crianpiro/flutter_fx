import 'dart:async';
import 'package:flutter/widgets.dart';

enum RouteTransition { none, linear, curve, fade }

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
  final Color? barrierColor;
  final RouteTransition pageTransition;
  final TransitionDirection transitionDirection;

  const NavigationArguments(
      {this.payload,
      this.barrierColor = const Color.fromARGB(0, 0, 0, 0),
      this.pageTransition = RouteTransition.linear,
      this.transitionDirection = TransitionDirection.rightToLeft});

  factory NavigationArguments.noTransition(dynamic payload){
    return NavigationArguments(
      payload: payload,
      barrierColor: const Color.fromARGB(255, 0, 0, 0),
      transitionDirection: TransitionDirection.none,
      pageTransition: RouteTransition.none);
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

  static FutureOr<void> pushTo(String route, {NavigationArguments? arguments}) {
    assert(
        _navigatorKey != null &&
            _navigatorKey!.currentState != null &&
            _routeBuilder != null,
        "Application router must be initialized.");
    _navigatorKey!.currentState?.push(_getPageRouteBuilder(route));
  }

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    String routeName = routeSettings.name ?? "/";

    final Object? arguments = routeSettings.arguments;
    NavigationArguments routeArguments = const NavigationArguments();

    if ((arguments == null || arguments is! NavigationArguments) && !useDefaultTransition) {
      routeArguments =  NavigationArguments.noTransition(arguments);
    }

    if (arguments is NavigationArguments) {
      routeArguments = routeSettings.arguments as NavigationArguments;
    }

    return _getPageRouteBuilder(routeName, arguments: routeArguments);
  }

  static PageRouteBuilder _getPageRouteBuilder(String route,
      {NavigationArguments? arguments}) {
    if (arguments == null && !useDefaultTransition) {
      arguments = const NavigationArguments(
          barrierColor: Color.fromARGB(255, 0, 0, 0),
          transitionDirection: TransitionDirection.none,
          pageTransition: RouteTransition.none);
    } else {
      arguments ??= const NavigationArguments();
    }

    return PageRouteBuilder(
      settings: RouteSettings(name: route, arguments: arguments.payload),
      pageBuilder: (context, animation, secondaryAnimation) =>
          _routeBuilder!(route),
      opaque: false,
      barrierColor: arguments.barrierColor,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (arguments!.transitionDirection != TransitionDirection.none) {
          return SlideTransition(
            position:
                _getLinearTransition(animation, arguments.transitionDirection),
            child: child,
          );
        } else {
          return child;
        }
      },
    );
  }

  static Animation<Offset> _getLinearTransition(
      Animation<double> animation, TransitionDirection transition) {
    Animation<Offset> offsetAnimation;
    switch (transition) {
      case TransitionDirection.bottomToTop:
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        offsetAnimation = animation.drive(tween);
        break;
      case TransitionDirection.leftToRight:
        const begin = Offset(0.0, 0.0);
        const end = Offset(1.0, 0.0);
        final tween = Tween(begin: begin, end: end);
        offsetAnimation = animation.drive(tween);
        break;
      default:
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        offsetAnimation = animation.drive(tween);
        break;
    }

    return offsetAnimation;
  }

  // static void navigatorChannel(Function() navigatorBuilder) {
  //   // assert(_mainContext == null, "Application router must be initialized.");
  //   // assert(() {
  //   //   if (_mainContext. == null) {
  //   //     throw FlutterError(
  //   //       'Navigator.onGenerateRoute was null, but the route named "$name" was referenced.\n'
  //   //       'To use the Navigator API with named routes (pushNamed, pushReplacementNamed, or '
  //   //       'pushNamedAndRemoveUntil), the Navigator must be provided with an '
  //   //       'onGenerateRoute handler.\n'
  //   //       'The Navigator was:\n'
  //   //       '  $this',
  //   //     );
  //   //   }
  //   //   return true;
  //   // }());
  // }
}
