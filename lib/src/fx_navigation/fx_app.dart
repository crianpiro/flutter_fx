import 'package:flutter/material.dart';
import 'fx_router.dart';

///[FxApp] sets up the [FxRouter] to navigate between routes, using a [WidgetsApp] as skeleton.
///[title] The title of the application
///[initialRoute] The initial route of the app. This is a required parameter.
///[routeBuilder] A function that builds a widget for a given route. This is a required parameter.
///[appColor] The color of the app. This is an optional parameter that defaults to transparent (Color(0x00000000)).

@immutable
final class FxApp extends StatelessWidget {
  final Color appColor;
  final String title;
  final String initialRoute;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Widget Function(String route) routeBuilder;

  const FxApp(
      {super.key,
      this.theme,
      this.title = "",
      this.darkTheme,
      this.localizationsDelegates,
      this.themeMode = ThemeMode.system,
      required this.initialRoute,
      required this.routeBuilder,
      this.appColor = const Color(0x00000000)});

  final GlobalKey<NavigatorState> _navKey = const GlobalObjectKey(
      "FxApplication_NavigatorKey_k%6gh*kj87?612h23!98hkjsad9");

  @override
  Widget build(BuildContext context) {
    FxRouter.init(_navKey, routeBuilder);
    return MaterialApp(
      title: title,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      navigatorKey: _navKey,
      localizationsDelegates: [
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        ...?localizationsDelegates,
      ],
      color: appColor,
      initialRoute: '/',
      onGenerateRoute: FxRouter.onGenerateRoute,
    );
  }
}
