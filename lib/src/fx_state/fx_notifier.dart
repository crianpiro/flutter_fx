import 'dart:developer';
import 'package:flutter/widgets.dart';

@immutable
final class StateNotification extends Notification {
  final String stateKey;
  const StateNotification(this.stateKey);
}

@immutable
final class FxNotifier {
  static final Map<String, BuildContext> _contextsAssociation = {};
  static final Map<String, String> _listenersAssociation = {};

  static final Map<String, Function()> _listeners = {};

  static void addContextAssociation(
      String stateKey, BuildContext contextToAssociate) {
    if (!_contextsAssociation.containsKey(stateKey)) {
      log("Adding context association for $stateKey -> ${contextToAssociate.hashCode}:${contextToAssociate.runtimeType}");
      _contextsAssociation[stateKey] = contextToAssociate;
    }
  }

  static void addListenerAssociation(
      String stateKey, String listenableToAssociate) {
    if (!_listenersAssociation.containsKey(stateKey)) {
      log("Adding listener association for $stateKey -> $listenableToAssociate");
      _listenersAssociation[stateKey] = listenableToAssociate;
    }
  }

  static void addUpdater(String stateKey, Function() updater) {
    if (!_listeners.containsKey(stateKey)) {
      log("Adding updater for -> $stateKey");
      _listeners[stateKey] = updater;
    }
  }

  static void propagateNotification(String stateKey) {
    log("Propagating the notification over context: ${FxNotifier._contextsAssociation[stateKey].hashCode}:${FxNotifier._contextsAssociation[stateKey].runtimeType}");
    StateNotification(stateKey)
        .dispatch(FxNotifier._contextsAssociation[stateKey]!);
  }

  static bool verifyContextAssociation(String stateKey) {
    log("Verifying context association for -> $stateKey");
    return _listeners.containsKey(stateKey);
  }

  static bool triggerUpdater(String stateKey) {
    if (_listenersAssociation.containsKey(stateKey)) {
      log("Triggering updater for -> $stateKey");
      _listeners[_listenersAssociation[stateKey]]!();
    }
    return true;
  }
}
