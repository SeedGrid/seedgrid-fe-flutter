// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_clock_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgClockPageSnippets {
  /// Region `sg-clock-12h`.
  static const String sgClock12h = r'''
const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgClock(
      initialServerTime: '2026-06-15T15:41:07Z',
      timezone: 'UTC',
      format: SgClockFormat.v12h,
      locale: 'en-US',
      showSeconds: false,
    ),
    SgClock(
      initialServerTime: '2026-06-15T15:41:07Z',
      timezone: 'Asia/Tokyo',
      format: SgClockFormat.v12h,
      locale: 'es',
    ),
  ],
)
''';

  /// Region `sg-clock-analogico`.
  static const String sgClockAnalogico = r'''
SgClockThemeProvider(
  value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
  child: const Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      SgClock(
        clockStyle: SgClockClockStyle.analog,
        size: 180,
        initialServerTime: '2026-06-15T10:08:30Z',
        timezone: 'UTC',
        themeId: 'roman-ornate',
      ),
      SgClock(
        clockStyle: SgClockClockStyle.analog,
        size: 180,
        initialServerTime: '2026-06-15T10:08:30Z',
        timezone: 'UTC',
        themeId: 'dark',
        secondHandMode: SgClockSecondHandMode.smooth,
      ),
    ],
  ),
)
''';

  /// Region `sg-clock-cartao`.
  static const String sgClockCartao = r'''
const SgClock(
  initialServerTime: '2026-06-15T09:41:07Z',
  timezone: 'UTC',
  cardTitle: Text('Hora de Brasília'),
  cardProps: SgClockCardProps(
    id: 'brasilia',
    draggable: false,
    collapsible: false,
  ),
)
''';

  /// Region `sg-clock-centro`.
  static const String sgClockCentro = r'''
SgClockThemeProvider(
  value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
  child: const SgClock(
    clockStyle: SgClockClockStyle.analog,
    size: 220,
    initialServerTime: '2026-06-15T03:45:00Z',
    timezone: 'UTC',
    themeId: 'seedgrid',
    showSeconds: false,
    centerOverlay: Icon(Icons.eco, size: 20),
  ),
)
''';

  /// Region `sg-clock-digital`.
  static const String sgClockDigital = r'''
const SgClock(
  initialServerTime: '2026-06-15T09:41:07-03:00',
  timezone: 'America/Sao_Paulo',
)
''';

  /// Region `sg-clock-estilo`.
  static const String sgClockEstilo = r'''
const SgClock(
  initialServerTime: '2026-06-15T09:41:07Z',
  timezone: 'UTC',
  digitalStyle: SgClockDigitalStyle.flip,
  showSeconds: false,
  size: 'lg',
)
''';

  /// Region `sg-clock-tamanhos`.
  static const String sgClockTamanhos = r'''
const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgClock(
      size: 'sm',
      initialServerTime: '2026-06-15T12:00:00Z',
      timezone: 'UTC',
    ),
    SgClock(
      size: 'lg',
      initialServerTime: '2026-06-15T12:00:00Z',
      timezone: 'UTC',
    ),
    SgClock(
      size: 28,
      initialServerTime: '2026-06-15T12:00:00Z',
      timezone: 'UTC',
    ),
  ],
)
''';
}
