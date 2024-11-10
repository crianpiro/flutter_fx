import 'package:flutter/widgets.dart';
import 'package:flutter_fx/src/fx_navigation/models/enums.dart';

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

  factory NavigationArguments.noTransition({dynamic payload}) {
    return NavigationArguments(
        payload: payload,
        barrierColor: const Color.fromARGB(255, 0, 0, 0),
        transitionDirection: TransitionDirection.none,
        routeTransition: RouteTransition.none);
  }
}
