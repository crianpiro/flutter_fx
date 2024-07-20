import 'package:flutter/widgets.dart';
import 'fx_navigator.dart';
import 'fx_router.dart';

final class FxApp extends StatelessWidget {
  final String initialRoute;
  final Widget Function(String route) routeBuilder;
  final Color appColor;

  const FxApp(
      {super.key,
      required this.initialRoute,
      required this.routeBuilder,
      this.appColor = const Color(0x00000000)});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: FxNavigator(
          routeBuilder: routeBuilder,
          onGenerateRoute: (settings) =>
              FxRouter.getPageRouteBuilder(routeBuilder, settings.name ?? ""),
        ));

    // return WidgetsApp(
    //   home: const SizedBox.shrink(),
    //   color: appColor,
    //   builder: (navigatorContext, builder) {
    //     // ApplicationRouter.init(navigatorContext, buildRoute!);
    //     return buildRoute!(initialRoute);
    //   },
    //   // onUnknownRoute: (settings) => MaterialPageRoute(builder: (context) => FxView(route: settings.name!, child: buildRoute!(settings.name!))),
    // );
  }
}
