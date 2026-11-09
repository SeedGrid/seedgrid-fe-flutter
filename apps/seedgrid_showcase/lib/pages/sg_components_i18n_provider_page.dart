// Showcase do SgComponentsI18nProvider (idioma e mensagens internas dos componentes). O codigo exibido
// em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo: o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_components_i18n_provider_page.snippets.g.dart';

class SgComponentsI18nProviderPage extends StatefulWidget {
  const SgComponentsI18nProviderPage({super.key});

  @override
  State<SgComponentsI18nProviderPage> createState() =>
      _SgComponentsI18nProviderPageState();
}

class _SgComponentsI18nProviderPageState
    extends State<SgComponentsI18nProviderPage> {
  // Idioma escolhido no exemplo de troca dinamica e resultado do exemplo da API imperativa.
  final ValueNotifier<String> _locale = ValueNotifier('pt-BR');
  final ValueNotifier<String> _resultado = ValueNotifier('-');

  @override
  void dispose() {
    _locale.dispose();
    _resultado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Uso básico',
        description:
            'Envolva o app com SgComponentsI18nProvider passando o locale e as mensagens do idioma desejado.',
        preview:
            // #region sg-components-i18n-provider-basico
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
            ),
        // #endregion
        code: SgComponentsI18nProviderPageSnippets
            .sgComponentsI18nProviderBasico,
      ),
      ShowcaseExample(
        title: 'Troca dinâmica de locale',
        description:
            'Altere o locale em runtime. Os componentes re-renderizam automaticamente com as novas mensagens.',
        preview:
            // #region sg-components-i18n-provider-dinamico
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
            ),
        // #endregion
        code: SgComponentsI18nProviderPageSnippets
            .sgComponentsI18nProviderDinamico,
      ),
      ShowcaseExample(
        title: 'API imperativa (setComponentsI18n)',
        description:
            'Alternativa ao Provider. Útil para definir o idioma antes de montar a árvore de componentes.',
        preview:
            // #region sg-components-i18n-provider-imperativo
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
            ),
        // #endregion
        code: SgComponentsI18nProviderPageSnippets
            .sgComponentsI18nProviderImperativo,
      ),
      ShowcaseExample(
        title: 'Sobrescrita de mensagens',
        description:
            'Sobrescreva apenas as chaves que deseja customizar. Mescle suas mensagens com o objeto built-in do locale.',
        preview:
            // #region sg-components-i18n-provider-sobrescrita
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
            ),
        // #endregion
        code: SgComponentsI18nProviderPageSnippets
            .sgComponentsI18nProviderSobrescrita,
      ),
    ];

    return SgShowcasePage(
      name: 'SgComponentsI18nProvider',
      description:
          'Configura o locale e as mensagens de todos os componentes SeedGrid na subárvore.',
      examples: examples,
      propSpecs: sgPropSpecs['SgComponentsI18nProvider']!,
      playground: SgPlayground(
        specs: const [
          SgPropSpec(
            name: 'locale',
            reactName: 'locale',
            type: 'String?',
            tsType: 'SgComponentsLocale',
            required: false,
            defaultValue: 'en-US',
            values: ['pt-BR', 'pt-PT', 'en-US', 'es', 'fr'],
          ),
        ],
        builder: (context, v) {
          final locale = (v['locale'] as String?) ?? 'en-US';
          return SgComponentsI18nProvider(
            locale: locale,
            messages: const {'components.actions.clear': 'Reset'},
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
          );
        },
        codeBuilder: (v) =>
            "SgComponentsI18nProvider(\n  locale: '${(v['locale'] as String?) ?? 'en-US'}',\n  messages: const {'components.actions.clear': 'Reset'},\n  child: Builder(\n    builder: (context) {\n      final i18n = useComponentsI18n(context);\n      return Text(t(i18n, 'components.actions.clear'));\n    },\n  ),\n)",
      ),
    );
  }
}
