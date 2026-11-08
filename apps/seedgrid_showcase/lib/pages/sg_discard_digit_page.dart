// Showcase do SgDiscardDigit. O codigo exibido em cada exemplo e a regiao `// #region` deste arquivo.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_discard_digit_page.snippets.g.dart';

class SgDiscardDigitPage extends StatefulWidget {
  const SgDiscardDigitPage({super.key});

  @override
  State<SgDiscardDigitPage> createState() => _SgDiscardDigitPageState();
}

class _SgDiscardDigitPageState extends State<SgDiscardDigitPage> {
  final ValueNotifier<int> _n = ValueNotifier(1);
  final SgDiscardDigitController _pages = SgDiscardDigitController();
  final ValueNotifier<int> _page = ValueNotifier(1);
  final ValueNotifier<int> _pilha = ValueNotifier(8);
  final ValueNotifier<int> _folha = ValueNotifier(0);
  final ValueNotifier<bool> _rodando = ValueNotifier(false);
  final ValueNotifier<int> _contador = ValueNotifier(0);
  Timer? _timer;
  final SgDiscardDigitController _ref = SgDiscardDigitController();
  final ValueNotifier<int> _paginaAtual = ValueNotifier(1);

  @override
  void dispose() {
    _timer?.cancel();
    for (final n in [_n, _page, _pilha, _folha, _contador, _paginaAtual]) {
      n.dispose();
    }
    _rodando.dispose();
    super.dispose();
  }

