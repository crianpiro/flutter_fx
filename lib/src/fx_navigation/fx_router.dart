import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_fx/src/fx_navigation/models/enums.dart';
import 'package:flutter_fx/src/fx_navigation/models/navigation_arguments.dart';

import 'fx_app.dart';
part 'fx_router_internal.dart';


/// The [FxRouter] class provides a simple and efficient way to manage navigation
/// in your Flutter app by using a [GlobalKey] over the [NavigatorState].
///
/// It allows you to define routes, navigate between them, and handle navigation
/// history.
@immutable
final class FxRouter {

  static final FxRouterInternal _internal = FxRouterInternal.instance;
  
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
  static useDefaultTransition(bool value) => _internal.useDefaultTransition = value;

  /// Sets whether the navigation history should be saved.
  ///
  /// If [value] is true, each new route navigated to will be added to the
  /// history, allowing for back navigation.
  ///
  /// If [value] is false, the routes will not be saved to history.
  static saveHistory(bool value) => _internal.saveHistory = value;

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
      _internal.goTo(path, arguments: arguments, whenInRoute: whenInRoute);

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
      _internal.goToAndReplace(path, arguments: arguments, whenInRoute: whenInRoute);

  
  /// Pushes the given [path] onto the navigator and removes all the top-most
  /// routes until the [predicate] returns `true`.
  ///
  /// The [predicate] is called with the current route as argument. If the
  /// predicate returns `true`, the navigator stops. If the predicate returns
  /// `false`, the navigator continues to the next route.
  ///
  /// If the [predicate] is `null`, the navigator removes all routes until it has
  /// none left.
  ///
  /// If [saveHistory] is true, the new route is saved to the history.
  /// 
  /// If [whenInRoute] is not null, the new route is pushed only if the current
  /// route is [whenInRoute].
  ///
  /// Returns a [Future] which resolves to the result of the route when it is
  /// popped from the navigator.
  static Future<T?> goToAndRemoveUntil<T extends Object?>(String path, bool Function(Route<dynamic>) predicate, {NavigationArguments? arguments, String? whenInRoute}) =>
      _internal.goToAndRemoveUntil(path, predicate, arguments: arguments, whenInRoute: whenInRoute);

  /// Removes all the top-most routes until the [predicate] returns `true`.
  ///
  /// The [predicate] is called with the current route as argument. If the
  /// predicate returns `true`, the navigator pops the route and stops. If the
  /// predicate returns `false`, the navigator continues to the next route.
  ///
  /// If the [predicate] is `null`, the navigator pops all routes until it has
  /// none left.
  static FutureOr<void> backUntil(bool Function(Route<dynamic>) predicate) => _internal.backUntil(predicate);

  /// Pops the top-most route off the navigator.
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [back].
  static FutureOr<void> back() => _internal.back();

  /// Pops the top-most route off the navigator that most tightly encloses the
  /// given [BuildContext] if possible.
  ///
  /// Returns `true` if the route was popped, `false` otherwise.
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [maybeBack].
  static FutureOr<bool> maybeBack() => _internal.maybeBack();

  /// Removes the given [route] from the history.
  ///
  /// This method is used by [FxRouter.backUntil] and [FxRouter.back] to remove
  /// the top-most route from the history.
  ///
  /// Returns a [Future] which resolves when the route is removed from the
  /// history.
  static FutureOr<void> removeRoute<T extends Object?>(Route<T> route) => _internal.removeRoute(route);
}
