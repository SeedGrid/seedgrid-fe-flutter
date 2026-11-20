// Registro de acoes por tipo de notificacao (P186), porte de `notificationActions.ts` (React). Quem sabe abrir
// (baixar o backup, ir a tela) e o modulo dono do tipo: ele registra a acao uma vez; o sino nao conhece tipo nenhum
// e o host nao precisa de `switch`.
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'sg_notification_bell_logic.dart';

/// Acao de abrir uma notificacao de um tipo.
class SgNotificationAction {
  const SgNotificationAction({required this.run, this.label, this.icon});

  /// Texto curto do que o toque faz (ex.: "Baixar"). Aparece no item abrivel.
  final String? label;

  /// Icone do item abrivel. Padrao: seta.
  final Widget? icon;

  /// Executa a acao. Recebe a notificacao (o `payload` so traz identificadores, nunca URL). Se lancar erro, o sino
  /// mostra a mensagem do erro no painel (use mensagens legiveis).
  final FutureOr<void> Function(SgNotification notification) run;
}

final Map<String, SgNotificationAction> _registry =
    <String, SgNotificationAction>{};
final _SgActionsNotifier _notifier = _SgActionsNotifier();

class _SgActionsNotifier extends ChangeNotifier {
  int version = 0;

  void changed() {
    version += 1;
    notifyListeners();
  }
}

/// Registra a acao de um tipo de notificacao (cada modulo registra os tipos que emite). Devolve a funcao que desfaz
/// o registro (so desfaz se a acao ainda for a mesma). Registrar de novo o mesmo tipo substitui a anterior.
void Function() registerNotificationAction(
  String type,
  SgNotificationAction action,
) {
  _registry[type] = action;
  _notifier.changed();
  return () {
    if (identical(_registry[type], action)) {
      _registry.remove(type);
      _notifier.changed();
    }
  };
}

/// Remove o registro de um tipo.
void unregisterNotificationAction(String type) {
  if (_registry.remove(type) != null) _notifier.changed();
}

/// Acao registrada para o tipo, se houver.
SgNotificationAction? getNotificationAction(String type) => _registry[type];

/// Para quem precisa reagir a registros tardios (o sino reconstroi o item).
Listenable get notificationActionsListenable => _notifier;

@visibleForTesting
int get notificationActionsVersion => _notifier.version;
