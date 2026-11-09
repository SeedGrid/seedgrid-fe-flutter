// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de use_components_i18n_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class UseComponentsI18nPageSnippets {
  /// Region `use-components-i18n-basico`.
  static const String useComponentsI18nBasico = r'''
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
        child: Builder(
          builder: (context) {
            final i18n = useComponentsI18n(context);
            return SgGrid(
              gap: 4,
              children: [
                Text('locale: ${i18n.locale}'),
                Text('messages: ${i18n.messages.length}'),
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

  /// Region `use-components-i18n-cientes-de-locale`.
  static const String useComponentsI18nCientesDeLocale = r'''
SgComponentsI18nProvider(
  locale: 'es',
  child: SgGrid(
    gap: 8,
    children: [
      Builder(
        builder: (context) {
          final i18n = useComponentsI18n(context);
          return Align(
            alignment: Alignment.centerLeft,
            child: SgButton(
              label: Text(t(i18n, 'components.actions.clear')),
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              onClick: () => _limpezas.value++,
            ),
          );
        },
      ),
      ValueListenableBuilder<int>(
        valueListenable: _limpezas,
        builder: (context, limpezas, _) =>
            Text('onClear: $limpezas'),
      ),
    ],
  ),
)
''';
}
