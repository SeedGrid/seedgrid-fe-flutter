// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_components_i18n_provider_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgComponentsI18nProviderPageSnippets {
  /// Region `sg-components-i18n-provider-basico`.
  static const String sgComponentsI18nProviderBasico = r'''
SgComponentsI18nProvider(
  locale: 'en-US',
  messages: componentsMessagesEnUs,
  child: Builder(
    builder: (context) {
      final i18n = useComponentsI18n(context);
      return SgGrid(
        gap: 4,
        children: [
          Text('locale: ${i18n.locale}'),
          Text(
            'components.actions.clear: ${t(i18n, 'components.actions.clear')}',
          ),
          Text(
            'components.password.show: ${t(i18n, 'components.password.show')}',
          ),
          Text(
            'components.inputs.required: ${t(i18n, 'components.inputs.required')}',
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-components-i18n-provider-dinamico`.
  static const String sgComponentsI18nProviderDinamico = r'''
ValueListenableBuilder<String>(
  valueListenable: _locale,
  builder: (context, locale, _) => SgGrid(
    gap: 12,
    children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final id in const [
            'pt-BR',
            'pt-PT',
            'en-US',
            'es',
            'fr',
          ])
            SgButton(
              label: Text(id),
              size: SgSize.sm,
              appearance: id == locale
                  ? SgAppearance.solid
                  : SgAppearance.outline,
              onClick: () => _locale.value = id,
            ),
        ],
      ),
      SgComponentsI18nProvider(
        locale: locale,
        messages: getBuiltInComponentsMessages(locale),
        child: Builder(
          builder: (context) {
            final i18n = useComponentsI18n(context);
            return SgGrid(
              gap: 4,
              children: [
                Text('locale: ${i18n.locale}'),
                Text(
                  'components.actions.clear: ${t(i18n, 'components.actions.clear')}',
                ),
                Text(
                  'components.password.show: ${t(i18n, 'components.password.show')}',
                ),
                Text(
                  'components.inputs.required: ${t(i18n, 'components.inputs.required')}',
                ),
              ],
            );
          },
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-components-i18n-provider-imperativo`.
  static const String sgComponentsI18nProviderImperativo = r'''
Builder(
  builder: (context) {
    void aplicar(String locale) {
      final anterior = getComponentsI18n();

      setComponentsI18n(SgComponentsI18nInput(locale: locale));
      final atual = getComponentsI18n();
      _resultado.value =
          '${atual.locale}: ${t(atual, 'components.actions.clear')}';

      // Devolve o estado global anterior para não afetar o restante da página.
      setComponentsI18n(
        SgComponentsI18nInput(
          locale: anterior.locale,
          messages: anterior.messages,
        ),
      );
    }

    return SgGrid(
      gap: 12,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SgButton(
              label: const Text('es'),
              size: SgSize.sm,
              onClick: () => aplicar('es'),
            ),
            SgButton(
              label: const Text('fr'),
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              onClick: () => aplicar('fr'),
            ),
          ],
        ),
        ValueListenableBuilder<String>(
          valueListenable: _resultado,
          builder: (context, resultado, _) => Text(resultado),
        ),
      ],
    );
  },
)
''';

  /// Region `sg-components-i18n-provider-sobrescrita`.
  static const String sgComponentsI18nProviderSobrescrita = r'''
SgComponentsI18nProvider(
  locale: 'en-US',
  messages: {
    ...componentsMessagesEnUs,
    'components.actions.clear': 'Reset',
    'components.password.show': 'Reveal',
    'components.inputs.required': 'Mandatory field.',
  },
  child: Builder(
    builder: (context) {
      final i18n = useComponentsI18n(context);
      return SgGrid(
        gap: 4,
        children: [
          Text('locale: ${i18n.locale}'),
          Text(
            'components.actions.clear: ${t(i18n, 'components.actions.clear')}',
          ),
          Text(
            'components.password.show: ${t(i18n, 'components.password.show')}',
          ),
          Text(
            'components.inputs.required: ${t(i18n, 'components.inputs.required')}',
          ),
        ],
      );
    },
  ),
)
''';
}
