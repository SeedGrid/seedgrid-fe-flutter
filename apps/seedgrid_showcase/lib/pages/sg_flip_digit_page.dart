// Showcase do SgFlipDigit. O codigo exibido em cada exemplo e a regiao `// #region` deste arquivo.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_flip_digit_page.snippets.g.dart';

class SgFlipDigitPage extends StatefulWidget {
  const SgFlipDigitPage({super.key});

  @override
  State<SgFlipDigitPage> createState() => _SgFlipDigitPageState();
}

class _SgFlipDigitPageState extends State<SgFlipDigitPage> {
  int _n = 0;
  int _digito = 0;
  int _letra = 0; // 0 = A
  bool _rodando = false;
  int _auto = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _alternar() {
    setState(() => _rodando = !_rodando);
    _timer?.cancel();
    if (_rodando) {
      _timer = Timer.periodic(const Duration(milliseconds: 1300), (_) {
        if (mounted) setState(() => _auto = (_auto + 1) % 10);
      });
    }
  }

  int _clock = 1234;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (0-9)',
        description: 'Incremento, decremento e valor aleatório.',
        preview:
            // #region sg-flip-digit-basico
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgFlipDigit(value: '$_digito'),
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
        code: SgFlipDigitPageSnippets.sgFlipDigitBasico,
      ),
      ShowcaseExample(
        title: 'Letras (A-Z)',
        description: 'Também aceita caracteres alfabéticos.',
        preview:
            // #region sg-flip-digit-letras-az
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgFlipDigit(value: String.fromCharCode(65 + _letra)),
                SgButton(
                  label: Text(context.tx('Próxima letra')),
                  onClick: () => setState(() => _letra = (_letra + 1) % 26),
                ),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitLetrasAz,
      ),
      ShowcaseExample(
        title: 'Variações de tamanho',
        description: 'Ajuste de fontSize (a largura e a altura seguem dele).',
        preview:
            // #region sg-flip-digit-variacoes
            Wrap(
              spacing: 24,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Column(
                  children: [
                    Text(context.tx('Pequeno')),
                    const SgFlipDigit(value: '5', fontSize: 45),
                  ],
                ),
                Column(
                  children: [
                    Text(context.tx('Médio')),
                    const SgFlipDigit(value: '5'),
                  ],
                ),
                Column(
                  children: [
                    Text(context.tx('Grande')),
                    const SgFlipDigit(value: '5', fontSize: 120),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitVariacoes,
      ),
      ShowcaseExample(
        title: 'Sequência estilo relógio',
        description: 'Dígitos lado a lado com separador.',
        preview:
            // #region sg-flip-digit-sequencia
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgFlipDigit(value: '2'),
                SgFlipDigit(value: '3'),
                Text(
                  ':',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                SgFlipDigit(value: '4'),
                SgFlipDigit(value: '5'),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitSequencia,
      ),
      ShowcaseExample(
        title: 'Incremento automático',
        description: 'Troca automática a cada 1,3 s.',
        preview:
            // #region sg-flip-digit-auto
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgFlipDigit(value: '$_auto'),
                SgButton(
                  label: Text(context.tx(_rodando ? 'Parar' : 'Iniciar')),
                  onClick: _alternar,
                ),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitAuto,
      ),
      // Exemplos só do Flutter (depois dos que espelham o React).
      ShowcaseExample(
        title: 'Contador',
        description:
            'Cada troca de valor vira uma carta que gira em 800 ms com ease-out-bounce (o padrão do @pqina/flip).',
        preview:
            // #region sg-flip-digit-contador
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgFlipDigit(value: '${_n % 10}', fontSize: 56),
                SgButton(
                  label: const Text('+1'),
                  onClick: () => setState(() => _n++),
                ),
                SgButton(
                  label: Text(context.tx('Zerar')),
                  appearance: SgAppearance.outline,
                  onClick: () => setState(() => _n = 0),
                ),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitContador,
      ),
      ShowcaseExample(
        title: 'Tamanhos',
        description:
            'fontSize controla a escala do conjunto: as medidas vêm de múltiplos dele.',
        preview:
            // #region sg-flip-digit-tamanhos
            Wrap(
              spacing: 24,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                SgFlipDigit(value: '${_n % 10}', fontSize: 28),
                SgFlipDigit(value: '${_n % 10}', fontSize: 48),
                SgFlipDigit(value: '${_n % 10}', fontSize: 72),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitTamanhos,
      ),
      ShowcaseExample(
        title: 'Vários dígitos',
        description:
            'Um dígito por caractere, como num relógio de cartas. Só gira quem mudou.',
        preview:
            // #region sg-flip-digit-varios
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final ch in _clock.toString().padLeft(4, '0').split(''))
                  SgFlipDigit(value: ch, fontSize: 44),
                SgButton(
                  label: Text(context.tx('Somar 111')),
                  size: SgSize.sm,
                  onClick: () =>
                      setState(() => _clock = (_clock + 111) % 10000),
                ),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitVarios,
      ),
    ];

    return SgShowcasePage(
      name: 'SgFlipDigit',
      description:
          'Cartão que vira como num relógio de aeroporto: um caractere, animado por uma carta com perspectiva 3D.',
      examples: examples,
      propSpecs: sgPropSpecs['SgFlipDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgFlipDigit']!
            .where((s) => const {'value'}.contains(s.name))
            .toList(),
        builder: (context, v) =>
            SgFlipDigit(value: (v['value'] as String?) ?? '0', fontSize: 56),
        codeBuilder: (v) =>
            "SgFlipDigit(\n  value: '${v['value'] ?? '0'}',\n  fontSize: 56,\n)",
      ),
    );
  }
}
