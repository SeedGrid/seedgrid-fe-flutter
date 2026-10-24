// Showcase do SgClockThemeProvider (e de useSgClockThemeResolver). O codigo exibido em cada exemplo e o
// trecho entre `// #region` e `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_clock_theme_provider_page.snippets.g.dart';

class SgClockThemeProviderPage extends StatelessWidget {
  const SgClockThemeProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Registrando os temas embutidos',
        description:
            'Os temas embutidos não vêm registrados: passe sgClockThemesBuiltIn no value. Todos os relógios abaixo do provider enxergam os temas.',
        preview:
            // #region sg-clock-theme-provider-basico
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
              child: const SgClock(
                clockStyle: SgClockClockStyle.analog,
                size: 160,
                initialServerTime: '2026-06-15T10:08:30Z',
                timezone: 'UTC',
                themeId: 'music-notes',
              ),
            ),
        // #endregion
        code: SgClockThemeProviderPageSnippets.sgClockThemeProviderBasico,
      ),
      ShowcaseExample(
        title: 'Um tema local',
        description:
            'themes aceita temas próprios, que valem só abaixo do provider e vencem os globais de mesmo id.',
        preview:
            // #region sg-clock-theme-provider-local
            const SgClockThemeProvider(
              value: SgClockThemeProviderValue(
                themes: [
                  SgClockTheme(
                    id: 'ponto',
                    label: 'Ponto',
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
      ShowcaseExample(
        title: 'Lendo o resolvedor',
        description:
            'useSgClockThemeResolver(context) devolve o resolvedor do provider mais próximo (ou nulo): resolve e list.',
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
