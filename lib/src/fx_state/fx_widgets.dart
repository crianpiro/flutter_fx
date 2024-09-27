import 'package:flutter/widgets.dart';

import 'fx_notifier.dart';


class FxBuilder extends FxWidget {
  final Widget Function(BuildContext fxContext) builder;

  const FxBuilder({required this.builder,super.key});

  @override
  Widget build(BuildContext fxContext) => builder(fxContext);
}

sealed class FxWidget extends StatefulWidget {
  const FxWidget({super.key});

  @override
  State createState() => _FxState();

  @protected
  Widget build(BuildContext fxContext);
}

class _FxState extends State<FxWidget> {

  @override
  void initState() {
    FxStateNotifier.instance
        .attachUpdater(context.fxIdentifier, _onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    FxStateNotifier.instance.detachBuilder(context.fxIdentifier);
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
  }

  @override
  /// This implementation of [State.build] simply calls the [build]
  /// function of the [FxWidget] and returns the result.
  ///
  /// See also:
  ///
  ///  * [FxWidget.build], the function that is called to build the widget.
  Widget build(BuildContext context) => widget.build(context);
}
