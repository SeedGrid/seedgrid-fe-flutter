// Porte de src/environment/persistence.ts: tipos, chave de persistencia e as tres estrategias
// (local, API e composite). `localStorage` do React vira `shared_preferences` (na Web o Flutter usa o
// localStorage por baixo, com o prefixo `flutter.`).
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'sg_fetch.dart';

/// `{ getNamespace: () => string | null }` do React.
class NamespaceProvider {
  const NamespaceProvider(this.getNamespace);

  final String? Function() getNamespace;
}

/// Estrategia de persistencia: `load`, `save` e `clear` por chave. Pode ser sincrona ou assincrona.
abstract class PersistenceStrategy {
  const PersistenceStrategy();

  /// Monta uma estrategia a partir de funcoes (equivale a um objeto literal no React).
  const factory PersistenceStrategy.from({
    required FutureOr<Object?> Function(String key) load,
    required FutureOr<void> Function(String key, Object? state) save,
    required FutureOr<void> Function(String key) clear,
  }) = _FunctionPersistenceStrategy;

  FutureOr<Object?> load(String key);
  FutureOr<void> save(String key, Object? state);
  FutureOr<void> clear(String key);
}

class _FunctionPersistenceStrategy extends PersistenceStrategy {
  const _FunctionPersistenceStrategy({
    required FutureOr<Object?> Function(String key) load,
    required FutureOr<void> Function(String key, Object? state) save,
    required FutureOr<void> Function(String key) clear,
  }) : _load = load,
       _save = save,
       _clear = clear;

  final FutureOr<Object?> Function(String key) _load;
  final FutureOr<void> Function(String key, Object? state) _save;
  final FutureOr<void> Function(String key) _clear;

  @override
  FutureOr<Object?> load(String key) => _load(key);
  @override
  FutureOr<void> save(String key, Object? state) => _save(key, state);
  @override
  FutureOr<void> clear(String key) => _clear(key);
}

/// Registro enviado e recebido pela persistencia por API (`SgPersistenceRecordDTO`).
class SgPersistenceRecordDTO {
  const SgPersistenceRecordDTO({
    this.protocolVersion = 1,
    required this.key,
    required this.scope,
    required this.stateVersion,
    required this.updatedAt,
    required this.state,
  });

  factory SgPersistenceRecordDTO.fromJson(Map<String, Object?> json) =>
      SgPersistenceRecordDTO(
        protocolVersion: (json['protocolVersion'] as num?)?.toInt() ?? 1,
        key: json['key'] as String,
        scope: json['scope'] as String,
        stateVersion: (json['stateVersion'] as num).toInt(),
        updatedAt: json['updatedAt'] as String,
        state: json['state'],
      );

  final int protocolVersion;
  final String key;
  final String scope;
  final int stateVersion;

  /// ISO 8601.
  final String updatedAt;
  final Object? state;

  Map<String, Object?> toJson() => {
    'protocolVersion': protocolVersion,
    'key': key,
    'scope': scope,
    'stateVersion': stateVersion,
    'updatedAt': updatedAt,
    'state': state,
  };
}

/// `"strict" | "fallback" | "mirror"`.
enum SgPersistenceMode {
  strict('strict'),
  fallback('fallback'),
  mirror('mirror');

  const SgPersistenceMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgPersistenceMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// `{ scope, mode, stateVersion }`.
class SgPersistenceConfig {
  const SgPersistenceConfig({
    required this.scope,
    required this.mode,
    required this.stateVersion,
  });

  final String scope;
  final SgPersistenceMode mode;
  final int stateVersion;
}

/// Resultado de `useSgEnvironment`: namespace, estrategia e configuracao.
class SgEnvironmentValue {
  const SgEnvironmentValue({
    required this.namespaceProvider,
    required this.persistenceStrategy,
    required this.persistence,
  });

  final NamespaceProvider namespaceProvider;
  final PersistenceStrategy persistenceStrategy;
  final SgPersistenceConfig persistence;
}

/// `SgEnvironment` no React e um alias de `SgEnvironmentValue`.
typedef SgEnvironment = SgEnvironmentValue;

/// `chave final` = `sg:<namespace>[:<scope>]:<baseKey>`; `null` sem namespace (nada e persistido).
String? buildSgPersistenceKey(
  String baseKey, [
  String? namespace,
  String? scope,
]) {
  final resolved = namespace ?? '';
  if (resolved.isEmpty) return null;
  final resolvedScope = (scope ?? '').trim();
  if (resolvedScope.isEmpty) return 'sg:$resolved:$baseKey';
  return 'sg:$resolved:$resolvedScope:$baseKey';
}

/// Estrategia local (`localStorage` no React, `shared_preferences` no Flutter). Qualquer falha de
/// leitura vira `null` e de escrita e ignorada, como no React.
PersistenceStrategy createLocalStorageStrategy({String prefix = ''}) {
  String full(String key) => prefix.isEmpty ? key : '$prefix$key';
  return PersistenceStrategy.from(
    load: (key) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString(full(key));
        if (raw == null) return null;
        return jsonDecode(raw);
      } catch (_) {
        return null;
      }
    },
    save: (key, state) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(full(key), jsonEncode(state));
      } catch (_) {
        // ignora
      }
    },
    clear: (key) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(full(key));
      } catch (_) {
        // ignora
      }
    },
  );
}

