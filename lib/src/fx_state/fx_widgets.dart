import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'fx_notifier.dart';

class FxBuilder  extends StatelessWidget {

  final Widget Function(BuildContext fxContext) builder;

  const FxBuilder({required this.builder,super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<StateNotification>(
      onNotification: (notification) => FxStateNotifier.instance.triggerUpdater(notification.stateKey),
      child: FxReceiver(builder),
    );
  }
}

class FxReceiver extends FxWidget{
  final Widget Function(BuildContext fxContext) builder;

  const FxReceiver(this.builder, {super.key});

  @override
  void onStateChanged(BuildContext fxContext, Function() updater) {
    FxStateNotifier.instance.attachUpdater(fxContext.customIdentifier, updater);
  }

  @override
  Widget build(BuildContext fxContext) {
    return  builder(fxContext);
  }
}

sealed class FxWidget extends StatefulWidget {
  const FxWidget({super.key});

  @override
  FxState createState() => FxState();

  @protected
  Widget build(BuildContext fxContext);

  @protected
  void onStateChanged(BuildContext fxContext, Function() updater);
}

class FxState extends State<FxWidget> {

  bool initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(!initialized){
      initialized = true;
      widget.onStateChanged(context, (){
        log("Updating state");
        setState(() {});
      }); 
    }
    
    return widget.build(context);
  }
}