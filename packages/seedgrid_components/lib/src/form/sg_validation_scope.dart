// Escopo de validacao de etapa: campos fora de um SgForm (sem `name`) se registram aqui e o SgWizard os valida
// ao avancar, como o React, que foca e sai de cada <input> da pagina e conta os `[data-sg-error]`.
import 'package:flutter/widgets.dart';

/// Campo que sabe se validar sob demanda (o mesmo que a validacao da perda de foco).
abstract interface class SgSelfValidating {
  /// Roda a validacao do campo (mostrando a mensagem) e devolve `true` se nao ha erro.
  bool validateNow();
}

/// Campos registrados num [SgValidationScope].
class SgValidationRegistry {
  final Set<SgSelfValidating> _items = <SgSelfValidating>{};

  void add(SgSelfValidating field) => _items.add(field);
  void remove(SgSelfValidating field) => _items.remove(field);

  /// Valida TODOS (sem parar no primeiro, para cada campo mostrar o seu erro) e diz se todos passaram.
  bool validateAll() {
    var ok = true;
    for (final f in List<SgSelfValidating>.of(_items)) {
      if (!f.validateNow()) ok = false;
    }
    return ok;
  }
}

/// Oferece o [SgValidationRegistry] aos campos abaixo.
class SgValidationScope extends InheritedWidget {
  const SgValidationScope({
    super.key,
    required this.registry,
    required super.child,
  });

  final SgValidationRegistry registry;

  static SgValidationRegistry? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SgValidationScope>()?.registry;

  @override
  bool updateShouldNotify(SgValidationScope old) => registry != old.registry;
}
