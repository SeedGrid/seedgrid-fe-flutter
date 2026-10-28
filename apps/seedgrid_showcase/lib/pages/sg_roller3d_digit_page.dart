// Showcase do SgRoller3DDigit. O codigo exibido em cada exemplo e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_roller3d_digit_page.snippets.g.dart';

class SgRoller3DDigitPage extends StatefulWidget {
  const SgRoller3DDigitPage({super.key});

  @override
  State<SgRoller3DDigitPage> createState() => _SgRoller3DDigitPageState();
}

class _SgRoller3DDigitPageState extends State<SgRoller3DDigitPage> {
  int _digit = 0;
  int _minute = 42;
  int _letter = 12;
  bool _slow = false;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Dígitos de 0 a 9',
        description:
            'O tambor desliza até a posição de value em 500 ms com cubic-bezier(0.22, 1, 0.36, 1).',
        preview:
            // #region sg-roller3d-digit-digitos
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgRoller3DDigit(value: '$_digit', fontSize: 32),
                SgButton(
                  label: Text(context.tx('Próximo')),
                  onClick: () => setState(() => _digit = (_digit + 1) % 10),
                ),
                SgButton(
                  label: Text(context.tx('Aleatório')),
                  appearance: SgAppearance.outline,
                  onClick: () => setState(() => _digit = (_digit * 7 + 3) % 10),
                ),
              ],
            ),
        // #endregion
        code: SgRoller3dDigitPageSnippets.sgRoller3dDigitDigitos,
      ),
      ShowcaseExample(
        title: 'Minutos (00 a 59)',
        description:
            'items define os valores; a largura cresce com o maior deles.',
        preview:
            // #region sg-roller3d-digit-minutos
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgRoller3DDigit(
                  value: _minute.toString().padLeft(2, '0'),
                  items: List.generate(60, (i) => i.toString().padLeft(2, '0')),
                  fontSize: 22,
                ),
                SgButton(
                  label: Text(context.tx('+7 minutos')),
                  onClick: () => setState(() => _minute = (_minute + 7) % 60),
                ),
              ],
            ),
        // #endregion
        code: SgRoller3dDigitPageSnippets.sgRoller3dDigitMinutos,
      ),
      ShowcaseExample(
        title: 'Letras (A a Z)',
        preview:
            // #region sg-roller3d-digit-letras
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgRoller3DDigit(
                  value: String.fromCharCode(65 + _letter),
                  items: List.generate(26, (i) => String.fromCharCode(65 + i)),
                  fontSize: 32,
                ),
                SgButton(
                  label: Text(context.tx('Próxima letra')),
                  onClick: () => setState(() => _letter = (_letter + 5) % 26),
                ),
              ],
            ),
        // #endregion
        code: SgRoller3dDigitPageSnippets.sgRoller3dDigitLetras,
      ),
      ShowcaseExample(
        title: 'Duração da transição',
        description: 'transitionMs: 150 ms contra 1500 ms, lado a lado.',
        preview:
            // #region sg-roller3d-digit-duracao
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgRoller3DDigit(
                  value: _slow ? '9' : '0',
                  transitionMs: 150,
                  fontSize: 28,
                ),
                SgRoller3DDigit(
                  value: _slow ? '9' : '0',
                  transitionMs: 1500,
                  fontSize: 28,
                ),
                SgButton(
                  label: Text(context.tx('Alternar 0 e 9')),
                  onClick: () => setState(() => _slow = !_slow),
                ),
              ],
            ),
        // #endregion
        code: SgRoller3dDigitPageSnippets.sgRoller3dDigitDuracao,
      ),
    ];

    return SgShowcasePage(
      name: 'SgRoller3DDigit',
      description:
          'Tambor vertical que desliza entre valores (dígitos, números com zero à esquerda, letras ou textos quaisquer).',
      examples: examples,
      propSpecs: sgPropSpecs['SgRoller3DDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgRoller3DDigit']!
            .where((s) => const {'value'}.contains(s.name))
            .toList(),
        builder: (context, v) =>
            SgRoller3DDigit(value: (v['value'] as String?) ?? '0'),
        codeBuilder: (v) =>
            "SgRoller3DDigit(\n  value: '${v['value'] ?? '0'}',\n)",
      ),
    );
  }
}
