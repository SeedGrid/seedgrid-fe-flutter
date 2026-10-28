// Showcase do SgClockThemePicker. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_clock_theme_picker_page.snippets.g.dart';

class SgClockThemePickerPage extends StatefulWidget {
  const SgClockThemePickerPage({super.key});

  @override
  State<SgClockThemePickerPage> createState() => _SgClockThemePickerPageState();
}

class _SgClockThemePickerPageState extends State<SgClockThemePickerPage> {
  String _tema = 'classic';
  String _escolhido = 'roman-classic';

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Escolhendo o tema de um relógio',
        description:
            'O seletor lê os temas do SgClockThemeProvider mais próximo; o relógio ao lado usa o tema escolhido.',
        preview:
            // #region sg-clock-theme-picker-basico
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: SgClockThemePicker(
                      value: _tema,
                      onChange: (id) => setState(() => _tema = id),
                    ),
                  ),
                  SgClock(
                    clockStyle: SgClockClockStyle.analog,
                    size: 160,
                    initialServerTime: '2026-06-15T10:08:30Z',
                    timezone: 'UTC',
                    themeId: _tema,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgClockThemePickerPageSnippets.sgClockThemePickerBasico,
      ),
      ShowcaseExample(
        title: 'Filtrando os temas',
        description:
            'filter recebe o tema e devolve se ele entra na lista (aqui, só os romanos e o classic).',
        preview:
            // #region sg-clock-theme-picker-filtro
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
              child: SizedBox(
                width: 300,
                child: SgClockThemePicker(
                  value: _escolhido,
                  onChange: (id) => setState(() => _escolhido = id),
                  label: context.tx('Tema romano'),
                  filter: (tema) =>
                      tema.id.startsWith('roman') || tema.id == 'classic',
                ),
              ),
            ),
        // #endregion
        code: SgClockThemePickerPageSnippets.sgClockThemePickerFiltro,
      ),
      ShowcaseExample(
        title: 'Sem busca, aberto e com miniatura grande',
        description:
            'searchable: false esconde o campo de busca; defaultOpen abre o painel; previewSize muda a miniatura do botão.',
        preview:
            // #region sg-clock-theme-picker-aberto
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
              child: SizedBox(
                width: 300,
                height: 440,
                child: SgClockThemePicker(
                  value: 'music',
                  onChange: (_) {},
                  searchable: false,
                  defaultOpen: true,
                  previewSize: 72,
                ),
              ),
            ),
        // #endregion
        code: SgClockThemePickerPageSnippets.sgClockThemePickerAberto,
      ),
      ShowcaseExample(
        title: 'Tema de recuo e texto do botão',
        description:
            'Valor desconhecido mostra o fallbackThemeId; placeholder aparece quando nenhum tema é resolvido (aqui, sem provider).',
        preview:
            // #region sg-clock-theme-picker-recuo
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 280,
                  child: SgClockThemeProvider(
                    value: SgClockThemeProviderValue(
                      themes: sgClockThemesBuiltIn,
                    ),
                    child: SgClockThemePicker(
                      value: 'nao-existe',
                      onChange: (_) {},
                      fallbackThemeId: 'dark',
                    ),
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgClockThemePicker(
                    value: 'classic',
                    onChange: (_) {},
                    placeholder: context.tx('Nenhum tema registrado'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgClockThemePickerPageSnippets.sgClockThemePickerRecuo,
      ),
    ];

    return SgShowcasePage(
      name: 'SgClockThemePicker',
      description:
          'Seletor de tema de relógio: botão com a miniatura atual e um painel com busca e a lista de temas.',
      examples: examples,
      propSpecs: sgPropSpecs['SgClockThemePicker']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgClockThemePicker']!
            .where(
              (s) => const {
                'searchable',
                'defaultOpen',
                'label',
                'placeholder',
                'fallbackThemeId',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgClockThemeProvider(
          value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
          child: SizedBox(
            width: 300,
            height: (v['defaultOpen'] == true) ? 440 : 100,
            child: SgClockThemePicker(
              key: ValueKey('${v['defaultOpen']}'),
              value: 'classic',
              onChange: (_) {},
              searchable: (v['searchable'] as bool?) ?? true,
              defaultOpen: (v['defaultOpen'] as bool?) ?? false,
              label: v['label'] as String?,
              placeholder: v['placeholder'] as String?,
              fallbackThemeId: (v['fallbackThemeId'] as String?) ?? 'classic',
            ),
          ),
        ),
        codeBuilder: (v) {
          final args = <String>["value: 'classic'", 'onChange: (id) {}'];
          if (v['searchable'] == false) args.add('searchable: false');
          if (v['defaultOpen'] == true) args.add('defaultOpen: true');
          if (v['label'] != null) args.add("label: '${v['label']}'");
          if (v['placeholder'] != null) {
            args.add("placeholder: '${v['placeholder']}'");
          }
          if (v['fallbackThemeId'] != null) {
            args.add("fallbackThemeId: '${v['fallbackThemeId']}'");
          }
          return 'SgClockThemePicker(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
