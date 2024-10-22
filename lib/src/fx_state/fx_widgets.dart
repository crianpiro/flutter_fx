import 'dart:math';

import 'package:flutter/widgets.dart';

import 'fx_notifier.dart';

class FxBuildContext {
  BuildContext context;
  String fxIdentifier;

  FxBuildContext(this.context, this.fxIdentifier);
}

class FxBuilder extends FxWidget {
  final Widget Function(FxBuildContext fxContext) builder;

  const FxBuilder({required this.builder, super.key});

  @override
  Widget build(FxBuildContext fxContext) => builder(fxContext);
}

sealed class FxWidget extends StatefulWidget {
  const FxWidget({super.key});

  @override
  State createState() => _FxState();

  @protected
  Widget build(FxBuildContext fxContext);
}

class _FxState extends State<FxWidget> {
  final String internalIdentifier = "${Random.secure().nextDouble()}";

  @override
  void initState() {
    FxStateNotifier.instance.attachUpdater(internalIdentifier, _onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    FxStateNotifier.instance.detachBuilder(internalIdentifier);
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
  Widget build(BuildContext context) =>
      widget.build(FxBuildContext(context, internalIdentifier));
}
