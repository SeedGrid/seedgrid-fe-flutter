// Porte de src/environment/persistent-state.ts (funcoes puras sobre um storage de texto) e do hook
// `useSgPersistentState` (aqui [SgPersistentState] + [SgPersistentStateBuilder], porque Flutter nao
// tem hooks).
import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sg_environment_provider.dart';

/// `Pick<Storage, "getItem" | "setItem" | "removeItem">` do React.
abstract class SgStringStorage {
  String? getItem(String key);
  void setItem(String key, String value);
  void removeItem(String key);
}

/// [SgStringStorage] sobre uma instancia ja carregada de `SharedPreferences`.
class SharedPreferencesStorage implements SgStringStorage {
  SharedPreferencesStorage(this.prefs);

  final SharedPreferences prefs;

  @override
  String? getItem(String key) => prefs.getString(key);
  @override
  void setItem(String key, String value) =>
      unawaited(prefs.setString(key, value));
  @override
  void removeItem(String key) => unawaited(prefs.remove(key));
}

/// `null` => [defaultValue]; senao [deserialize] do valor carregado.
T resolvePersistedStateValue<T>({
  required Object? loaded,
  required T defaultValue,
  required T Function(Object? value) deserialize,
}) {
  if (loaded == null) return defaultValue;
  return deserialize(loaded);
}

T readLocalPersistentState<T>({
  required SgStringStorage storage,
  required String baseKey,
  required T defaultValue,
  required T Function(Object? value) deserialize,
}) {
  try {
    final raw = storage.getItem(baseKey);
    if (raw == null) return defaultValue;
    return resolvePersistedStateValue(
      loaded: jsonDecode(raw),
      defaultValue: defaultValue,
      deserialize: deserialize,
    );
  } catch (_) {
    return defaultValue;
  }
}

void writeLocalPersistentState<T>({
  required SgStringStorage storage,
  required String baseKey,
  required T value,
}) {
  storage.setItem(baseKey, jsonEncode(value));
}

T clearLocalPersistentState<T>({
  required SgStringStorage storage,
  required String baseKey,
  required T defaultValue,
}) {
  storage.removeItem(baseKey);
  return defaultValue;
}

/// Estado persistido (equivale ao retorno de `useSgPersistentState`): `value`, `setValue`, `clear` e
/// `hydrated`. Carrega ao criar e grava a cada mudanca depois de hidratado.
///
/// Com [SgEnvironmentProvider] acima usa a estrategia do ambiente (chave com namespace e escopo);
/// sem ele usa o armazenamento local com a chave crua, como o React.
class SgPersistentState<T> extends ChangeNotifier {
  SgPersistentState({
    required this.baseKey,
    required this.defaultValue,
    required this.persistence,
    required this.hasProvider,
    Object? Function(T value)? serialize,
    T Function(Object? value)? deserialize,
    SgStringStorage? localStorage,
  }) : _serialize = serialize ?? ((v) => v),
       _deserialize = deserialize ?? ((v) => v as T),
       _localStorage = localStorage,
       _value = defaultValue {
    unawaited(_hydrate());
  }

  /// Cria a partir do `context` (equivale ao hook): le o ambiente mais proximo.
  factory SgPersistentState.of(
    BuildContext context, {
    required String baseKey,
    required T defaultValue,
    Object? Function(T value)? serialize,
    T Function(Object? value)? deserialize,
    SgStringStorage? localStorage,
  }) => SgPersistentState<T>(
    baseKey: baseKey,
    defaultValue: defaultValue,
    persistence: useSgPersistence(context),
    hasProvider: useHasSgEnvironmentProvider(context),
    serialize: serialize,
    deserialize: deserialize,
    localStorage: localStorage,
  );

  final String baseKey;
  final T defaultValue;
  final SgPersistence persistence;
  final bool hasProvider;
  final Object? Function(T value) _serialize;
  final T Function(Object? value) _deserialize;
  final SgStringStorage? _localStorage;

