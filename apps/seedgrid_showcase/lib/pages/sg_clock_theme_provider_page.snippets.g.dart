// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_clock_theme_provider_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgClockThemeProviderPageSnippets {
  /// Region `sg-clock-theme-provider-basico`.
  static const String sgClockThemeProviderBasico = r'''
SgClockThemeProvider(
  value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
  child: const SgClock(
    clockStyle: SgClockClockStyle.analog,
    size: 160,
    initialServerTime: '2026-06-15T10:08:30Z',
    timezone: 'UTC',
    themeId: 'music-notes',
  ),
)
''';

  /// Region `sg-clock-theme-provider-local`.
  static const String sgClockThemeProviderLocal = r'''
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
)
''';

  /// Region `sg-clock-theme-provider-recuo`.
  static const String sgClockThemeProviderRecuo = r'''
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
)
''';

  /// Region `sg-clock-theme-provider-resolvedor`.
  static const String sgClockThemeProviderResolvedor = r'''
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
)
''';
}
