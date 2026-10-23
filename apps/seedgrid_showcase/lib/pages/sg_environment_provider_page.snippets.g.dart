// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_environment_provider_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgEnvironmentProviderPageSnippets {
  /// Region `sg-environment-provider-api`.
  static const String sgEnvironmentProviderApi = r'''
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
)
''';

  /// Region `sg-environment-provider-mirror`.
  static const String sgEnvironmentProviderMirror = r'''
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
)
''';

  /// Region `sg-environment-provider-namespace`.
  static const String sgEnvironmentProviderNamespace = r'''
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
)
''';

  /// Region `sg-environment-provider-sem-namespace`.
  static const String sgEnvironmentProviderSemNamespace = r'''
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
)
''';
}
