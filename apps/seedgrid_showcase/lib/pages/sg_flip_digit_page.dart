// Showcase do SgFlipDigit. O codigo exibido em cada exemplo e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_flip_digit_page.snippets.g.dart';

class SgFlipDigitPage extends StatefulWidget {
  const SgFlipDigitPage({super.key});

  @override
  State<SgFlipDigitPage> createState() => _SgFlipDigitPageState();
}

class _SgFlipDigitPageState extends State<SgFlipDigitPage> {
  int _n = 0;
  String _letter = 'A';
  int _clock = 1234;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
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
                  label: const Text('Zerar'),
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
                  label: const Text('Somar 111'),
                  size: SgSize.sm,
                  onClick: () =>
                      setState(() => _clock = (_clock + 111) % 10000),
                ),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitVarios,
      ),
      ShowcaseExample(
        title: 'Letras',
        description: 'O valor é qualquer caractere, não só número.',
        preview:
            // #region sg-flip-digit-letras
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgFlipDigit(value: _letter, fontSize: 56),
                SgButton(
                  label: const Text('Próxima letra'),
                  onClick: () => setState(
                    () => _letter = String.fromCharCode(
                      65 + (_letter.codeUnitAt(0) - 64) % 26,
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgFlipDigitPageSnippets.sgFlipDigitLetras,
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
