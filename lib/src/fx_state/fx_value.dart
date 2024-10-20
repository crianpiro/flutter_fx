import 'dart:math';

import 'package:flutter/widgets.dart';

import 'fx_notifier.dart';
import 'fx_state.dart';

typedef FxString = Fx<String>;
typedef FxBool = Fx<bool>;
typedef FxList<T> = Fx<List<T>>;
typedef FxMap<T, M> = Fx<Map<T, M>>;


/// Extension to convert a value to a `Fx` instance.
extension FxValue<T> on T {
  /// Returns a `Fx` instance with [this] `T` as initial value.
  Fx<T> get toFx => Fx<T>(this);
  
  /// Returns a `Fx` instance with `null` of `T` as initial value.
  Fx<T?> get toFxNullable => (null as T?).toFx;
}

class Fx<T extends dynamic> {
  late T _value;

  final String internalIdentifier = "${Random.secure().nextDouble()}";

  Fx(this._value);

  set value(value) {
    _value = value;    
    FxStateNotifier.instance.notifyBuilders(fxIdentifier);
  }

  T get value => _value;

  /// Listens to the changes of this `Fx` instance.
  ///
  /// The [BuildContext] passed as an argument is used to identify the
  /// [FxBuilder] that will receive the notifications when the value of this
  /// `Fx` instance changes.
  ///
  /// The [FxBuilder] must be an ancestor of the [BuildContext] passed as an
  /// argument.
  ///
  /// The value of this `Fx` instance is returned.
  T listen(FxBuildContext fxContext) {
    FxStateNotifier.instance.attachBuilder(fxIdentifier, fxContext);
    return _value;
  }

  dynamic toJson() => _value;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is T) return _value == other;
    return false;
  }

  @override
  String toString() => _value.toString();
}
