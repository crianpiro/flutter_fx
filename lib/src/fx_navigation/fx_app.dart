import 'package:flutter/widgets.dart';
import 'fx_router.dart';

@immutable
final class FxApp extends StatelessWidget {
  final Color appColor;
  final String initialRoute;
  final Widget Function(String route) routeBuilder;

  const FxApp(
      {super.key,
      required this.initialRoute,
      required this.routeBuilder,
      this.appColor = const Color(0x00000000)});

  final GlobalKey<NavigatorState> _navKey = const GlobalObjectKey(
      "FxApplication_NavigatorKey_k%6gh*kj87?612h23!98hkjsad9");

  @override
  Widget build(BuildContext context) {
    FxRouter.init(_navKey,routeBuilder);
    return WidgetsApp(
      navigatorKey: _navKey,
      color: appColor,
      initialRoute: '/',
      onGenerateRoute: FxRouter.onGenerateRoute,
    );
  }
}