import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_fx/src/fx_state/fx_widgets.dart';

extension CustomKeyExtension<T> on T {
  String get fxIdentifier => "$hashCode:$runtimeType";
}

abstract class FxNotifier {
  void attachUpdater(String builderContextKey, Function() updater);
  void attachBuilder(String stateKey, BuildContext builderContext);
  void notifyBuilders(String stateKey);
  void detachBuilder(String builderContextKey);
  void ensureProperUse(BuildContext context);
}

final class FxStateNotifier extends FxNotifier {
  static FxStateNotifier? _instance;

  factory FxStateNotifier() => _instance ??= FxStateNotifier._();

  FxStateNotifier._();

  static FxStateNotifier get instance => FxStateNotifier();

  final Map<String, Function()> _updaters = {};
  final Map<String, LinkedHashSet<String>> _attachedBuilders = {};

  @override
  /// Attaches the builder's context to a state key.
  ///
  /// The builder is notified when the state changes.
  ///
  /// If the context is already attached, this method does nothing.
  void attachBuilder(String stateKey, BuildContext builderContext) {
    ensureProperUse(builderContext);
    
    if (!_attachedBuilders.containsKey(stateKey)) {
      _attachedBuilders[stateKey] = LinkedHashSet();
    }

    if (!_attachedBuilders[stateKey]!.contains(builderContext.fxIdentifier)) {
      _attachedBuilders[stateKey]!.add(builderContext.fxIdentifier);
    }
  }

  @override
  /// Attaches a widget's context to a state key to be notified when the
  /// state changes. 
  /// 
  /// The [updater] function is called when the state changes.
  ///
  /// The [builderContextKey] is a key that is used to identify the widget
  /// that should be notified when the state changes.
  ///
  /// If the [builderContextKey] is already attached, the [updater] is ignored.
  void attachUpdater(String builderContextKey, dynamic Function() updater) {
    if (!_updaters.containsKey(builderContextKey)) {
      _updaters[builderContextKey] = updater;
    }
  }

  @override

  /// Notify all builders that have been attached to [stateKey].
  ///
  /// The builders are notified by calling the [updater] function that was
  /// passed to [attachUpdater].
  ///
  /// If a builder has not been attached, it is ignored.
  void notifyBuilders(String stateKey) {
    if (_attachedBuilders.containsKey(stateKey)) {
      LinkedHashSet<String> receivers = _attachedBuilders[stateKey]!;

      for (String receiverKey in receivers) {
        if (_updaters.containsKey(receiverKey)) {
          _updaters[receiverKey]?.call();
        }
      }
    }
  }

  

  @override
  /// Detaches a widget's context from a state key.
  ///
  /// The context is no longer notified when the state changes.
  ///
  /// If the context is not attached, this method does nothing.
  void detachBuilder(String builderContextKey) {
    _updaters.remove(builderContextKey);
    for (LinkedHashSet receivers in _attachedBuilders.values) {
      if (receivers.contains(builderContextKey)){
        receivers.remove(builderContextKey);
      }
    }
  }
  
  @override
  /// Ensures that a [Fx] is being used properly.
  ///
  /// Checks that the [Fx] is being listened to inside a [FxBuilder] and
  /// that the context passed to [Fx] is from a [FxBuilder].
  ///
  /// Throws a [FlutterError] if the usage is not proper.
  void ensureProperUse(BuildContext context) {

    final FlutterError error = FlutterError("""Improper use of a [FxValue] variable
        * The [FxValue]s can only be listened inside a FxBuilder.
        * The [FxValue.listen] method can only be used with a context from a FxBuilder.""");

    if(!_updaters.containsKey(context.fxIdentifier) || context.widget is! FxBuilder){
      throw error;
    }
  }
}
