import 'dart:collection';
import 'dart:developer';
import 'package:flutter/widgets.dart';

@immutable
final class StateNotification extends Notification {
  final String stateKey;
  const StateNotification(this.stateKey);
}

typedef ContextSubcriptions = LinkedHashMap<String, BuildContext>;

extension CustomKeyExtension<T> on T {
  String get customIdentifier => "$hashCode:$runtimeType";
}

abstract class FxNotifier {
  void attachUpdater(String receiverContextKey, Function() updater);
  void attachReceiver(String stateKey, String receiverContextKey);
  void attachReceiverContext(BuildContext receiverContext);
  void notifyReceivers(String stateKey);
  bool validateAttachedUpdater(String receiverContextKey);
  bool triggerUpdater(String receiverContextKey);
  void unAttach(String stateKey, String receiverContextKey);
}

final class FxStateNotifier extends FxNotifier {
  static FxStateNotifier? _instance;

  factory FxStateNotifier() => _instance ??= FxStateNotifier._();

  FxStateNotifier._();

  static FxStateNotifier get instance => FxStateNotifier();

  final Map<String, BuildContext> _attachedContexts = {};
  final Map<String, LinkedHashSet<String>> _attachedReceivers = {};
  final Map<String, Function()> _updaters = {};

  @override
  void attachReceiverContext(BuildContext receiverContext) {
    log("Attaching context: ${receiverContext.customIdentifier}");

    if (!_attachedContexts.containsKey(receiverContext.customIdentifier)) {
      _attachedContexts[receiverContext.customIdentifier] = receiverContext;
    }

    // _attachedContexts[stateKey]![context.customIdentifier] = context;
  }

  @override
  void attachReceiver(String stateKey, String receiverContextKey) {
    log("Attaching listener: $receiverContextKey -> $stateKey");

    if (!_attachedReceivers.containsKey(stateKey)) {
      _attachedReceivers[stateKey] = LinkedHashSet();
    }

    if (!_attachedReceivers[stateKey]!.contains(receiverContextKey)) {
      _attachedReceivers[stateKey]!.add(receiverContextKey);
    }
  }

  @override
  void attachUpdater(String receiverContextKey, dynamic Function() updater) {
    if (!_updaters.containsKey(receiverContextKey)) {
      log("Attaching updater for -> $receiverContextKey");
      _updaters[receiverContextKey] = updater;
    }
  }

  @override
  void notifyReceivers(String stateKey) {
    if (_attachedReceivers.containsKey(stateKey)) {
      LinkedHashSet<String> receivers = _attachedReceivers[stateKey]!;


      for (String receiverKey in receivers) {
        log("Notifying receivers over context: $receiverKey");
        StateNotification(stateKey).dispatch(_attachedContexts[receiverKey]!);
      }
    }
  }

  @override
  bool validateAttachedUpdater(String receiverContextKey) {
    log("Validate attached updater for -> $receiverContextKey");
    return _updaters.containsKey(receiverContextKey);
  }

  @override
  bool triggerUpdater(String receiverContextKey) {
    if (_attachedReceivers.containsKey(receiverContextKey) && _updaters.containsKey(receiverContextKey)) {
      _updaters[receiverContextKey]?.call();
      return true;
    }

    throw FlutterError("Not updater found for -> $receiverContextKey.");
  }

  @override
  void unAttach(String stateKey, String receiverContextKey) {
    _attachedContexts.remove(receiverContextKey);
    _attachedReceivers[stateKey]?.remove(receiverContextKey);
    _updaters.remove(receiverContextKey);
  }
}
