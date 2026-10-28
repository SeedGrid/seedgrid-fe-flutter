// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_clock_theme_picker_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgClockThemePickerPageSnippets {
  /// Region `sg-clock-theme-picker-aberto`.
  static const String sgClockThemePickerAberto = r'''
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
)
''';

  /// Region `sg-clock-theme-picker-basico`.
  static const String sgClockThemePickerBasico = r'''
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
)
''';

  /// Region `sg-clock-theme-picker-filtro`.
  static const String sgClockThemePickerFiltro = r'''
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
)
''';

  /// Region `sg-clock-theme-picker-recuo`.
  static const String sgClockThemePickerRecuo = r'''
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
)
''';
}
