// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_clock_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgClockPageSnippets {
  /// Region `sg-clock-analogico`.
  static const String sgClockAnalogico = r'''
SgClockThemeProvider(
  value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
  child: Wrap(
    spacing: 16,
    runSpacing: 16,
    crossAxisAlignment: WrapCrossAlignment.start,
    children: [
      SizedBox(
        width: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SgClockThemePicker(
              value: _themeId,
              onChange: (id) => setState(() => _themeId = id),
              label: context.tx('Tema'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: Text(
                    _smooth
                        ? context.tx('Segundos: smooth')
                        : context.tx('Segundos: step'),
                  ),
                  onClick: () => setState(() => _smooth = !_smooth),
                ),
                SgButton(
                  label: Text(
                    _showSeconds
                        ? context.tx('Segundos: ON')
                        : context.tx('Segundos: OFF'),
                  ),
                  onClick: () =>
                      setState(() => _showSeconds = !_showSeconds),
                ),
              ],
            ),
          ],
        ),
      ),
      SgClock(
        clockStyle: SgClockClockStyle.analog,
        size: 220,
        initialServerTime: '2026-06-15T10:08:30Z',
        timezone: 'UTC',
        themeId: _themeId,
        showSeconds: _showSeconds,
        secondHandMode: _smooth
            ? SgClockSecondHandMode.smooth
            : SgClockSecondHandMode.step,
      ),
    ],
  ),
)
''';

  /// Region `sg-clock-cartao`.
  static const String sgClockCartao = r'''
SgClock(
  initialServerTime: '2026-06-15T09:41:07Z',
  timezone: 'UTC',
  cardTitle: Text(context.tx('Hora de Brasília')),
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
const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgClock(
      size: 'sm',
      initialServerTime: '2026-06-15T09:41:07-03:00',
      timezone: 'America/Sao_Paulo',
    ),
    SgClock(
      initialServerTime: '2026-06-15T09:41:07-03:00',
      timezone: 'America/Sao_Paulo',
    ),
    SgClock(
      size: 'lg',
      initialServerTime: '2026-06-15T09:41:07-03:00',
      timezone: 'America/Sao_Paulo',
    ),
    SgClock(
      size: 28,
      initialServerTime: '2026-06-15T09:41:07-03:00',
      timezone: 'America/Sao_Paulo',
    ),
  ],
)
''';

  /// Region `sg-clock-discard`.
  static const String sgClockDiscard = r'''
Builder(
  builder: (context) {
    var showSeconds = true;
    var format = SgClockFormat.v24h;
    return StatefulBuilder(
      builder: (context, set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(
                  showSeconds
                      ? context.tx('Segundos: ON')
                      : context.tx('Segundos: OFF'),
                ),
                onClick: () =>
                    set(() => showSeconds = !showSeconds),
              ),
              SgButton(
                label: Text(
                  format == SgClockFormat.v24h ? '24h' : '12h',
                ),
                onClick: () => set(
                  () => format = format == SgClockFormat.v24h
                      ? SgClockFormat.v12h
                      : SgClockFormat.v24h,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SgClock(
              digitalStyle: SgClockDigitalStyle.discard,
              size: 'lg',
              initialServerTime: '2026-06-15T09:41:07-03:00',
              timezone: 'America/Sao_Paulo',
              format: format,
              showSeconds: showSeconds,
            ),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-clock-fade`.
  static const String sgClockFade = r'''
