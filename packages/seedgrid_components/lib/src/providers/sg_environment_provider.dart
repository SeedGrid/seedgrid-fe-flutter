// Porte de SgEnvironmentProvider (React: src/environment/SgEnvironmentProvider.tsx) e dos hooks
// useSgEnvironment, useHasSgEnvironmentProvider, useSgNamespaceProvider e useSgPersistence (aqui
// funcoes que recebem o `BuildContext`; Flutter nao tem hooks).
import 'dart:async';

import 'package:flutter/widgets.dart';

import '../generated/sg_environment_provider.g.dart';
import 'persistence.dart';

export 'persistence.dart';

/// Valores opcionais de `persistence` (no React o `value` e um `Partial<SgEnvironmentValue>` lido campo a campo).
class SgPersistencePartial {
  const SgPersistencePartial({this.scope, this.mode, this.stateVersion});

  final String? scope;
  final SgPersistenceMode? mode;
  final int? stateVersion;
}

/// `Partial<SgEnvironmentValue>`: o que faltar usa o padrao do ambiente.
class SgEnvironmentPartial {
  const SgEnvironmentPartial({
    this.namespaceProvider,
    this.persistenceStrategy,
    this.persistence,
  });

  final NamespaceProvider? namespaceProvider;
  final PersistenceStrategy? persistenceStrategy;
  final SgPersistencePartial? persistence;
}

const NamespaceProvider _defaultNamespaceProvider = NamespaceProvider(
  _emptyNamespace,
);
String? _emptyNamespace() => '';

PersistenceStrategy? _defaultStrategy;

/// Padrao sem provider: namespace vazio, persistencia local, escopo `app:unknown`, modo `fallback`,
/// versao 1.
SgEnvironmentValue get sgDefaultEnvironment => SgEnvironmentValue(
  namespaceProvider: _defaultNamespaceProvider,
  persistenceStrategy: _defaultStrategy ??= createLocalStorageStrategy(),
  persistence: const SgPersistenceConfig(
    scope: 'app:unknown',
    mode: SgPersistenceMode.fallback,
    stateVersion: 1,
  ),
);

class SgEnvironmentProvider extends StatelessWidget
    implements SgEnvironmentProviderProps {
  const SgEnvironmentProvider({super.key, this.value, required this.child});

  /// `value` do React (`Partial<SgEnvironmentValue>`).
  @override
  final SgEnvironmentPartial? value;

  /// `children` no React.
  @override
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final def = sgDefaultEnvironment;
    final resolved = SgEnvironmentValue(
      namespaceProvider: value?.namespaceProvider ?? _defaultNamespaceProvider,
      persistenceStrategy:
          value?.persistenceStrategy ?? def.persistenceStrategy,
      persistence: SgPersistenceConfig(
        scope: value?.persistence?.scope ?? def.persistence.scope,
        mode: value?.persistence?.mode ?? def.persistence.mode,
        stateVersion:
            value?.persistence?.stateVersion ?? def.persistence.stateVersion,
      ),
    );
    return _SgEnvironmentScope(value: resolved, child: child);
  }
}

class _SgEnvironmentScope extends InheritedWidget {
  const _SgEnvironmentScope({required this.value, required super.child});

  final SgEnvironmentValue value;

  @override
  bool updateShouldNotify(_SgEnvironmentScope old) =>
      !identical(old.value.namespaceProvider, value.namespaceProvider) ||
      !identical(old.value.persistenceStrategy, value.persistenceStrategy) ||
      old.value.persistence.scope != value.persistence.scope ||
      old.value.persistence.mode != value.persistence.mode ||
      old.value.persistence.stateVersion != value.persistence.stateVersion;
}

/// `useSgEnvironment()`: o ambiente do provider mais proximo, ou o padrao.
SgEnvironmentValue useSgEnvironment(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<_SgEnvironmentScope>()?.value ??
    sgDefaultEnvironment;

/// `useHasSgEnvironmentProvider()`.
bool useHasSgEnvironmentProvider(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<_SgEnvironmentScope>() != null;

/// `useSgNamespaceProvider()`.
NamespaceProvider useSgNamespaceProvider(BuildContext context) =>
    useSgEnvironment(context).namespaceProvider;

/// Resultado de `useSgPersistence()`: `load`, `save` e `clear` ja com a chave final
/// (`sg:<namespace>[:<scope>]:<baseKey>`). Sem namespace nada e lido nem gravado.
class SgPersistence {
  SgPersistence._(this._env, this.namespace)
    : scope = _env.persistence.scope,
      mode = _env.persistence.mode,
      stateVersion = _env.persistence.stateVersion;

  final SgEnvironmentValue _env;
  final String? namespace;
  final String scope;
  final SgPersistenceMode mode;
  final int stateVersion;

  /// Chave final de [baseKey], ou `null` sem namespace.
  String? fullKeyOf(String baseKey) =>
      buildSgPersistenceKey(baseKey, namespace, scope);

  Future<Object?> load(String baseKey) async {
    final key = fullKeyOf(baseKey);
    if (key == null) return null;
    return await _env.persistenceStrategy.load(key);
  }

  Future<void> save(String baseKey, Object? state) async {
    final key = fullKeyOf(baseKey);
    if (key == null) return;
    await _env.persistenceStrategy.save(key, state);
  }

  Future<void> clear(String baseKey) async {
    final key = fullKeyOf(baseKey);
    if (key == null) return;
    await _env.persistenceStrategy.clear(key);
  }
}

/// `useSgPersistence()`.
SgPersistence useSgPersistence(BuildContext context) {
  final env = useSgEnvironment(context);
  return SgPersistence._(env, env.namespaceProvider.getNamespace());
}
