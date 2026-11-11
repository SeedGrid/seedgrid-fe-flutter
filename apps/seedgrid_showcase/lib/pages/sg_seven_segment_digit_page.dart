// Showcase do SgSevenSegmentDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_seven_segment_digit_page.snippets.g.dart';

class SgSevenSegmentDigitPage extends StatefulWidget {
  const SgSevenSegmentDigitPage({super.key});

  @override
  State<SgSevenSegmentDigitPage> createState() =>
      _SgSevenSegmentDigitPageState();
}

class _SgSevenSegmentDigitPageState extends State<SgSevenSegmentDigitPage> {
  final ValueNotifier<int> _digito = ValueNotifier(0);
  final ValueNotifier<SgSevenSegmentDigitPalette> _paleta = ValueNotifier(
    SgSevenSegmentDigitPalette.red,
  );
  final ValueNotifier<int> _hexIndex = ValueNotifier(10);
  final ValueNotifier<int> _segundos = ValueNotifier(0);

  @override
  void dispose() {
    _digito.dispose();
    _paleta.dispose();
    _hexIndex.dispose();
    _segundos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const hex = '0123456789ABCDEF';
    const doisPontos = Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xCCEF4444)),
          SizedBox(height: 8),
          Icon(Icons.circle, size: 8, color: Color(0xCCEF4444)),
        ],
      ),
    );
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (0-9)',
        description: 'Troca manual de dígitos com controles.',
        preview:
            // #region sg-seven-segment-digit-basico
            ListenableBuilder(
              listenable: Listenable.merge([_digito, _paleta]),
              builder: (context, _) => Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SgSevenSegmentDigit(
                    value: '${_digito.value}',
                    palette: _paleta.value,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgButton(
                        label: Text(context.tx('Próximo (+1)')),
                        size: SgSize.sm,
                        onClick: () => _digito.value = (_digito.value + 1) % 10,
                      ),
                      const SizedBox(height: 8),
                      SgButton(
                        label: Text(context.tx('Anterior (-1)')),
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        onClick: () => _digito.value = (_digito.value + 9) % 10,
                      ),
                      const SizedBox(height: 8),
                      SgButton(
                        label: Text(context.tx('Aleatório')),
                        size: SgSize.sm,
                        onClick: () => _digito.value =
                            (_digito.value + 1 + Random().nextInt(9)) % 10,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final item in SgSevenSegmentDigitPalette.values)
                            SgButton(
                              label: Text(item.name),
                              size: SgSize.sm,
                              appearance: _paleta.value == item
                                  ? SgAppearance.solid
                                  : SgAppearance.outline,
                              onClick: () => _paleta.value = item,
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitBasico,
      ),
      ShowcaseExample(
        title: 'Hexadecimal (0-9 A-F)',
        description: 'Suporte a caracteres comuns de display de 7 segmentos.',
        preview:
            // #region sg-seven-segment-digit-hexadecimal
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _hexIndex,
                  builder: (context, hexIndex, _) => SgSevenSegmentDigit(
                    value: hex[hexIndex],
                    color: '#f97316',
                    backgroundColor: '#180b05',
                    offColor: 'rgba(124,45,18,0.24)',
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Próximo caractere')),
                  size: SgSize.sm,
                  onClick: () =>
                      _hexIndex.value = (_hexIndex.value + 1) % hex.length,
                ),
              ],
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitHexadecimal,
      ),
      ShowcaseExample(
        title: 'Temas de cor',
        description:
            'Exemplos com as paletas red, blue, yellow, green e white.',
        preview:
            // #region sg-seven-segment-digit-temas
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final palette in SgSevenSegmentDigitPalette.values)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(palette.name),
                      SgSevenSegmentDigit(value: '8', palette: palette),
                    ],
                  ),
              ],
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitTemas,
      ),
      ShowcaseExample(
        title: 'Tamanho e espessura',
        description: 'Escala do display via size e thickness.',
        preview:
            // #region sg-seven-segment-digit-tamanho-espessura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Pequeno')),
                    const SgSevenSegmentDigit(
                      value: '5',
                      size: 72,
                      thickness: 10,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Médio')),
                    const SgSevenSegmentDigit(
                      value: '5',
                      size: 108,
                      thickness: 14,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Grande')),
                    const SgSevenSegmentDigit(
                      value: '5',
                      size: 148,
                      thickness: 18,
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code:
            SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitTamanhoEspessura,
      ),
      ShowcaseExample(
        title: 'Composição estilo relógio',
        description: 'Composição de vários dígitos para HH:MM:SS.',
        preview:
            // #region sg-seven-segment-digit-relogio
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _segundos,
                  builder: (context, segundos, _) {
                    String dois(int n) => n.toString().padLeft(2, '0');
                    final total = segundos % 86400;
                    final hh = dois(total ~/ 3600);
                    final mm = dois(total % 3600 ~/ 60);
                    final ss = dois(total % 60);
                    return Wrap(
                      spacing: 4,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (final c in hh.split(''))
                          SgSevenSegmentDigit(value: c, size: 86),
                        doisPontos,
                        for (final c in mm.split(''))
                          SgSevenSegmentDigit(value: c, size: 86),
                        doisPontos,
                        for (final c in ss.split(''))
                          SgSevenSegmentDigit(value: c, size: 86),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('+1 segundo')),
                  size: SgSize.sm,
                  onClick: () => _segundos.value++,
                ),
              ],
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitRelogio,
      ),
      ShowcaseExample(
        title: 'Algarismos e letras',
        description:
            'Cada caractere acende os segmentos da tabela do display; sem glifo, apaga tudo.',
        preview:
            // #region sg-seven-segment-digit-algarismos
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in '0123456789-AbCdEFHJLPUY'.split(''))
                  SgSevenSegmentDigit(
                    value: c,
                    size: 72,
                    thickness: 8,
                    padding: 8,
                  ),
              ],
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitAlgarismos,
      ),
      ShowcaseExample(
        title: 'Paletas',
        description:
            'red (padrão), blue, yellow, green e white; color, backgroundColor e offColor vencem a paleta.',
        preview:
            // #region sg-seven-segment-digit-paletas
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final palette in SgSevenSegmentDigitPalette.values)
                  SgSevenSegmentDigit(
                    value: '8',
                    palette: palette,
                    size: 72,
                    thickness: 8,
                    padding: 8,
                  ),
                const SgSevenSegmentDigit(
                  value: '8',
                  size: 72,
                  thickness: 8,
                  padding: 8,
                  color: '#ff00aa',
                  offColor: 'rgba(255, 0, 170, 0.15)',
                  backgroundColor: '#14000d',
                ),
              ],
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitPaletas,
      ),
      ShowcaseExample(
        title: 'Tamanho, espessura, inclinação e brilho',
        preview:
            // #region sg-seven-segment-digit-medidas
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                SgSevenSegmentDigit(value: '4', size: 48, thickness: 5),
                SgSevenSegmentDigit(value: '2', size: 108),
                SgSevenSegmentDigit(
                  value: '7',
                  size: 108,
                  thickness: 8,
                  width: 80,
                ),
                SgSevenSegmentDigit(
                  value: '5',
                  size: 108,
                  thickness: 8,
                  skew: 0,
                  rounded: 0,
                ),
                SgSevenSegmentDigit(
                  value: '3',
                  size: 108,
                  thickness: 8,
                  skew: 15,
                  glow: false,
                ),
              ],
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitMedidas,
      ),
      ShowcaseExample(
        title: 'Contador com transição',
        description:
            'Ao trocar o valor, cada segmento acende e apaga em transitionMs (200 ms aqui).',
        preview:
            // #region sg-seven-segment-digit-contador
            Builder(
              builder: (context) {
                var value =
                    0; // o estado fica na closure; o StatefulBuilder so reconstroi
                return StatefulBuilder(
                  builder: (context, set) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SgSevenSegmentDigit(
                        value: '$value',
                        size: 72,
                        thickness: 8,
                        padding: 8,
                        transitionMs: 200,
                      ),
                      const SizedBox(width: 16),
                      SgButton(
                        label: Text(context.tx('Próximo')),
                        onClick: () => set(() => value = (value + 1) % 10),
                      ),
                    ],
                  ),
                );
              },
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitContador,
      ),
    ];

    return SgShowcasePage(
      name: 'SgSevenSegmentDigit',
      description:
          'Display de sete segmentos estilo LED, com paletas, inclinação, brilho e transição entre valores.',
      examples: examples,
      propSpecs: sgPropSpecs['SgSevenSegmentDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgSevenSegmentDigit']!
            .where(
              (s) => const {
                'value',
                'palette',
                'color',
                'backgroundColor',
                'offColor',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgSevenSegmentDigit(
          value: (v['value'] as String?) ?? '8',
          palette:
              SgSevenSegmentDigitPalette.fromValue(v['palette'] as String?) ??
              SgSevenSegmentDigitPalette.red,
          color: v['color'] as String?,
          backgroundColor: v['backgroundColor'] as String?,
          offColor: v['offColor'] as String?,
          size: 96,
          thickness: 10,
          padding: 8,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "value: '${(v['value'] as String?) ?? '8'}'",
            'size: 96',
            'thickness: 10',
            'padding: 8',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add(switch (e.key) {
              'palette' =>
                'palette: SgSevenSegmentDigitPalette.${SgSevenSegmentDigitPalette.fromValue(e.value as String)!.name}',
              _ => "${e.key}: '${e.value}'",
            });
          }
          return 'SgSevenSegmentDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
