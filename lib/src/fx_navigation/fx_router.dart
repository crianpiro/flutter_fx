
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
  final TransitionDirection transitionDirection;
  final RouteTransition pageTransition;

  const NavigationArguments(
      {this.payload,
      this.pageTransition = RouteTransition.linear,
      this.transitionDirection = TransitionDirection.rightToLeft});
}

@immutable
final class FxRouter {
  static bool useDefaultTransition = true;
  static BuildContext? _mainContext;
  static FxRouter? _singleton;
  static Widget Function(String route)? _buildRoute;

  const FxRouter._();

  factory FxRouter.iniContext(BuildContext context) {
    _mainContext = context;
    return _singleton ??= const FxRouter._();
  }

  factory FxRouter.initRouteBuilder(Widget Function(String route) buildRoute) {
    _buildRoute = buildRoute;
    return _singleton ??= const FxRouter._();
  }

  static FutureOr<void> pushTo(String route, {NavigationArguments? arguments}) {
    assert(_mainContext != null && _buildRoute != null,
        "Application router must be initialized.");
    Navigator.of(_mainContext!).push(getPageRouteBuilder(_buildRoute!, route));
  }

  static PageRouteBuilder getPageRouteBuilder(
      Widget Function(String route) buildRoute, String route,
      {NavigationArguments? arguments}) {
    if (arguments == null && !useDefaultTransition) {
      arguments = const NavigationArguments(
          transitionDirection: TransitionDirection.none,
          pageTransition: RouteTransition.none);
    } else {
      arguments = const NavigationArguments();
    }

    return PageRouteBuilder(
      settings: RouteSettings(name: route, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) =>
          _buildRoute!(route),
      opaque: false,
      barrierColor: const Color(0x00000000),
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

  static void navigatorChannel(Function() navigatorBuilder) {
    // assert(_mainContext == null, "Application router must be initialized.");
    // assert(() {
    //   if (_mainContext. == null) {
    //     throw FlutterError(
    //       'Navigator.onGenerateRoute was null, but the route named "$name" was referenced.\n'
    //       'To use the Navigator API with named routes (pushNamed, pushReplacementNamed, or '
    //       'pushNamedAndRemoveUntil), the Navigator must be provided with an '
    //       'onGenerateRoute handler.\n'
    //       'The Navigator was:\n'
    //       '  $this',
    //     );
    //   }
    //   return true;
    // }());
  }
}
