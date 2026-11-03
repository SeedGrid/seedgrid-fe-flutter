// Showcase do SgNeonDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_neon_digit_page.snippets.g.dart';

class SgNeonDigitPage extends StatefulWidget {
  const SgNeonDigitPage({super.key});

  @override
  State<SgNeonDigitPage> createState() => _SgNeonDigitPageState();
}

class _SgNeonDigitPageState extends State<SgNeonDigitPage> {
  int _digito = 0;
  int _palavra = 0;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Controle simples de dígito em estilo neon.',
        preview:
            // #region sg-neon-digit-basico
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgNeonDigit(
                  value: '$_digito',
                  color: '#f8fafc',
                  backgroundColor: '#120f2b',
                  shadowColor: '#8b5cf6',
                ),
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
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitBasico,
      ),
      ShowcaseExample(
        title: 'Texto em neon',
        description: 'Troca de palavras com o mesmo componente.',
        preview:
            // #region sg-neon-digit-texto
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgNeonDigit(
                  value: const ['teste', 'seedgrid', 'your text'][_palavra],
                  color: '#e2f6ff',
                  backgroundColor: '#101934',
                  shadowColor: '#47d1ff',
                ),
                SgButton(
                  label: Text(context.tx('Trocar texto')),
                  onClick: () => setState(() => _palavra = (_palavra + 1) % 3),
                ),
              ],
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitTexto,
      ),
      ShowcaseExample(
        title: 'Neon script (referência visual)',
        description: 'Visual inspirado nas imagens azul e laranja.',
        preview:
            // #region sg-neon-digit-script
            const Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SgNeonDigit(
                  value: 'Your Text',
                  color: '#e4fbff',
                  backgroundColor: '#090f22',
                  shadowColor: '#47d1ff',
                  font:
                      '"Brush Script MT", "Segoe Script", "Lucida Handwriting", cursive',
                  fontWeight: 500,
                  fontSize: 62,
                  padding: 18,
                  shadowStrength: 1.25,
                ),
                SgNeonDigit(
                  value: 'Your Text',
                  color: '#fff7e5',
                  backgroundColor: '#1c120b',
                  shadowColor: '#ffae1a',
                  font:
                      '"Brush Script MT", "Segoe Script", "Lucida Handwriting", cursive',
                  fontWeight: 500,
                  fontSize: 62,
                  padding: 18,
                  shadowStrength: 1.25,
                ),
              ],
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitScript,
      ),
      ShowcaseExample(
        title: 'Variações de color/background/shadow',
        description: 'Mesmo texto com paletas diferentes.',
        preview:
            // #region sg-neon-digit-variacoes
            const Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SgNeonDigit(
                  value: 'teste',
                  color: '#e2f6ff',
                  backgroundColor: '#0b1130',
                  shadowColor: '#38bdf8',
                ),
                SgNeonDigit(
                  value: 'teste',
                  color: '#f5e9ff',
                  backgroundColor: '#170f2b',
                  shadowColor: '#a855f7',
                ),
                SgNeonDigit(
                  value: 'teste',
                  color: '#fff7e8',
                  backgroundColor: '#2a1a14',
                  shadowColor: '#fb923c',
                ),
              ],
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitVariacoes,
      ),
      ShowcaseExample(
        title: 'Escala e leitura',
        description: 'fontSize e padding combinados.',
        preview:
            // #region sg-neon-digit-escala
            const Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgNeonDigit(value: '5', fontSize: 24, padding: 10),
                SgNeonDigit(value: '5', fontSize: 44, padding: 14),
                SgNeonDigit(value: '5', fontSize: 72, padding: 18),
              ],
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitEscala,
      ),
      // Exemplos só do Flutter (depois dos que espelham o React).
      ShowcaseExample(
        title: 'Brilho neon',
        description:
            'Cinco camadas de brilho no texto e duas no contorno, todas em torno da cor do texto.',
        preview:
            // #region sg-neon-digit-brilho
            const Wrap(
              spacing: 32,
              runSpacing: 32,
              children: [
                SgNeonDigit(value: '24'),
                SgNeonDigit(
                  value: '59',
                  color: '#ff7ad9',
                  shadowColor: '#ff00aa',
                  backgroundColor: '#1a0612',
                ),
                SgNeonDigit(
                  value: 'GO',
                  color: '#7dd3fc',
                  shadowColor: '#0ea5e9',
                  backgroundColor: '#04121c',
                ),
              ],
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitBrilho,
      ),
      ShowcaseExample(
        title: 'Intensidade, fonte e espaçamento',
        description:
            'shadowStrength (mínimo 0,2), fontSize, fontWeight (número ou texto), letterSpacing, padding e rounded.',
        preview:
            // #region sg-neon-digit-fonte
            const Wrap(
              spacing: 32,
              runSpacing: 32,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgNeonDigit(value: '8', shadowStrength: 0.3, fontSize: 36),
                SgNeonDigit(value: '8', shadowStrength: 2, fontSize: 36),
                SgNeonDigit(
                  value: 'OK',
                  fontWeight: 'bold',
                  letterSpacing: 6,
                  padding: 20,
                  rounded: 28,
                ),
                SgNeonDigit(value: '7', fontWeight: 300, fontSize: 64),
              ],
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitFonte,
      ),
      ShowcaseExample(
        title: 'Troca de valor com apagar e acender',
        description:
            'Ao trocar o valor, o texto apaga, muda na metade de transitionMs e acende de novo (animateOnChange).',
        preview:
            // #region sg-neon-digit-troca
            Builder(
              builder: (context) {
                var value = 1;
                return StatefulBuilder(
                  builder: (context, set) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SgNeonDigit(value: '$value', transitionMs: 400),
                      const SizedBox(width: 24),
                      FilledButton(
                        onPressed: () => set(() => value = value % 9 + 1),
                        child: Text(context.tx('Próximo')),
                      ),
                    ],
                  ),
                );
              },
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitTroca,
      ),
      ShowcaseExample(
        title: 'Sem animação',
        preview:
            // #region sg-neon-digit-sem-animacao
            Builder(
              builder: (context) {
                var value = 1;
                return StatefulBuilder(
                  builder: (context, set) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SgNeonDigit(value: '$value', animateOnChange: false),
                      const SizedBox(width: 24),
                      FilledButton(
                        onPressed: () => set(() => value = value % 9 + 1),
                        child: Text(context.tx('Próximo')),
                      ),
                    ],
                  ),
                );
              },
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitSemAnimacao,
      ),
    ];

    return SgShowcasePage(
      name: 'SgNeonDigit',
      description:
          'Texto com brilho neon que apaga e acende ao trocar o valor, com cores, intensidade e fonte configuráveis.',
      examples: examples,
      propSpecs: sgPropSpecs['SgNeonDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgNeonDigit']!
            .where(
              (s) => const {
                'value',
                'color',
                'backgroundColor',
                'shadowColor',
                'font',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgNeonDigit(
          value: (v['value'] as String?) ?? '8',
          color: (v['color'] as String?) ?? '#e2e8f0',
          backgroundColor: (v['backgroundColor'] as String?) ?? '#120f2b',
          shadowColor: v['shadowColor'] as String?,
          font: v['font'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["value: '${(v['value'] as String?) ?? '8'}'"];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add("${e.key}: '${e.value}'");
          }
          return 'SgNeonDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
