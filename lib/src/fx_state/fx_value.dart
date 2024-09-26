import 'fx_notifier.dart';
import 'package:flutter/widgets.dart';

class Fx <T extends dynamic>{
  T _value;
  
  Fx(this._value);
  
  set value(value){
    _value = value;
    FxStateNotifier.instance.notifyReceivers("$hashCode:$runtimeType");
  }

  T get value {
    return _value;
  }
}

extension FxT<T> on T {
  /// Returns a `Fx` instance with [this] `T` as initial value.
  Fx<T> get toFx => Fx<T>(this);
}

extension ReceiverListener on Fx {
  T listen<T>(BuildContext fxContext) {
    if(!FxStateNotifier.instance.validateAttachedUpdater(fxContext.customIdentifier)){
      throw FlutterError("Improper use of context for the listeners. There is not a listener with the key-> $customIdentifier");
    }
    FxStateNotifier.instance.attachReceiverContext(fxContext);
    FxStateNotifier.instance.attachReceiver(customIdentifier, fxContext.customIdentifier);
    return _value;
  }
}