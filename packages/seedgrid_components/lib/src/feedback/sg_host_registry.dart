// Registro de hosts (porte de sgToastHostRegistry.ts e sgWhistleHostRegistry.ts).
// Cada SgToastHost/SgWhistleHost se empilha aqui; o host mais recente e o ativo e o toaster/whistler
// "solto" cede a vez quando existe algum host. As notificacoes sao adiadas (microtask) porque quem
// registra/desregistra roda dentro de initState/dispose, onde chamar setState de outro widget e erro.
import 'dart:async';

import 'package:flutter/foundation.dart';

class SgHostRegistry {
  SgHostRegistry(this._prefix);

  final String _prefix;
  int _counter = 0;
  final List<String> _stack = [];
  final Set<VoidCallback> _listeners = {};

  String nextId() => '$_prefix-${++_counter}';

  void register(String id) {
    if (!_stack.contains(id)) {
      _stack.add(id);
      _notify();
    }
  }

  void unregister(String id) {
    if (_stack.remove(id)) _notify();
  }

  /// Host ativo: o ultimo a registrar.
  String? get activeId => _stack.isEmpty ? null : _stack.last;

  bool get hasAny => _stack.isNotEmpty;

  /// Devolve a funcao que cancela a assinatura.
  VoidCallback subscribe(VoidCallback fn) {
    _listeners.add(fn);
    return () => _listeners.remove(fn);
  }

  void _notify() {
    scheduleMicrotask(() {
      for (final l in List.of(_listeners)) {
        l();
      }
    });
  }
}

/// Hosts de toast (`SgToastHost`).
final SgHostRegistry sgToastHostRegistry = SgHostRegistry('sg-toast-host');

/// Hosts de whistle (`SgWhistleHost`).
final SgHostRegistry sgWhistleHostRegistry = SgHostRegistry('sg-whistle-host');
