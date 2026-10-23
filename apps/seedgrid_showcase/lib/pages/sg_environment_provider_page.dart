// Showcase do SgEnvironmentProvider (namespace, escopo e estrategia de persistencia). O codigo exibido
// em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo: o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_environment_provider_page.snippets.g.dart';

class SgEnvironmentProviderPage extends StatefulWidget {
  const SgEnvironmentProviderPage({super.key});

  @override
  State<SgEnvironmentProviderPage> createState() =>
      _SgEnvironmentProviderPageState();
}

class _SgEnvironmentProviderPageState extends State<SgEnvironmentProviderPage> {
  // Duas "bases" em memoria para o exemplo do modo mirror.
  final Map<String, Object?> _primary = {};
  final Map<String, Object?> _secondary = {};

  // Registro das chamadas HTTP do exemplo da API (o servidor e simulado).
  final List<String> _requests = [];
  final Map<String, Object?> _server = {};

  PersistenceStrategy _memory(Map<String, Object?> map) =>
      PersistenceStrategy.from(
        load: (key) => map[key],
        save: (key, state) => map[key] = state,
        clear: (key) => map.remove(key),
      );

  Future<SgFetchResponse> _fakeServer(SgFetchRequest r) async {
    setState(
      () => _requests.add(
        '${r.method} ${Uri.parse(r.url).path}${Uri.parse(r.url).hasQuery ? '?key=…' : ''}',
      ),
    );
    final key = Uri.parse(r.url).queryParameters['key'];
    switch (r.method) {
      case 'GET':
        final found = _server.containsKey(key);
        return SgFetchResponse(
          200,
          jsonEncode({
            'found': found,
            if (found) 'record': {'state': _server[key]},
          }),
        );
      case 'POST':
        final record = (jsonDecode(r.body!) as Map)['record'] as Map;
        _server[record['key'] as String] = record['state'];
        return const SgFetchResponse(200);
      default:
        _server.remove(key);
        return const SgFetchResponse(200);
    }
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Namespace e escopo',
        description:
            'A chave final é sg:<namespace>:<escopo>:<chave>. O valor fica salvo no armazenamento local do aparelho.',
        preview:
            // #region sg-environment-provider-namespace
            SgEnvironmentProvider(
              value: SgEnvironmentPartial(
                namespaceProvider: NamespaceProvider(() => 'empresa-1'),
                persistence: const SgPersistencePartial(scope: 'app:showcase'),
              ),
              child: SgPersistentStateBuilder<int>(
                baseKey: 'cliques',
                defaultValue: 0,
                builder: (context, state) => Row(
                  children: [
                    SgButton(
                      label: Text('Cliques: ${state.value}'),
                      onClick: () => state.setValue(state.value + 1),
                    ),
                    const SizedBox(width: 12),
                    SgButton(
                      label: const Text('Zerar'),
                      appearance: SgAppearance.outline,
                      onClick: state.clear,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'chave: ${useSgPersistence(context).fullKeyOf('cliques')}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgEnvironmentProviderPageSnippets.sgEnvironmentProviderNamespace,
      ),
      ShowcaseExample(
        title: 'Sem namespace nada é salvo',
        description:
            'Com o provider sem namespace (ou com namespace vazio) a chave não existe: o estado volta ao padrão.',
        preview:
            // #region sg-environment-provider-sem-namespace
            SgEnvironmentProvider(
              value: SgEnvironmentPartial(
                namespaceProvider: NamespaceProvider(() => null),
              ),
              child: SgPersistentStateBuilder<String>(
                baseKey: 'rascunho',
                defaultValue: 'padrão',
                builder: (context, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('valor: ${state.value}'),
                    Text(
                      'chave: ${useSgPersistence(context).fullKeyOf('rascunho')}',
                    ),
                    SgButton(
                      label: const Text('Tentar salvar'),
                      onClick: () => state.setValue('salvo?'),
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code:
            SgEnvironmentProviderPageSnippets.sgEnvironmentProviderSemNamespace,
      ),
      ShowcaseExample(
        title: 'Duas estratégias em modo mirror',
        description:
            'O mirror grava nas duas e lê da primária; se ela estiver vazia, lê da secundária.',
        preview:
            // #region sg-environment-provider-mirror
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgEnvironmentProvider(
                  value: SgEnvironmentPartial(
                    namespaceProvider: NamespaceProvider(() => 'empresa-1'),
                    persistenceStrategy: createCompositePersistenceStrategy(
                      mode: SgPersistenceMode.mirror,
                      primary: _memory(_primary),
                      secondary: _memory(_secondary),
                    ),
                  ),
                  child: SgPersistentStateBuilder<String>(
                    baseKey: 'tema',
                    defaultValue: 'claro',
                    builder: (context, state) => SgButton(
                      label: Text('Tema: ${state.value} (tocar para alternar)'),
                      onClick: () async {
                        await state.setValue(
                          state.value == 'claro' ? 'escuro' : 'claro',
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('primária: $_primary'),
                Text('secundária: $_secondary'),
              ],
            ),
        // #endregion
        code: SgEnvironmentProviderPageSnippets.sgEnvironmentProviderMirror,
      ),
      ShowcaseExample(
        title: 'Persistência por API',
        description:
            'GET, POST e DELETE em /sg/persistence. Aqui o servidor é simulado e as chamadas aparecem abaixo.',
        preview:
            // #region sg-environment-provider-api
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgEnvironmentProvider(
                  value: SgEnvironmentPartial(
                    namespaceProvider: NamespaceProvider(() => 'empresa-1'),
                    persistenceStrategy: createApiPersistenceStrategy(
                      baseUrl: 'https://api.exemplo.com',
                      scope: 'app:showcase',
                      stateVersion: 1,
                      fetcher: _fakeServer,
                    ),
                  ),
                  child: SgPersistentStateBuilder<int>(
                    baseKey: 'pontos',
                    defaultValue: 0,
                    builder: (context, state) => Row(
                      children: [
                        SgButton(
                          label: Text('Pontos: ${state.value}'),
                          onClick: () => state.setValue(state.value + 10),
                        ),
                        const SizedBox(width: 12),
                        SgButton(
                          label: const Text('Apagar'),
                          appearance: SgAppearance.outline,
                          onClick: state.clear,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('chamadas: ${_requests.join(' | ')}'),
              ],
            ),
        // #endregion
        code: SgEnvironmentProviderPageSnippets.sgEnvironmentProviderApi,
      ),
    ];

    return SgShowcasePage(
      name: 'SgEnvironmentProvider',
      description:
          'Ambiente com namespace, escopo e estratégia de persistência (local, API ou as duas) para os componentes SeedGrid e para o estado persistido.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgEnvironmentProvider']!,
        const SgPropSpec(
          name: 'value.namespaceProvider',
          reactName: 'value.namespaceProvider',
          type: 'NamespaceProvider?',
          tsType: 'NamespaceProvider',
          required: false,
          description:
              'Quem diz o namespace (empresa, tenant). Sem namespace nada é persistido.',
        ),
        const SgPropSpec(
          name: 'value.persistenceStrategy',
          reactName: 'value.persistenceStrategy',
          type: 'PersistenceStrategy?',
          tsType: 'PersistenceStrategy',
          required: false,
          description:
              'Onde guardar: createLocalStorageStrategy, createApiPersistenceStrategy ou createCompositePersistenceStrategy.',
        ),
        const SgPropSpec(
          name: 'value.persistence.scope',
          reactName: 'value.persistence.scope',
          type: 'String?',
          tsType: 'string',
          required: false,
          defaultValue: 'app:unknown',
          description: 'Escopo que entra na chave.',
        ),
        const SgPropSpec(
          name: 'value.persistence.mode',
          reactName: 'value.persistence.mode',
          type: 'SgPersistenceMode?',
          tsType: '"strict" | "fallback" | "mirror"',
          required: false,
          defaultValue: 'fallback',
          values: ['strict', 'fallback', 'mirror'],
          description: 'Como as estratégias se combinam.',
        ),
        const SgPropSpec(
          name: 'value.persistence.stateVersion',
          reactName: 'value.persistence.stateVersion',
          type: 'int?',
          tsType: 'number',
          required: false,
          defaultValue: '1',
          description: 'Versão do formato do estado.',
        ),
      ],
      playground: SgPlayground(
        specs: const [
          SgPropSpec(
            name: 'scope',
            reactName: 'value.persistence.scope',
            type: 'String?',
            tsType: 'string',
            required: false,
            defaultValue: 'app:unknown',
          ),
          SgPropSpec(
            name: 'mode',
            reactName: 'value.persistence.mode',
            type: 'SgPersistenceMode?',
            tsType: '"strict" | "fallback" | "mirror"',
            required: false,
            defaultValue: 'fallback',
            values: ['strict', 'fallback', 'mirror'],
          ),
          SgPropSpec(
            name: 'namespace',
            reactName: 'value.namespaceProvider',
            type: 'String?',
            tsType: 'string',
            required: false,
            defaultValue: 'empresa-1',
          ),
        ],
        builder: (context, v) => SgEnvironmentProvider(
          value: SgEnvironmentPartial(
            namespaceProvider: NamespaceProvider(
              () => (v['namespace'] as String?) ?? 'empresa-1',
            ),
            persistence: SgPersistencePartial(
              scope: v['scope'] as String?,
              mode: SgPersistenceMode.fromValue(v['mode'] as String?),
            ),
          ),
          child: Builder(
            builder: (context) {
              final p = useSgPersistence(context);
              return Text(
                'namespace: ${p.namespace} | escopo: ${p.scope} | modo: ${p.mode.value} | chave de "k": ${p.fullKeyOf('k')}',
              );
            },
          ),
        ),
        codeBuilder: (v) {
          final lines = <String>[
            "namespaceProvider: NamespaceProvider(() => '${(v['namespace'] as String?) ?? 'empresa-1'}')",
          ];
          final inner = <String>[
            if (v['scope'] != null) "scope: '${v['scope']}'",
            if (v['mode'] != null)
              'mode: SgPersistenceMode.${SgPersistenceMode.fromValue(v['mode'] as String)!.name}',
          ];
          if (inner.isNotEmpty) {
            lines.add('persistence: SgPersistencePartial(${inner.join(', ')})');
          }
          return 'SgEnvironmentProvider(\n  value: SgEnvironmentPartial(\n    ${lines.join(',\n    ')},\n  ),\n  child: ...,\n)';
        },
      ),
    );
  }
}
