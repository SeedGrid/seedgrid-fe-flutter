// Showcase do SgRoller3DDigit. O codigo exibido em cada exemplo e a regiao `// #region` deste arquivo.
import 'dart:async';

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
  int _nome = 0;
  int _passo = 7;
  Timer? _timer;
  static const _nomes = ['LUCIANO', 'MARTA'];
  static final _alfabeto = [
    ' ',
    ...List.generate(26, (i) => String.fromCharCode(65 + i)),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<String> _letrasDoNome() {
    final atual = _nomes[_nome];
    final anterior = _nomes[(_nome - 1 + _nomes.length) % _nomes.length];
    final tamanho = atual.length > anterior.length
        ? atual.length
        : anterior.length;
    final a = anterior.padRight(tamanho);
    final b = atual.padRight(tamanho);
    return [for (var i = 0; i < tamanho; i++) i <= _passo ? b[i] : a[i]];
  }

  void _animarNome() {
    _timer?.cancel();
    final atual = _nomes[_nome];
    final proximo = _nomes[(_nome + 1) % _nomes.length];
    final maximo = atual.length > proximo.length
        ? atual.length
        : proximo.length;
    setState(() {
      _nome = (_nome + 1) % _nomes.length;
      _passo = 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 120), (t) {
      if (!mounted) return;
      setState(() => _passo++);
      if (_passo >= maximo) t.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (0-9)',
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
        title: 'Valor com 2 dígitos',
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
        title: 'Letras (A-Z)',
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
        title: 'Animação de nomes',
        description:
            'Composição de vários SgRoller3DDigit para animar texto - exemplo: "LUCIANO" -> "MARTA".',
        preview:
            // #region sg-roller3d-digit-nomes
            Wrap(
              spacing: 8,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final letra in _letrasDoNome())
                  SgRoller3DDigit(
                    value: letra,
                    items: _alfabeto,
                    fontSize: 28,
                    transitionMs: 110,
                  ),
                SgButton(
                  label: Text(context.tx('Animar nome')),
                  size: SgSize.sm,
                  onClick: _animarNome,
                ),
              ],
            ),
        // #endregion
        code: SgRoller3dDigitPageSnippets.sgRoller3dDigitNomes,
      ),
      ShowcaseExample(
        title: 'Variações de tamanho',
        description: 'Ajuste de escala via prop fontSize.',
        preview:
            // #region sg-roller3d-digit-tamanhos
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                for (final tamanho in const [16, 32, 56])
                  Column(
                    children: [
                      Text('${tamanho}px'),
                      SgRoller3DDigit(value: '5', fontSize: tamanho.toDouble()),
                    ],
                  ),
              ],
            ),
        // #endregion
        code: SgRoller3dDigitPageSnippets.sgRoller3dDigitTamanhos,
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
