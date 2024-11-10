part of 'fx_router.dart';

final class FxRoute {
  Widget child;
  RouteSettings? settings;

  FxRoute({required this.child, this.settings});
}

final class FxRouterInternal {
  /// Determines whether to use the default transition animation when navigating
  /// between routes. The default transition is set to [RouteTransition.animated],
  /// using [TransitionDirection.leftToRight] and [Curves.linear].
  ///
  /// If set to `false`, a custom transition animation can be used.
  /// If set to `false` and no custom transition is provided, then the navigation will be [RouteTransition.none].
  bool useDefaultTransition = true;

  /// Controls whether the navigation history is saved or not.
  ///
  /// If set to `true`, the [FxRouter] will store the navigation history, allowing for
  /// features like back navigation and track routes, this will be released soon.
  bool saveHistory = false;

  /// Holds a reference to the `NavigatorState` key, which is used to access the
  /// navigator's state.
  ///
  /// This key is used to perform navigation operations.
  final GlobalKey<NavigatorState> _navigatorKey;

  /// Stores the navigation history as a list of `Route` objects.
  ///
  /// This list is used to keep track of the routes that have been navigated to.
  final List<Route> _routesHistory = [];

  /// Holds a reference to a function that builds a widget for a given route.
  ///
  /// This function is used to create the widget tree for each route.
  final FxRoute Function(String route) _routeBuilder;

  /// Stores the current route as a string.
  ///
  /// This variable is used to keep track of the currently active route.
  String _currentRoute = '';

  static late FxRouterInternal _instance;
  
  static FxRouterInternal get instance => _instance;

  FxRouterInternal._(this._navigatorKey, this._routeBuilder);

  factory FxRouterInternal.initialize(GlobalKey<NavigatorState> navigatorKey, FxRoute Function(String route) routeBuilder) {
    _instance = FxRouterInternal._(navigatorKey, routeBuilder);
    return _instance;
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
  void _ensureProperUse() {
    final FlutterError error = FlutterError("""Improper use of a [FxRouter].
        * The [FxRouter] must be initialized.
        * To use [FxRouter] your main Widget must be a [FxApp].""");
    assert(_navigatorKey.currentState != null, error);

    bool safe = false;

    _navigatorKey.currentContext?.visitAncestorElements((element) {
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
  Future<T?> goTo<T extends Object?>(String path, {NavigationArguments? arguments, String? whenInRoute}) {
    _ensureProperUse();

    if (whenInRoute != null && _currentRoute != whenInRoute) {
      return Future.value(null);
    }

    Route<T> route = _getPageRouteBuilder(path, _getRouteArguments(navArguments: arguments));

    if (saveHistory) {
      _routesHistory.add(route);
    }

    return _navigatorKey.currentState!.push(route);
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
  Future<T?> goToAndReplace<T extends Object?>(String path, {NavigationArguments? arguments, String? whenInRoute}) {
    _ensureProperUse();

    if (whenInRoute != null && _currentRoute != whenInRoute) {
      return Future.value(null);
    }

    Route<T> route = _getPageRouteBuilder(path, _getRouteArguments(navArguments: arguments));

    if (saveHistory) {
      _routesHistory.removeLast();
      _routesHistory.add(route);
    }
    return _navigatorKey.currentState!.pushReplacement(route);
  }

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
  Future<T?> goToAndRemoveUntil<T extends Object?>(String path, bool Function(Route<dynamic>) predicate, {NavigationArguments? arguments, String? whenInRoute}) {
    _ensureProperUse();

    if (whenInRoute != null && _currentRoute != whenInRoute) {
      return Future.value(null);
    }

    Route<T> route = _getPageRouteBuilder(path, _getRouteArguments(navArguments: arguments));

    if (saveHistory) {
      _routesHistory.removeWhere(predicate);
      _routesHistory.add(route);
    }
    return _navigatorKey.currentState!.pushAndRemoveUntil(route, predicate);
  }

  /// Removes all the top-most routes until the [predicate] returns `true`.
  ///
  /// The [predicate] is called with the current route as argument. If the
  /// predicate returns `true`, the navigator pops the route and stops. If the
  /// predicate returns `false`, the navigator continues to the next route.
  ///
  /// If the [predicate] is `null`, the navigator pops all routes until it has
  /// none left.
  FutureOr<void> backUntil(bool Function(Route<dynamic>) predicate) {
    _ensureProperUse();
    if (saveHistory) {
      _routesHistory.removeWhere(predicate);
    }
    _navigatorKey.currentState!.popUntil(predicate);
  }

  /// Pops the top-most route off the navigator that most tightly encloses the
  /// given [BuildContext].
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [back].
  FutureOr<void> back() {
    _ensureProperUse();
    if (saveHistory) {
      _routesHistory.removeLast();
    }
    _navigatorKey.currentState?.pop();
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
  FutureOr<void> removeRoute<T extends Object?>(Route<T> route) {
    _ensureProperUse();
    _navigatorKey.currentState?.removeRoute(route);
  }

  /// Pops the top-most route off the navigator that most tightly encloses the
  /// given [BuildContext] if possible.
  ///
  /// Returns `true` if the route was popped, `false` otherwise.
  ///
  /// The current route's [Route.didPop] method is called when the route is
  /// popped. This method is called regardless of whether the route is popped
  /// normally (e.g. by pressing the back button) or by calling [maybeBack].
  Future<bool> maybeBack() {
    _ensureProperUse();
    return _navigatorKey.currentState!.maybePop();
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
  Route<T> onGenerateRoute<T extends Object?>(RouteSettings routeSettings) {
    String routeName = routeSettings.name ?? "/";

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
  NavigationArguments _getRouteArguments({RouteSettings? routeSettings, NavigationArguments? navArguments}) {
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
  PageRouteBuilder<T> _getPageRouteBuilder<T extends Object?>(String route, NavigationArguments arguments) {
    
    FxRoute fxRoute = _routeBuilder(route);
    _currentRoute = fxRoute.settings?.name ?? route;
    
    return PageRouteBuilder(
      settings: fxRoute.settings ??  RouteSettings(name: route, arguments: arguments.payload),
      pageBuilder: (context, animation, secondaryAnimation) => fxRoute.child,
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
  Animation<Offset> _getTransition(Animation<double> animation, TransitionDirection transition, Curve curve) {
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