  void _alternarAutomatico() {
    _rodando.value = !_rodando.value;
    _timer?.cancel();
    if (_rodando.value) {
      _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
        if (mounted) _contador.value = (_contador.value + 1) % 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const sans = '"Inter", "Segoe UI", sans-serif';
    const serif = '"Merriweather", "Times New Roman", serif';
    const folhas = ['001', '002', '003', '004', '005'];
    const totalPaginas = 10;
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Clique em Próximo para adicionar uma folha e em Anterior para remover uma.',
        preview:
            // #region sg-discard-digit-basico
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _pilha,
                  builder: (context, pilha, _) => SgDiscardDigit(
                    value: '7',
                    color: '#0f172a',
                    font: sans,
                    backgroundColor: '#f8fafc',
                    stackDepth: pilha,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgButton(
                      label: Text(context.tx('Próximo (+1 folha)')),
                      onClick: () => _pilha.value = _pilha.value < 30
                          ? _pilha.value + 1
                          : 30,
                    ),
                    const SizedBox(height: 8),
                    SgButton(
                      label: Text(context.tx('Anterior (-1 folha)')),
                      appearance: SgAppearance.outline,
                      onClick: () => _pilha.value = _pilha.value > 2
                          ? _pilha.value - 1
                          : 2,
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitBasico,
      ),
      ShowcaseExample(
        title: 'Folhas sequenciais',
        description: 'Cada clique descarta uma folha e revela a seguinte.',
        preview:
            // #region sg-discard-digit-folhas-sequenciais
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _folha,
                  builder: (context, folha, _) => SgDiscardDigit(
                    value: folhas[folha],
                    color: '#111827',
                    font: sans,
                    backgroundColor: '#fffef7',
                    fontSize: 58,
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Descartar folha')),
                  size: SgSize.sm,
                  onClick: () =>
                      _folha.value = (_folha.value + 1) % folhas.length,
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitFolhasSequenciais,
      ),
      ShowcaseExample(
        title: 'Variações de papel',
        description:
            'Exemplos com cores diferentes em color e backgroundColor.',
        preview:
            // #region sg-discard-digit-variacoes-de-papel
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Papel branco')),
                    const SgDiscardDigit(
                      value: '7',
                      color: '#0f172a',
                      font: sans,
                      backgroundColor: '#f8fafc',
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Papel âmbar')),
                    const SgDiscardDigit(
                      value: '7',
                      color: '#4a2d13',
                      font: sans,
                      backgroundColor: '#fff4d6',
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Papel azul frio')),
                    const SgDiscardDigit(
                      value: '7',
                      color: '#0b2f50',
                      font: sans,
                      backgroundColor: '#e7f5ff',
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitVariacoesDePapel,
      ),
      ShowcaseExample(
        title: 'Fontes',
        description: 'Comparação de fontes no mesmo efeito de pilha.',
        preview:
            // #region sg-discard-digit-fontes
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Sans')),
                    const SgDiscardDigit(
                      value: '42',
                      color: '#0f172a',
                      font: sans,
                      backgroundColor: '#f8fafc',
                      fontSize: 60,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tx('Serif')),
                    const SgDiscardDigit(
                      value: '42',
                      color: '#1f2937',
                      font: serif,
                      backgroundColor: '#fffef7',
                      fontSize: 60,
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitFontes,
      ),
      ShowcaseExample(
        title: 'Descarte automático',
        description:
            'Atualização contínua para observar a direção aleatória da folha descartada.',
        preview:
            // #region sg-discard-digit-auto-descarte
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _contador,
                  builder: (context, contador, _) => SgDiscardDigit(
                    value: contador.toString().padLeft(2, '0'),
                    color: '#0f172a',
                    font: sans,
                    backgroundColor: '#f8fafc',
                    fontSize: 62,
                    transitionMs: 700,
                    stackDepth: 15,
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<bool>(
                  valueListenable: _rodando,
                  builder: (context, rodando, _) => SgButton(
                    label: Text(context.tx(rodando ? 'Parar' : 'Iniciar')),
                    size: SgSize.sm,
                    onClick: _alternarAutomatico,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitAutoDescarte,
      ),
      ShowcaseExample(
        title: 'Paginação imperativa (ref)',
        description:
            'totalNumberPages define o total de folhas. O controller expõe increasePage(), decreasePage() e page().',
        preview:
            // #region sg-discard-digit-paginacao-ref
            Wrap(
              spacing: 32,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _paginaAtual,
                  builder: (context, paginaAtual, _) => SgDiscardDigit(
                    value: '$paginaAtual',
                    controller: _ref,
                    totalNumberPages: totalPaginas,
                    fontSize: 64,
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _paginaAtual,
                  builder: (context, paginaAtual, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.tx('Página')} $paginaAtual ${context.tx('de')} $totalPaginas',
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          SgButton(
                            label: Text(context.tx('Anterior')),
                            size: SgSize.sm,
                            enabled: paginaAtual > 1,
                            onClick: () {
                              _ref.decreasePage();
                              _paginaAtual.value = _ref.page();
                            },
                          ),
                          SgButton(
                            label: Text(context.tx('Próxima')),
                            size: SgSize.sm,
                            enabled: paginaAtual < totalPaginas,
                            onClick: () {
                              _ref.increasePage();
                              _paginaAtual.value = _ref.page();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitPaginacaoRef,
      ),
      ShowcaseExample(
        title: 'Descarte (padrão)',
        description:
            'A folha de cima voa para fora em 640 ms e o valor novo aparece embaixo. O movimento é sorteado a cada troca.',
        preview:
            // #region sg-discard-digit-descarte
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _n,
                  builder: (context, n, _) => SgDiscardDigit(value: '$n'),
                ),
                SgButton(
                  label: Text(context.tx('Próximo')),
                  onClick: () => _n.value = _n.value % 9 + 1,
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitDescarte,
      ),
      ShowcaseExample(
        title: 'Entrando por baixo',
        description:
            'changeAnimationMode: incoming — a folha nova sobe por baixo e o topo só muda no fim.',
        preview:
            // #region sg-discard-digit-entrando
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _n,
                  builder: (context, n, _) => SgDiscardDigit(
                    value: '$n',
                    changeAnimationMode:
                        SgDiscardDigitChangeAnimationMode.incoming,
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Próximo')),
                  onClick: () => _n.value = _n.value % 9 + 1,
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitEntrando,
      ),
      ShowcaseExample(
        title: 'Páginas de um monte',
        description:
            'totalNumberPages faz a pilha encolher a cada increasePage(); decreasePage() traz a folha de volta por baixo.',
        preview:
            // #region sg-discard-digit-paginas
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _page,
                  builder: (context, page, _) => SgDiscardDigit(
                    value: '$page',
                    controller: _pages,
                    totalNumberPages: 8,
                    stackDepth: 8,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: _page,
                      builder: (context, page, _) => Text('Página $page de 8'),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SgButton(
                          label: Text(context.tx('Anterior')),
                          appearance: SgAppearance.outline,
                          onClick: () {
                            _pages.decreasePage();
                            _page.value = _pages.page();
                          },
                        ),
                        SgButton(
                          label: Text(context.tx('Próxima')),
                          onClick: () {
                            _pages.increasePage();
                            _page.value = _pages.page();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitPaginas,
      ),
      ShowcaseExample(
        title: 'Sem animação',
        description: 'animateOnChange: false troca o valor na hora.',
        preview:
            // #region sg-discard-digit-sem-animacao
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _n,
                  builder: (context, n, _) =>
                      SgDiscardDigit(value: '$n', animateOnChange: false),
                ),
                SgButton(
                  label: Text(context.tx('Próximo')),
                  onClick: () => _n.value = _n.value % 9 + 1,
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitSemAnimacao,
      ),
      ShowcaseExample(
        title: 'Aparência',
        description:
            'Cores em texto CSS, peso da fonte, tamanho e duração da transição.',
        preview:
            // #region sg-discard-digit-aparencia
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _n,
                  builder: (context, n, _) => SgDiscardDigit(
                    value: '$n',
                    fontSize: 48,
                    color: '#7c2d12',
                    backgroundColor: '#ffedd5',
                    fontWeight: 'bold',
                    transitionMs: 900,
                    stackDepth: 10,
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Próximo')),
                  onClick: () => _n.value = _n.value % 9 + 1,
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitAparencia,
      ),
    ];

    return SgShowcasePage(
      name: 'SgDiscardDigit',
      description:
          'Pilha de folhas de papel: a de cima é descartada (ou uma nova sobe por baixo) quando o valor muda.',
      examples: examples,
      propSpecs: sgPropSpecs['SgDiscardDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgDiscardDigit']!
            .where(
              (s) => const {
                'value',
                'changeAnimationMode',
                'color',
                'backgroundColor',
                'font',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgDiscardDigit(
          value: (v['value'] as String?) ?? '7',
          changeAnimationMode:
              SgDiscardDigitChangeAnimationMode.fromValue(
                v['changeAnimationMode'] as String?,
              ) ??
              SgDiscardDigitChangeAnimationMode.discard,
          color: (v['color'] as String?) ?? '#0f172a',
          backgroundColor: (v['backgroundColor'] as String?) ?? '#f8fafc',
          font: v['font'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["value: '${v['value'] ?? '7'}'"];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add(switch (e.key) {
              'changeAnimationMode' =>
                'changeAnimationMode: SgDiscardDigitChangeAnimationMode.${SgDiscardDigitChangeAnimationMode.fromValue(e.value as String)!.name}',
              _ => "${e.key}: '${e.value}'",
            });
          }
          return 'SgDiscardDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
