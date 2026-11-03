// Showcase do SgSegmentDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_segment_digit_page.snippets.g.dart';

class SgSegmentDigitPage extends StatefulWidget {
  const SgSegmentDigitPage({super.key});

  @override
  State<SgSegmentDigitPage> createState() => _SgSegmentDigitPageState();
}

class _SgSegmentDigitPageState extends State<SgSegmentDigitPage> {
  int _digito = 0;
  int _segundos = 0;

  @override
  Widget build(BuildContext context) {
    final total = _segundos % 86400;
    final hh = (total ~/ 3600).toString().padLeft(2, '0');
    final mm = ((total % 3600) ~/ 60).toString().padLeft(2, '0');
    final ss = (total % 60).toString().padLeft(2, '0');
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (0-9)',
        description: 'Troca manual de dígitos com controles.',
        preview:
            // #region sg-segment-digit-basico
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgSegmentDigit(value: '$_digito', size: 64),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Próximo (+1)')),
                      onClick: () =>
                          setState(() => _digito = (_digito + 1) % 10),
                    ),
                    SgButton(
                      label: Text(context.tx('Anterior (-1)')),
                      onClick: () =>
                          setState(() => _digito = (_digito + 9) % 10),
                    ),
                    SgButton(
                      label: Text(context.tx('Aleatório')),
                      onClick: () => setState(
                        () => _digito = DateTime.now().microsecond % 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitBasico,
      ),
      ShowcaseExample(
        title: 'Composição estilo relógio',
        description:
            "Composição HH:MM:SS com separador ':' usando o próprio componente.",
        preview:
            // #region sg-segment-digit-relogio
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SgSegmentDigit(value: hh[0], size: 36),
                    const SizedBox(width: 4),
                    SgSegmentDigit(value: hh[1], size: 36),
                    const SizedBox(width: 4),
                    const SgSegmentDigit(value: ':', size: 36),
                    const SizedBox(width: 4),
                    SgSegmentDigit(value: mm[0], size: 36),
                    const SizedBox(width: 4),
                    SgSegmentDigit(value: mm[1], size: 36),
                    const SizedBox(width: 4),
                    const SgSegmentDigit(value: ':', size: 36),
                    const SizedBox(width: 4),
                    SgSegmentDigit(value: ss[0], size: 36),
                    const SizedBox(width: 4),
                    SgSegmentDigit(value: ss[1], size: 36),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('+1 segundo')),
                  onClick: () => setState(() => _segundos++),
                ),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitRelogio,
      ),
      ShowcaseExample(
        title: 'Tamanhos',
        description: 'Escala visual ajustando apenas a prop size.',
        preview:
            // #region sg-segment-digit-tamanhos
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Pequeno')),
                    SgSegmentDigit(value: '8', size: 18),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Médio')),
                    SgSegmentDigit(value: '8', size: 32),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Grande')),
                    SgSegmentDigit(value: '8', size: 52),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitTamanhos,
      ),
      ShowcaseExample(
        title: 'Cores',
        description: 'Exemplos de color por dígito.',
        preview:
            // #region sg-segment-digit-cores
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Padrão')),
                    SgSegmentDigit(value: '8', size: 42),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Azul')),
                    SgSegmentDigit(value: '8', size: 42, color: '#3b82f6'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Amarelo')),
                    SgSegmentDigit(value: '8', size: 42, color: '#eab308'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Verde')),
                    SgSegmentDigit(value: '8', size: 42, color: '#22c55e'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Branco')),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171717),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const SgSegmentDigit(
                        value: '8',
                        size: 42,
                        color: '#f8fafc',
                      ),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitCores,
      ),
      // Exemplo só do Flutter (depois dos que espelham o React).
      ShowcaseExample(
        title: 'Algarismos, sinal e dois pontos',
        description:
            'Cada glifo é um conjunto de retângulos numa grade de 6 x 10 (dois pontos: 4 x 10).',
        preview:
            // #region sg-segment-digit-algarismos
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in '0123456789-:'.split(''))
                  SgSegmentDigit(value: c, size: 48),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitAlgarismos,
      ),
    ];

    return SgShowcasePage(
      name: 'SgSegmentDigit',
      description:
          'Dígito desenhado com retângulos (estilo calculadora), com tamanho e cor configuráveis.',
      examples: examples,
      propSpecs: sgPropSpecs['SgSegmentDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgSegmentDigit']!
            .where((s) => const {'value', 'color'}.contains(s.name))
            .toList(),
        builder: (context, v) => SgSegmentDigit(
          value: (v['value'] as String?) ?? '8',
          color: v['color'] as String?,
          size: 64,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "value: '${(v['value'] as String?) ?? '8'}'",
            'size: 64',
          ];
          if (v['color'] != null) args.add("color: '${v['color']}'");
          return 'SgSegmentDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
