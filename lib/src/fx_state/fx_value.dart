import 'fx_notifier.dart';
import 'package:flutter/widgets.dart';

class Fx <T extends dynamic>{
  T _value;
  
  Fx(this._value);
  
  set value(value){
    _value = value;
    FxNotifier.propagateNotification("$hashCode:$runtimeType");
  }

  T get value {
    return _value;
  }
}

extension FxT<T> on T {
  /// Returns a `Fx` instance with [this] `T` as initial value.
  Fx<T> get toFx => Fx<T>(this);
}

extension SenderPropagation on Fx {
  T listen<T>(BuildContext context) {
    if(!FxNotifier.verifyContextAssociation("${context.hashCode}:${context.runtimeType}")){
      throw Exception("Improper use of context for the listeners. There is not a listener with the key-> $hashCode:$runtimeType");
    }
    FxNotifier.addContextAssociation("$hashCode:$runtimeType", context);
    FxNotifier.addListenerAssociation("$hashCode:$runtimeType", "${context.hashCode}:${context.runtimeType}");
    return _value;
  }
}