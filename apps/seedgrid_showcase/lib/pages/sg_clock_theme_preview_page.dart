// Showcase do SgClockThemePreview. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_clock_theme_preview_page.snippets.g.dart';

class SgClockThemePreviewPage extends StatelessWidget {
  const SgClockThemePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Galeria de temas',
        description:
            'Previews compactos de temas embutidos para comparação visual.',
        preview:
            // #region sg-clock-theme-preview-galeria
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final tema in sgClockThemesBuiltIn.take(8))
                  SizedBox(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SgClockThemePreview(theme: tema, size: 72),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tema.label ?? tema.id,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(tema.id, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),
        // #endregion
        code: SgClockThemePreviewPageSnippets.sgClockThemePreviewGaleria,
      ),
      ShowcaseExample(
        title: 'Um tema',
        description:
            'Miniatura com ponteiros fixos (hora 305°, minuto 60°, segundo 180°), na cor do texto.',
        preview:
            // #region sg-clock-theme-preview-basico
            SgClockThemePreview(theme: sgClockThemesBuiltIn.first),
        // #endregion
        code: SgClockThemePreviewPageSnippets.sgClockThemePreviewBasico,
      ),
      ShowcaseExample(
        title: 'Tamanhos',
        description:
            'size define o lado do quadrado da miniatura (padrão: 64).',
        preview:
            // #region sg-clock-theme-preview-tamanhos
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgClockThemePreview(theme: sgClockThemesBuiltIn[7], size: 32),
                SgClockThemePreview(theme: sgClockThemesBuiltIn[7]),
                SgClockThemePreview(theme: sgClockThemesBuiltIn[7], size: 128),
              ],
            ),
        // #endregion
        code: SgClockThemePreviewPageSnippets.sgClockThemePreviewTamanhos,
      ),
      ShowcaseExample(
        title: 'Tema próprio',
        description:
            'Um tema é uma lista de figuras no espaço 100×100 (formato JSON sg-clock-theme/1) ou um desenho livre com paint.',
        preview:
            // #region sg-clock-theme-preview-proprio
            SgClockThemePreview(
              size: 96,
              theme: SgClockTheme(
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
                    stroke: SgClockPaint(
                      light: Color(0xFFF97316),
                      dark: Color(0xFFFB923C),
                    ),
                    strokeWidth: 2,
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
            ),
        // #endregion
        code: SgClockThemePreviewPageSnippets.sgClockThemePreviewProprio,
      ),
    ];

    return SgShowcasePage(
      name: 'SgClockThemePreview',
      description:
          'Miniatura de um tema de relógio, usada no seletor de temas e para escolher entre os temas embutidos.',
      examples: examples,
      propSpecs: sgPropSpecs['SgClockThemePreview']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgClockThemePreview']!
            .where((s) => s.name == 'size')
            .toList(),
        builder: (context, v) => SgClockThemePreview(
          theme: sgClockThemesBuiltIn[1],
          size: (v['size'] as num?) ?? 64,
        ),
        codeBuilder: (v) =>
            'SgClockThemePreview(\n  theme: sgClockThemesBuiltIn[1],\n  size: ${(v['size'] as num?) ?? 64},\n)',
      ),
    );
  }
}
