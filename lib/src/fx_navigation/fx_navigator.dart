
import 'fx_router.dart';
import 'package:flutter/widgets.dart';

@immutable
final class FxNavigator extends Navigator {
  final Widget Function(String route) routeBuilder;
  const FxNavigator({
    required this.routeBuilder,
    required super.onGenerateRoute,
    super.key});

  @override
  FxNavigatorState createState() => FxNavigatorState();
}

class FxNavigatorState extends NavigatorState {
  @override
  Widget build(BuildContext context) {
    FxRouter.iniContext(context);
    return super.build(context);
  }
}