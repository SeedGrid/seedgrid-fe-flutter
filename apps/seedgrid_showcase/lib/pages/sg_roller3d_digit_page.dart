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
  final ValueNotifier<int> _digit = ValueNotifier(0);
  final ValueNotifier<int> _minute = ValueNotifier(42);
  final ValueNotifier<int> _letter = ValueNotifier(12);
  final ValueNotifier<bool> _slow = ValueNotifier(false);
  final ValueNotifier<int> _nome = ValueNotifier(0);
  final ValueNotifier<int> _passo = ValueNotifier(7);
  Timer? _timer;
  static const _nomes = ['LUCIANO', 'MARTA'];
  static final _alfabeto = [
    ' ',
    ...List.generate(26, (i) => String.fromCharCode(65 + i)),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    for (final n in [_digit, _minute, _letter, _nome, _passo]) {
      n.dispose();
    }
    _slow.dispose();
    super.dispose();
  }

  List<String> _letrasDoNome() {
    final atual = _nomes[_nome.value];
    final anterior = _nomes[(_nome.value - 1 + _nomes.length) % _nomes.length];
    final tamanho = atual.length > anterior.length
        ? atual.length
        : anterior.length;
    final a = anterior.padRight(tamanho);
    final b = atual.padRight(tamanho);
    return [for (var i = 0; i < tamanho; i++) i <= _passo.value ? b[i] : a[i]];
  }

  void _animarNome() {
    _timer?.cancel();
    final atual = _nomes[_nome.value];
    final proximo = _nomes[(_nome.value + 1) % _nomes.length];
    final maximo = atual.length > proximo.length
        ? atual.length
        : proximo.length;
    _nome.value = (_nome.value + 1) % _nomes.length;
    _passo.value = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 120), (t) {
      if (!mounted) return;
      _passo.value++;
      if (_passo.value >= maximo) t.cancel();
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
                ValueListenableBuilder<int>(
                  valueListenable: _digit,
                  builder: (context, digit, _) =>
                      SgRoller3DDigit(value: '$digit', fontSize: 32),
                ),
                SgButton(
                  label: Text(context.tx('Próximo')),
                  onClick: () => _digit.value = (_digit.value + 1) % 10,
                ),
                SgButton(
                  label: Text(context.tx('Aleatório')),
                  appearance: SgAppearance.outline,
                  onClick: () => _digit.value = (_digit.value * 7 + 3) % 10,
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
                ValueListenableBuilder<int>(
                  valueListenable: _minute,
                  builder: (context, minute, _) => SgRoller3DDigit(
                    value: minute.toString().padLeft(2, '0'),
                    items: List.generate(
                      60,
                      (i) => i.toString().padLeft(2, '0'),
                    ),
                    fontSize: 22,
                  ),
                ),
                SgButton(
                  label: Text(context.tx('+7 minutos')),
                  onClick: () => _minute.value = (_minute.value + 7) % 60,
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
                ValueListenableBuilder<int>(
                  valueListenable: _letter,
                  builder: (context, letter, _) => SgRoller3DDigit(
                    value: String.fromCharCode(65 + letter),
                    items: List.generate(
                      26,
                      (i) => String.fromCharCode(65 + i),
                    ),
                    fontSize: 32,
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Próxima letra')),
                  onClick: () => _letter.value = (_letter.value + 5) % 26,
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
            ListenableBuilder(
              listenable: Listenable.merge([_nome, _passo]),
              builder: (context, _) => Wrap(
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
            ValueListenableBuilder<bool>(
              valueListenable: _slow,
              builder: (context, slow, _) => Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SgRoller3DDigit(
                    value: slow ? '9' : '0',
                    transitionMs: 150,
                    fontSize: 28,
                  ),
                  SgRoller3DDigit(
                    value: slow ? '9' : '0',
                    transitionMs: 1500,
                    fontSize: 28,
                  ),
                  SgButton(
                    label: Text(context.tx('Alternar 0 e 9')),
                    onClick: () => _slow.value = !slow,
                  ),
                ],
              ),
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