Builder(
  builder: (context) {
    var showSeconds = true;
    var format = SgClockFormat.v24h;
    return StatefulBuilder(
      builder: (context, set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(
                  showSeconds
                      ? context.tx('Segundos: ON')
                      : context.tx('Segundos: OFF'),
                ),
                onClick: () =>
                    set(() => showSeconds = !showSeconds),
              ),
              SgButton(
                label: Text(
                  format == SgClockFormat.v24h ? '24h' : '12h',
                ),
                onClick: () => set(
                  () => format = format == SgClockFormat.v24h
                      ? SgClockFormat.v12h
                      : SgClockFormat.v24h,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SgClock(
              digitalStyle: SgClockDigitalStyle.fade,
              initialServerTime: '2026-06-15T09:41:07-03:00',
              timezone: 'America/Sao_Paulo',
              format: format,
              showSeconds: showSeconds,
            ),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-clock-flip`.
  static const String sgClockFlip = r'''
Builder(
  builder: (context) {
    var showSeconds = true;
    var format = SgClockFormat.v24h;
    return StatefulBuilder(
      builder: (context, set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(
                  showSeconds
                      ? context.tx('Segundos: ON')
                      : context.tx('Segundos: OFF'),
                ),
                onClick: () =>
                    set(() => showSeconds = !showSeconds),
              ),
              SgButton(
                label: Text(
                  format == SgClockFormat.v24h ? '24h' : '12h',
                ),
                onClick: () => set(
                  () => format = format == SgClockFormat.v24h
                      ? SgClockFormat.v12h
                      : SgClockFormat.v24h,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SgClock(
              digitalStyle: SgClockDigitalStyle.flip,
              size: 'lg',
              initialServerTime: '2026-06-15T09:41:07-03:00',
              timezone: 'America/Sao_Paulo',
              format: format,
              showSeconds: showSeconds,
            ),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-clock-matrix`.
  static const String sgClockMatrix = r'''
Builder(
  builder: (context) {
    var showSeconds = true;
    var format = SgClockFormat.v24h;
    return StatefulBuilder(
      builder: (context, set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(
                  showSeconds
                      ? context.tx('Segundos: ON')
                      : context.tx('Segundos: OFF'),
                ),
                onClick: () =>
                    set(() => showSeconds = !showSeconds),
              ),
              SgButton(
                label: Text(
                  format == SgClockFormat.v24h ? '24h' : '12h',
                ),
                onClick: () => set(
                  () => format = format == SgClockFormat.v24h
                      ? SgClockFormat.v12h
                      : SgClockFormat.v24h,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SgClock(
              digitalStyle: SgClockDigitalStyle.matrix,
              size: 'sm',
              initialServerTime: '2026-06-15T09:41:07-03:00',
              timezone: 'America/Sao_Paulo',
              format: format,
              showSeconds: showSeconds,
            ),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-clock-neon`.
  static const String sgClockNeon = r'''
Builder(
  builder: (context) {
    var showSeconds = true;
    var format = SgClockFormat.v24h;
    return StatefulBuilder(
      builder: (context, set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(
                  showSeconds
                      ? context.tx('Segundos: ON')
                      : context.tx('Segundos: OFF'),
                ),
                onClick: () =>
                    set(() => showSeconds = !showSeconds),
              ),
              SgButton(
                label: Text(
                  format == SgClockFormat.v24h ? '24h' : '12h',
                ),
                onClick: () => set(
                  () => format = format == SgClockFormat.v24h
                      ? SgClockFormat.v12h
                      : SgClockFormat.v24h,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SgClock(
              digitalStyle: SgClockDigitalStyle.neon,
              initialServerTime: '2026-06-15T09:41:07-03:00',
              timezone: 'America/Sao_Paulo',
              format: format,
              showSeconds: showSeconds,
            ),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-clock-roller3d`.
  static const String sgClockRoller3d = r'''
Builder(
  builder: (context) {
    var showSeconds = true;
    var format = SgClockFormat.v12h;
    return StatefulBuilder(
      builder: (context, set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(
                  showSeconds
                      ? context.tx('Segundos: ON')
                      : context.tx('Segundos: OFF'),
                ),
                onClick: () =>
                    set(() => showSeconds = !showSeconds),
              ),
              SgButton(
                label: Text(
                  format == SgClockFormat.v24h ? '24h' : '12h',
                ),
                onClick: () => set(
                  () => format = format == SgClockFormat.v24h
                      ? SgClockFormat.v12h
                      : SgClockFormat.v24h,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SgClock(
              digitalStyle: SgClockDigitalStyle.roller3d,
              size: 'lg',
              initialServerTime: '2026-06-15T15:41:07-03:00',
              timezone: 'America/Sao_Paulo',
              format: format,
              showSeconds: showSeconds,
            ),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-clock-segment`.
  static const String sgClockSegment = r'''
Builder(
  builder: (context) {
    var showSeconds = true;
    var format = SgClockFormat.v24h;
    return StatefulBuilder(
      builder: (context, set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(
                  showSeconds
                      ? context.tx('Segundos: ON')
                      : context.tx('Segundos: OFF'),
                ),
                onClick: () =>
                    set(() => showSeconds = !showSeconds),
              ),
              SgButton(
                label: Text(
                  format == SgClockFormat.v24h ? '24h' : '12h',
                ),
                onClick: () => set(
                  () => format = format == SgClockFormat.v24h
                      ? SgClockFormat.v12h
                      : SgClockFormat.v24h,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SgClock(
              digitalStyle: SgClockDigitalStyle.segment,
              initialServerTime: '2026-06-15T09:41:07-03:00',
              timezone: 'America/Sao_Paulo',
              format: format,
              showSeconds: showSeconds,
            ),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-clock-seven-segment`.
  static const String sgClockSevenSegment = r'''
Builder(
  builder: (context) {
    var showSeconds = true;
    var format = SgClockFormat.v24h;
    return StatefulBuilder(
      builder: (context, set) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(
                  showSeconds
                      ? context.tx('Segundos: ON')
                      : context.tx('Segundos: OFF'),
                ),
                onClick: () =>
                    set(() => showSeconds = !showSeconds),
              ),
              SgButton(
                label: Text(
                  format == SgClockFormat.v24h ? '24h' : '12h',
                ),
                onClick: () => set(
                  () => format = format == SgClockFormat.v24h
                      ? SgClockFormat.v12h
                      : SgClockFormat.v24h,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SgClock(
              digitalStyle: SgClockDigitalStyle.sevenSegment,
              size: 'sm',
              initialServerTime: '2026-06-15T09:41:07-03:00',
              timezone: 'America/Sao_Paulo',
              format: format,
              showSeconds: showSeconds,
            ),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-clock-tema-inline`.
  static const String sgClockTemaInline = r'''
SgClock(
  clockStyle: SgClockClockStyle.analog,
  size: 220,
  initialServerTime: '2026-06-15T10:08:30Z',
  timezone: 'UTC',
  secondHandMode: SgClockSecondHandMode.smooth,
  theme: SgClockTheme(
    id: 'inline-theme',
    label: 'Inline Theme',
    ops: [
      SgClockCircle(
        cx: 50,
        cy: 50,
        r: 48,
        fill: SgClockPaint(
          light: Color(0xFFFFFFFF),
          dark: Color(0xFF0A0A0A),
        ),
        stroke: SgClockPaint(
          light: Color(0xFFD4D4D4),
          dark: Color(0xFF404040),
        ),
        strokeWidth: 1,
      ),
      SgClockCircle(
        cx: 50,
        cy: 50,
        r: 38,
        stroke: SgClockPaint(
          light: Color(0xFFE5E5E5),
          dark: Color(0xFF262626),
        ),
        strokeWidth: 1,
      ),
      SgClockText(
        x: 50,
        y: 56,
        text: 'SeedGrid',
        anchor: 'middle',
        fontSize: 8,
        fontWeight: 600,
        fill: SgClockPaint(
          light: Color(0xFFA3A3A3),
          dark: Color(0xFFA3A3A3),
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-clock-timezone`.
  static const String sgClockTimezone = r'''
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
      timezone: 'Europe/Lisbon',
      locale: 'pt-PT',
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
}
