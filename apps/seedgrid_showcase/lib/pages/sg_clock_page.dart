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
  @override
  void initState() {
    super.initState();
    // Os estilos digitais animados dependem dos widgets de digitos. Aqui registramos um construtor de
    // exemplo para `flip`; sem construtor registrado o SgClock usa o estilo padrao.
    registerSgClockDigitalStyle(
      SgClockDigitalStyle.flip,
      (context, parts) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final ch in parts.text.split(''))
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                ch,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: parts.sizePx * 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    unregisterSgClockDigitalStyle(SgClockDigitalStyle.flip);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Digital',
        description:
            'Relógio digital padrão: 24 horas, com segundos. initialServerTime fixa a hora de partida; o relógio anda sozinho.',
        preview:
            // #region sg-clock-digital
            const SgClock(
              initialServerTime: '2026-06-15T09:41:07-03:00',
              timezone: 'America/Sao_Paulo',
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockDigital,
      ),
      ShowcaseExample(
        title: 'Fuso, idioma e 12 horas',
        description:
            'timezone aceita nomes de fuso conhecidos (America/Sao_Paulo, Europe/Paris, Asia/Tokyo...), UTC e deslocamentos (+03:00). O período do dia vem do idioma.',
        preview:
            // #region sg-clock-12h
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
            ),
        // #endregion
        code: SgClockPageSnippets.sgClock12h,
      ),
      ShowcaseExample(
        title: 'Tamanhos',
        description:
            'size: sm, md (padrão), lg ou um número em pixels (altura de linha 1).',
        preview:
            // #region sg-clock-tamanhos
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
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockTamanhos,
      ),
      ShowcaseExample(
        title: 'Analógico com tema',
        description:
            'Os temas embutidos não são registrados sozinhos: o SgClockThemeProvider recebe sgClockThemesBuiltIn. themeId escolhe o tema; id desconhecido cai no classic.',
        preview:
            // #region sg-clock-analogico
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
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockAnalogico,
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
        title: 'Estilo digital registrado',
        description:
            'digitalStyle: flip só ganha forma quando há um construtor registrado com registerSgClockDigitalStyle (esta página registra um de exemplo). Sem ele, cai no estilo padrão.',
        preview:
            // #region sg-clock-estilo
            const SgClock(
              initialServerTime: '2026-06-15T09:41:07Z',
              timezone: 'UTC',
              digitalStyle: SgClockDigitalStyle.flip,
              showSeconds: false,
              size: 'lg',
            ),
        // #endregion
        code: SgClockPageSnippets.sgClockEstilo,
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
