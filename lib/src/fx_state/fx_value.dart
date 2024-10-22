import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_fx/src/fx_state/fx_widgets.dart';

import 'fx_notifier.dart';

/// Type aliases for common `Fx` types.

/// A type alias for `Fx<String>`.
///
/// Use this type alias to create an `Fx` instance that wraps a string value.
typedef FxInt = Fx<int>;

/// Type aliases for common `Fx` types.

/// A type alias for `Fx<String>`.
///
/// Use this type alias to create an `Fx` instance that wraps a string value.
typedef FxString = Fx<String>;

/// A type alias for `Fx<bool>`.
///
/// Use this type alias to create an `Fx` instance that wraps a boolean value.
typedef FxBool = Fx<bool>;

/// A type alias for `Fx<List<T>>`.
///
/// Use this type alias to create an `Fx` instance that wraps a list of values of type `T`.
///
/// [T] is the type of the elements in the list.
typedef FxList<T> = Fx<List<T>>;

/// A type alias for `Fx<Map<T, M>>`.
///
/// Use this type alias to create an `Fx` instance that wraps a map with keys of type `T` and values of type `M`.
///
/// [T] is the type of the keys in the map.
/// [M] is the type of the values in the map.
typedef FxMap<T, M> = Fx<Map<T, M>>;

/// Extension to convert a value to a [Fx] instance.
extension FxValue<T> on T {
  /// Returns a [Fx] instance with [this] `T` as initial value.
  Fx<T> get toFx => Fx<T>(this);
}

/// The [FxNullable] class is a generic class that provides a way to create an [Fx] instance with a null value of type [T].
class FxNullable<T> {
  /// Returns an [Fx] instance with a null value of type `T`.
  ///
  /// This method is useful when you need to represent the absence of a value in a type-safe way.
  ///
  /// Returns an [Fx] instance containing a null value of type `T`.
  ///
  /// Example:
  /// ```dart
  /// FxNullable<String> nullableString = FxNullable<String>();
  /// Fx<String> nullFx = nullableString.setNull();
  /// print(nullFx.value); // prints: null
  /// ```
  Fx<T> setNull() => (null as T).toFx;
}

/// A generic class that wraps a value of type `T` and provides methods to listen to changes,
/// notify builders, and convert to JSON.
///
/// The [Fx] class is designed to be used with the `FxBuilder` widget to manage state in a
/// Flutter application.
class Fx<T extends dynamic> {
  late T _value;

  /// The internal identifier of this [Fx] instance.
  ///
  /// This identifier is used to uniquely identify this [Fx] instance and is generated
  /// randomly when the instance is created.
  final String internalIdentifier = "${Random.secure().nextDouble()}";

  Fx(this._value);

  /// Sets the value of this [Fx] instance and notifies any attached builders of the change.
  ///
  /// The `value` parameter is the new value of the [Fx] instance.
  set value(value) {
    _value = value;
    FxStateNotifier.instance.notifyBuilders(fxIdentifier);
  }

  /// Returns the current value of this [Fx] instance.
  T get value => _value;

  /// Listens to the changes of this [Fx] instance.
  ///
  /// The [BuildContext] passed as an argument is used to identify the
  /// [FxBuilder] that will receive the notifications when the value of this
  /// [Fx] instance changes.
  ///
  /// The [FxBuilder] must be an ancestor of the [BuildContext] passed as an
  /// argument.
  ///
  /// The value of this [Fx] instance is returned.
  T listen(FxBuildContext fxContext) {
    FxStateNotifier.instance.attachBuilder(fxIdentifier, fxContext);
    return _value;
  }

  /// Converts this `Fx` instance to a JSON representation.
  ///
  /// Returns the underlying value of this `Fx` instance as a JSON representation.
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
