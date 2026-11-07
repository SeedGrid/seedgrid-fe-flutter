// Showcase do SgClock. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_clock_page.snippets.g.dart';

class SgClockPage extends StatefulWidget {
  const SgClockPage({super.key});

  @override
  State<SgClockPage> createState() => _SgClockPageState();
}

class _SgClockPageState extends State<SgClockPage> {
  String _themeId = 'seedgrid';
  bool _smooth = false;
  bool _showSeconds = true;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Analógico',
        description: 'Seletor de tema com segundos step/smooth.',
        preview:
            // #region sg-clock-analogico
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
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockAnalogico,
      ),
      ShowcaseExample(
        title: 'Tema inline (sem provider)',
        description: 'Passe um objeto de tema direto no SgClock.',
        preview:
            // #region sg-clock-tema-inline
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
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockTemaInline,
      ),
      ShowcaseExample(
        title: 'Digital',
        description: 'Presets de tamanho com locale/timezone.',
        preview:
            // #region sg-clock-digital
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
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockDigital,
      ),
      ShowcaseExample(
        title: 'Roller 3D',
        description: 'Rolos 3D com AM/PM opcional e segundos sob demanda.',
        preview:
            // #region sg-clock-roller3d
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SgClock(
                digitalStyle: SgClockDigitalStyle.roller3d,
                size: 'lg',
                initialServerTime: '2026-06-15T15:41:07-03:00',
                timezone: 'America/Sao_Paulo',
                format: SgClockFormat.v12h,
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockRoller3d,
      ),
      ShowcaseExample(
        title: 'Flip',
        description: 'Flip clock em duas folhas, com segundos e 12/24h.',
        preview:
            // #region sg-clock-flip
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SgClock(
                digitalStyle: SgClockDigitalStyle.flip,
                size: 'lg',
                initialServerTime: '2026-06-15T09:41:07-03:00',
                timezone: 'America/Sao_Paulo',
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockFlip,
      ),
      ShowcaseExample(
        title: 'Segment',
        description: 'Estilo segmentado com leitura limpa.',
        preview:
            // #region sg-clock-segment
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SgClock(
                digitalStyle: SgClockDigitalStyle.segment,
                initialServerTime: '2026-06-15T09:41:07-03:00',
                timezone: 'America/Sao_Paulo',
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockSegment,
      ),
      ShowcaseExample(
        title: 'Seven Segment',
        description: 'Dígitos de sete segmentos com visual retrô.',
        preview:
            // #region sg-clock-seven-segment
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SgClock(
                digitalStyle: SgClockDigitalStyle.sevenSegment,
                size: 'sm',
                initialServerTime: '2026-06-15T09:41:07-03:00',
                timezone: 'America/Sao_Paulo',
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockSevenSegment,
      ),
      ShowcaseExample(
        title: 'Fade',
        description: 'Transição suave entre os dígitos.',
        preview:
            // #region sg-clock-fade
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SgClock(
                digitalStyle: SgClockDigitalStyle.fade,
                initialServerTime: '2026-06-15T09:41:07-03:00',
                timezone: 'America/Sao_Paulo',
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockFade,
      ),
      ShowcaseExample(
        title: 'Matrix',
        description: 'Estilo matriz de pontos para alta densidade visual.',
        preview:
            // #region sg-clock-matrix
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SgClock(
                digitalStyle: SgClockDigitalStyle.matrix,
                size: 'sm',
                initialServerTime: '2026-06-15T09:41:07-03:00',
                timezone: 'America/Sao_Paulo',
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockMatrix,
      ),
      ShowcaseExample(
        title: 'Neon',
        description: 'Tema com brilho de painel neon.',
        preview:
            // #region sg-clock-neon
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SgClock(
                digitalStyle: SgClockDigitalStyle.neon,
                initialServerTime: '2026-06-15T09:41:07-03:00',
                timezone: 'America/Sao_Paulo',
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockNeon,
      ),
      ShowcaseExample(
        title: 'Discard',
        description: 'Cartões empilhados com virada de dígito.',
        preview:
            // #region sg-clock-discard
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SgClock(
                digitalStyle: SgClockDigitalStyle.discard,
                size: 'lg',
                initialServerTime: '2026-06-15T09:41:07-03:00',
                timezone: 'America/Sao_Paulo',
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockDiscard,
      ),
      ShowcaseExample(
        title: 'Timezone',
        description: 'Troca rápida de timezone e formato 12h/24h.',
        preview:
            // #region sg-clock-timezone
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
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockTimezone,
      ),
      ShowcaseExample(
        title: 'Conteúdo no centro e sem segundos',
        description:
            'centerOverlay ocupa uma caixa de 30% do relógio no centro; showSeconds: false esconde o ponteiro dos segundos.',
        preview:
            // #region sg-clock-centro
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
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockCentro,
      ),
      ShowcaseExample(
        title: 'Cartão',
        description:
            'O relógio vem num SgCard recolhível e arrastável. cardTitle troca o título; cardProps ajusta o cartão.',
        preview:
            // #region sg-clock-cartao
            SgClock(
              initialServerTime: '2026-06-15T09:41:07Z',
              timezone: 'UTC',
              cardTitle: Text(context.tx('Hora de Brasília')),
              cardProps: SgClockCardProps(
                id: 'brasilia',
                draggable: false,
                collapsible: false,
              ),
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockCartao,
      ),
    ];

    return SgShowcasePage(
      name: 'SgClock',
      description:
          'Relógio analógico ou digital, com fuso, 12/24 horas, temas embutidos e cartão recolhível.',
      examples: examples,
      propSpecs: [
        for (final s in sgPropSpecs['SgClock']!)
          // O contrato gerado deixa cardProps como Object?; aqui ele tem tipo e descricao proprios.
          if (s.name == 'cardProps')
            const SgPropSpec(
              name: 'cardProps',
              reactName: 'cardProps',
              type: 'SgClockCardProps?',
              tsType: 'Omit<SgCardProps, "children" | "title">',
              required: false,
              description:
                  'Ajustes do cartão (subconjunto do SgCard; sem className/style).',
            )
          else
            s,
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgClock']!
            .where(
              (s) => const {
                'clockStyle',
                'format',
                'showSeconds',
                'secondHandMode',
                'timezone',
                'locale',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgClockThemeProvider(
          value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn),
          child: SgClock(
            key: ValueKey('${v['clockStyle']}-${v['timezone']}-${v['locale']}'),
            initialServerTime: '2026-06-15T15:41:07Z',
            timezone: (v['timezone'] as String?) ?? 'UTC',
            clockStyle:
                SgClockClockStyle.fromValue(v['clockStyle'] as String?) ??
                SgClockClockStyle.digital,
            format:
                SgClockFormat.fromValue(v['format'] as String?) ??
                SgClockFormat.v24h,
            showSeconds: (v['showSeconds'] as bool?) ?? true,
            secondHandMode:
                SgClockSecondHandMode.fromValue(
                  v['secondHandMode'] as String?,
                ) ??
                SgClockSecondHandMode.step,
            locale: (v['locale'] as String?) ?? 'pt-BR',
          ),
        ),
        codeBuilder: (v) {
          final args = <String>[
            "initialServerTime: '2026-06-15T15:41:07Z'",
            "timezone: '${(v['timezone'] as String?) ?? 'UTC'}'",
          ];
          if (v['clockStyle'] != null) {
            args.add(
              'clockStyle: SgClockClockStyle.${SgClockClockStyle.fromValue(v['clockStyle'] as String)!.name}',
            );
          }
          if (v['format'] != null) {
            args.add(
              'format: SgClockFormat.${SgClockFormat.fromValue(v['format'] as String)!.name}',
            );
          }
          if (v['showSeconds'] == true) args.add('showSeconds: true');
          if (v['secondHandMode'] != null) {
            args.add(
              'secondHandMode: SgClockSecondHandMode.${SgClockSecondHandMode.fromValue(v['secondHandMode'] as String)!.name}',
            );
          }
          if (v['locale'] != null) args.add("locale: '${v['locale']}'");
          return 'SgClock(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
