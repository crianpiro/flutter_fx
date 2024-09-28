import 'package:flutter/widgets.dart';
import 'fx_router.dart';

///[FxApp] sets up the [FxRouter] to navigate between routes, using a [WidgetsApp] as skeleton.
///[initialRoute] The initial route of the app. This is a required parameter.
///[routeBuilder] A function that builds a widget for a given route. This is a required parameter.
///[appColor] The color of the app. This is an optional parameter that defaults to transparent (Color(0x00000000)).

@immutable
final class FxApp extends StatelessWidget {
  final Color appColor;
  final String title;
  final String initialRoute;
  final Widget Function(String route) routeBuilder;

  const FxApp(
      {super.key,
      this.title = "",
      required this.initialRoute,
      required this.routeBuilder,
      this.appColor = const Color(0x00000000)});

  final GlobalKey<NavigatorState> _navKey = const GlobalObjectKey(
      "FxApplication_NavigatorKey_k%6gh*kj87?612h23!98hkjsad9");

  @override
  Widget build(BuildContext context) {
    FxRouter.init(_navKey, routeBuilder);
    return WidgetsApp(
      title: title,
      navigatorKey: _navKey,
      color: appColor,
      initialRoute: '/',
      onGenerateRoute: FxRouter.onGenerateRoute,
    );
  }
}