  T _value;
  bool _hydrated = false;
  bool _disposed = false;

  T get value => _value;
  bool get hydrated => _hydrated;

  Future<SgStringStorage> _storage() async =>
      _localStorage ??
      SharedPreferencesStorage(await SharedPreferences.getInstance());

  Future<void> _hydrate() async {
    try {
      final Object? loaded;
      if (hasProvider) {
        loaded = await persistence.load(baseKey);
      } else {
        loaded = readLocalPersistentState<Object?>(
          storage: await _storage(),
          baseKey: baseKey,
          defaultValue: null,
          deserialize: (v) => v,
        );
      }
      if (_disposed) return;
      _value = resolvePersistedStateValue(
        loaded: loaded,
        defaultValue: defaultValue,
        deserialize: _deserialize,
      );
    } catch (_) {
      if (_disposed) return;
      _value = defaultValue;
    }
    _hydrated = true;
    notifyListeners();
  }

  /// `setValue(next)`; grava depois da hidratacao (antes disso so guarda em memoria).
  Future<void> setValue(T next) async {
    _value = next;
    notifyListeners();
    if (!_hydrated) return;
    if (hasProvider) {
      try {
        await persistence.save(baseKey, _serialize(next));
      } catch (_) {
        // ignora (como o `void persistence.save` do React)
      }
    } else {
      try {
        writeLocalPersistentState(
          storage: await _storage(),
          baseKey: baseKey,
          value: _serialize(next),
        );
      } catch (_) {
        // ignora
      }
    }
  }

  /// Apaga o valor persistido e volta ao padrao.
  Future<void> clear() async {
    if (hasProvider) {
      await persistence.clear(baseKey);
    } else {
      try {
        clearLocalPersistentState(
          storage: await _storage(),
          baseKey: baseKey,
          defaultValue: defaultValue,
        );
      } catch (_) {
        // ignora
      }
    }
    _value = defaultValue;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Dono do ciclo de vida de um [SgPersistentState]: cria ao montar, descarta ao sair e reconstroi a
/// cada mudanca. E o equivalente de chamar `useSgPersistentState` dentro de um componente.
class SgPersistentStateBuilder<T> extends StatefulWidget {
  const SgPersistentStateBuilder({
    super.key,
    required this.baseKey,
    required this.defaultValue,
    required this.builder,
    this.serialize,
    this.deserialize,
    this.localStorage,
  });

  final String baseKey;
  final T defaultValue;
  final Object? Function(T value)? serialize;
  final T Function(Object? value)? deserialize;
  final SgStringStorage? localStorage;
  final Widget Function(BuildContext context, SgPersistentState<T> state)
  builder;

  @override
  State<SgPersistentStateBuilder<T>> createState() =>
      _SgPersistentStateBuilderState<T>();
}

class _SgPersistentStateBuilderState<T>
    extends State<SgPersistentStateBuilder<T>> {
  SgPersistentState<T>? _state;

  // Recria o estado quando o ambiente (namespace, escopo, provider) ou a chave mudam, como o
  // useEffect com dependencias do React.
  void _ensure() {
    final persistence = useSgPersistence(context);
    final has = useHasSgEnvironmentProvider(context);
    final old = _state;
    if (old == null ||
        old.baseKey != widget.baseKey ||
        old.persistence.fullKeyOf(old.baseKey) !=
            persistence.fullKeyOf(widget.baseKey) ||
        old.hasProvider != has) {
      old?.dispose();
      _state = SgPersistentState<T>(
        baseKey: widget.baseKey,
        defaultValue: widget.defaultValue,
        persistence: persistence,
        hasProvider: has,
        serialize: widget.serialize,
        deserialize: widget.deserialize,
        localStorage: widget.localStorage,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensure();
  }

  @override
  void didUpdateWidget(SgPersistentStateBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensure();
  }

  @override
  void dispose() {
    _state?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _state!;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => widget.builder(context, state),
    );
  }
}
