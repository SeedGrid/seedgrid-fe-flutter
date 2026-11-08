// Showcase do SgClockThemeProvider (e de useSgClockThemeResolver). O codigo exibido em cada exemplo e o
// trecho entre `// #region` e `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_clock_theme_provider_page.snippets.g.dart';

class SgClockThemeProviderPage extends StatefulWidget {
  const SgClockThemeProviderPage({super.key});

  @override
  State<SgClockThemeProviderPage> createState() =>
      _SgClockThemeProviderPageState();
}

class _SgClockThemeProviderPageState extends State<SgClockThemeProviderPage> {
  final ValueNotifier<String> _themeId = ValueNotifier('classic');

  @override
  void dispose() {
    _themeId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Uso básico',
        description:
            'Envolva SgClock e SgClockThemePicker com SgClockThemeProvider para compartilhar a resolução de temas.',
        preview:
            // #region sg-clock-theme-provider-basico
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
              child: ValueListenableBuilder<String>(
                valueListenable: _themeId,
                builder: (context, themeId, _) => Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SgClock(
                      clockStyle: SgClockClockStyle.analog,
                      size: 160,
                      initialServerTime: '2026-06-15T10:08:30Z',
                      timezone: 'UTC',
                      themeId: themeId,
                    ),
                    SizedBox(
                      width: 300,
                      child: SgClockThemePicker(
                        value: themeId,
                        onChange: (id) => _themeId.value = id,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgClockThemeProviderPageSnippets.sgClockThemeProviderBasico,
      ),
      ShowcaseExample(
        title: 'Tema local customizado',
        description:
            'Passe um array themes para o provider para injetar temas locais sem registro global.',
        preview:
            // #region sg-clock-theme-provider-local
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(
                themes: [
                  SgClockTheme(
                    id: 'ponto',
                    label: context.tx('Ponto'),
                    ops: [
                      SgClockCircle(
                        cx: 50,
                        cy: 50,
                        r: 48,
                        fill: SgClockPaint(
                          light: Color(0xFFFFF7ED),
                          dark: Color(0xFF1C1917),
                        ),
                      ),
                      SgClockCircle(
                        cx: 50,
                        cy: 12,
                        r: 3,
                        fill: SgClockPaint(
                          light: Color(0xFFF97316),
                          dark: Color(0xFFFB923C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              child: SgClock(
                clockStyle: SgClockClockStyle.analog,
                size: 160,
                initialServerTime: '2026-06-15T10:08:30Z',
                timezone: 'UTC',
                themeId: 'ponto',
              ),
            ),
        // #endregion
        code: SgClockThemeProviderPageSnippets.sgClockThemeProviderLocal,
      ),
      ShowcaseExample(
        title: 'Registro global',
        description:
            'Use registerTheme para registrar temas globalmente. Eles ficam disponíveis para todas as instâncias de SgClockThemeProvider.',
        preview:
            // #region sg-clock-theme-provider-global
            Builder(
              builder: (context) {
                registerTheme(
                  SgClockTheme(
                    id: 'anel-global',
                    label: context.tx('Anel global'),
                    ops: [
                      SgClockCircle(
                        cx: 50,
                        cy: 50,
                        r: 48,
                        fill: SgClockPaint(
                          light: Color(0xFFECFDF5),
                          dark: Color(0xFF052E16),
                        ),
                        stroke: SgClockPaint(
                          light: Color(0xFF16A34A),
                          dark: Color(0xFF4ADE80),
                        ),
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                );
                return const SgClockThemeProvider(
                  child: SgClock(
                    clockStyle: SgClockClockStyle.analog,
                    size: 160,
                    initialServerTime: '2026-06-15T10:08:30Z',
                    timezone: 'UTC',
                    themeId: 'anel-global',
                  ),
                );
              },
            ),
        // #endregion
        code: SgClockThemeProviderPageSnippets.sgClockThemeProviderGlobal,
      ),
      ShowcaseExample(
        title: 'Resolver temas na árvore (useSgClockThemeResolver)',
        description:
            'O hook devolve o resolvedor do provider mais próximo — ou null, se não houver provider: não existe fallback implícito. Com ele você resolve um tema por id, lista os visíveis (globais + locais) e registra temas locais em tempo de execução.',
        preview:
            // #region sg-clock-theme-provider-resolvedor
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(
                mode: SgClockThemeResolveMode.strict,
                themes: sgClockThemesBuiltIn,
              ),
              child: Builder(
                builder: (context) {
                  final resolvedor = useSgClockThemeResolver(context)!;
                  return Text(
                    '${resolvedor.list().length} temas; "dark": ${resolvedor.resolve('dark')?.label}; "x": ${resolvedor.resolve('x')}',
                  );
                },
              ),
            ),
        // #endregion
        code: SgClockThemeProviderPageSnippets.sgClockThemeProviderResolvedor,
      ),
      ShowcaseExample(
        title: 'Tema de recuo',
        description:
            'Com mode fallback (padrão), um id desconhecido cai em fallbackThemeId (padrão: classic).',
        preview:
            // #region sg-clock-theme-provider-recuo
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(
                themes: sgClockThemesBuiltIn,
                fallbackThemeId: 'roman-classic',
              ),
              child: const SgClock(
                clockStyle: SgClockClockStyle.analog,
                size: 160,
                initialServerTime: '2026-06-15T10:08:30Z',
                timezone: 'UTC',
                themeId: 'nao-existe',
              ),
            ),
        // #endregion
        code: SgClockThemeProviderPageSnippets.sgClockThemeProviderRecuo,
      ),
    ];

    return SgShowcasePage(
      name: 'SgClockThemeProvider',
      description:
          'Fornece um resolvedor de temas de relógio (modo, tema de recuo e temas locais) a toda a árvore.',
      examples: examples,
      propSpecs: sgPropSpecs['SgClockThemeProvider']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgClockThemeProvider']!
            .where((s) => s.name == 'value')
            .toList(),
        builder: (context, v) => SgClockThemeProvider(
          value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
          child: const SgClock(
            clockStyle: SgClockClockStyle.analog,
            size: 140,
            initialServerTime: '2026-06-15T10:08:30Z',
            timezone: 'UTC',
            themeId: 'seedgrid',
          ),
        ),
        codeBuilder: (v) =>
            "SgClockThemeProvider(\n  value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),\n  child: const SgClock(clockStyle: SgClockClockStyle.analog, themeId: 'seedgrid'),\n)",
      ),
    );
  }
}