/// Estrategia por API: `GET/POST/DELETE {baseUrl}/sg/persistence`. Erro HTTP lanca (para o composite
/// cair no secundario).
PersistenceStrategy createApiPersistenceStrategy({
  required String baseUrl,
  SgFetcher? fetcher,
  required String scope,
  required int stateVersion,
}) {
  final fetch = fetcher ?? sgDefaultFetcher;
  final base = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;
  return PersistenceStrategy.from(
    load: (key) async {
      final res = await fetch(
        SgFetchRequest(
          method: 'GET',
          url: '$base/sg/persistence?key=${Uri.encodeQueryComponent(key)}',
        ),
      );
      if (!res.ok) {
        throw Exception('SG persistence load failed (${res.status})');
      }
      final data = res.json();
      if (data is! Map || data['found'] != true || data['record'] is! Map) {
        return null;
      }
      return (data['record'] as Map)['state'];
    },
    save: (key, state) async {
      final record = SgPersistenceRecordDTO(
        key: key,
        scope: scope,
        stateVersion: stateVersion,
        updatedAt: DateTime.now().toUtc().toIso8601String(),
        state: state,
      );
      final res = await fetch(
        SgFetchRequest(
          method: 'POST',
          url: '$base/sg/persistence',
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'record': record.toJson()}),
        ),
      );
      if (!res.ok) {
        throw Exception('SG persistence save failed (${res.status})');
      }
    },
    clear: (key) async {
      final res = await fetch(
        SgFetchRequest(
          method: 'DELETE',
          url: '$base/sg/persistence?key=${Uri.encodeQueryComponent(key)}',
        ),
      );
      if (!res.ok) {
        throw Exception('SG persistence clear failed (${res.status})');
      }
    },
  );
}

/// Combina duas estrategias:
/// - `strict`: so a primaria (erro propaga);
/// - `fallback`: primaria e, se falhar, a secundaria;
/// - `mirror`: le a primaria (se vier valor), senao a secundaria; grava e apaga nas duas, ignorando falhas.
PersistenceStrategy createCompositePersistenceStrategy({
  required SgPersistenceMode mode,
  required PersistenceStrategy primary,
  required PersistenceStrategy secondary,
}) {
  Future<void> settled(FutureOr<void> a, FutureOr<void> b) async {
    await Future.wait([
      Future.sync(() => a).then<void>((_) {}, onError: (_) {}),
      Future.sync(() => b).then<void>((_) {}, onError: (_) {}),
    ]);
  }

  return PersistenceStrategy.from(
    load: (key) async {
      if (mode == SgPersistenceMode.strict) return await primary.load(key);
      if (mode == SgPersistenceMode.mirror) {
        try {
          final remote = await primary.load(key);
          if (remote != null) return remote;
        } catch (_) {
          // cai no secundario
        }
        return await secondary.load(key);
      }
      try {
        return await primary.load(key);
      } catch (_) {
        return await secondary.load(key);
      }
    },
    save: (key, state) async {
      if (mode == SgPersistenceMode.strict) {
        await primary.save(key, state);
        return;
      }
      if (mode == SgPersistenceMode.mirror) {
        // Os dois sao disparados antes de esperar (como Promise.allSettled).
        Future<void> a() async => primary.save(key, state);
        Future<void> b() async => secondary.save(key, state);
        await settled(a(), b());
        return;
      }
      try {
        await primary.save(key, state);
      } catch (_) {
        await secondary.save(key, state);
      }
    },
    clear: (key) async {
      if (mode == SgPersistenceMode.strict) {
        await primary.clear(key);
        return;
      }
      if (mode == SgPersistenceMode.mirror) {
        Future<void> a() async => primary.clear(key);
        Future<void> b() async => secondary.clear(key);
        await settled(a(), b());
        return;
      }
      try {
        await primary.clear(key);
      } catch (_) {
        await secondary.clear(key);
      }
    },
  );
}
