// showcase-name: UseComponentsI18n
// Showcase do hook useComponentsI18n (no Flutter, a funcao `useComponentsI18n(context)`). O codigo exibido
// em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo: o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'use_components_i18n_page.snippets.g.dart';

class UseComponentsI18nPage extends StatefulWidget {
  const UseComponentsI18nPage({super.key});

  @override
  State<UseComponentsI18nPage> createState() => _UseComponentsI18nPageState();
}

class _UseComponentsI18nPageState extends State<UseComponentsI18nPage> {
  // Idioma escolhido no primeiro exemplo e contagem de cliques do segundo.
  final ValueNotifier<String> _locale = ValueNotifier('pt-BR');
  final ValueNotifier<int> _limpezas = ValueNotifier(0);

  @override
  void dispose() {
    _locale.dispose();
    _limpezas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Uso básico',
        description:
            'Use useComponentsI18n para ler o locale ativo e traduzir chaves com o helper t.',
        preview:
            // #region use-components-i18n-basico
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
            ),
        // #endregion
        code: UseComponentsI18nPageSnippets.useComponentsI18nBasico,
      ),
      ShowcaseExample(
        title: 'Construindo componentes cientes de locale',
        description:
            'Combine useComponentsI18n com t para construir componentes que respeitam automaticamente o locale ativo.',
        preview:
            // #region use-components-i18n-cientes-de-locale
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
            ),
        // #endregion
        code: UseComponentsI18nPageSnippets.useComponentsI18nCientesDeLocale,
      ),
    ];

    return SgShowcasePage(
      name: 'UseComponentsI18n',
      description:
          'Retorna o locale e as mensagens atuais configurados pelo SgComponentsI18nProvider.',
      examples: examples,
      propSpecs: const [
        SgPropSpec(
          name: 'locale',
          reactName: 'locale',
          type: 'String',
          tsType: 'string',
          required: false,
          defaultValue: 'en-US',
          description:
              'Locale atual dos componentes. Vem do SgComponentsI18nProvider mais próximo ou, sem provider, do estado global.',
        ),
        SgPropSpec(
          name: 'messages',
          reactName: 'messages',
          type: 'Map<String, String>',
          tsType: 'Record<string, string>',
          required: false,
          defaultValue: 'built-in do locale',
          description:
              'Mapa de todas as chaves de tradução disponíveis para o locale atual, já mescladas com as sobrescritas.',
        ),
      ],
      playground: SgPlayground(
        specs: const [
          SgPropSpec(
            name: 'locale',
            reactName: 'locale',
            type: 'String?',
            tsType: 'string',
            required: false,
            defaultValue: 'en-US',
            values: ['pt-BR', 'pt-PT', 'en-US', 'es', 'fr'],
          ),
        ],
        builder: (context, v) => SgComponentsI18nProvider(
          locale: (v['locale'] as String?) ?? 'en-US',
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
                    'components.inputs.required: ${t(i18n, 'components.inputs.required')}',
                  ),
                ],
              );
            },
          ),
        ),
        codeBuilder: (v) =>
            "SgComponentsI18nProvider(\n  locale: '${(v['locale'] as String?) ?? 'en-US'}',\n  child: Builder(\n    builder: (context) {\n      final i18n = useComponentsI18n(context);\n      return Text(t(i18n, 'components.actions.clear'));\n    },\n  ),\n)",
      ),
    );
  }
}
