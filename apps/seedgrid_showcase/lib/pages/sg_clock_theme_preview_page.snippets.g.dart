// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_clock_theme_preview_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgClockThemePreviewPageSnippets {
  /// Region `sg-clock-theme-preview-basico`.
  static const String sgClockThemePreviewBasico = r'''
SgClockThemePreview(theme: sgClockThemesBuiltIn.first)
''';

  /// Region `sg-clock-theme-preview-galeria`.
  static const String sgClockThemePreviewGaleria = r'''
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
)
''';

  /// Region `sg-clock-theme-preview-proprio`.
  static const String sgClockThemePreviewProprio = r'''
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
)
''';

  /// Region `sg-clock-theme-preview-tamanhos`.
  static const String sgClockThemePreviewTamanhos = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgClockThemePreview(theme: sgClockThemesBuiltIn[7], size: 32),
    SgClockThemePreview(theme: sgClockThemesBuiltIn[7]),
    SgClockThemePreview(theme: sgClockThemesBuiltIn[7], size: 128),
  ],
)
''';
}
