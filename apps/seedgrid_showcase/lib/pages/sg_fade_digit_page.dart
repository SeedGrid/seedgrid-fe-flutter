// Showcase do SgFadeDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_fade_digit_page.snippets.g.dart';

class SgFadeDigitPage extends StatefulWidget {
  const SgFadeDigitPage({super.key});

  @override
  State<SgFadeDigitPage> createState() => _SgFadeDigitPageState();
}

class _SgFadeDigitPageState extends State<SgFadeDigitPage> {
  final ValueNotifier<int> _digito = ValueNotifier(0);
  final ValueNotifier<int> _letra = ValueNotifier(0); // 0 = A
  final ValueNotifier<bool> _rodando = ValueNotifier(false);
  final ValueNotifier<int> _contador = ValueNotifier(0);
  final ValueNotifier<bool> _relogioRodando = ValueNotifier(false);
  final ValueNotifier<int> _segundos = ValueNotifier(0);
  Timer? _timerContador;
  Timer? _timerRelogio;

  @override
  void dispose() {
    _timerContador?.cancel();
    _timerRelogio?.cancel();
    for (final n in [_digito, _letra, _contador, _segundos]) {
      n.dispose();
    }
    _rodando.dispose();
    _relogioRodando.dispose();
    super.dispose();
  }

  void _alternarContador() {
    _rodando.value = !_rodando.value;
    _timerContador?.cancel();
    if (_rodando.value) {
      _timerContador = Timer.periodic(const Duration(milliseconds: 800), (_) {
        if (mounted) _contador.value = (_contador.value + 1) % 10;
      });
    }
  }

  void _alternarRelogio() {
    _relogioRodando.value = !_relogioRodando.value;
    _timerRelogio?.cancel();
    if (_relogioRodando.value) {
      _timerRelogio = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) _segundos.value = (_segundos.value + 1) % 86400;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (0-9)',
        description: 'Troca manual entre dígitos numéricos.',
        preview:
            // #region sg-fade-digit-basico
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _digito,
                  builder: (context, digito, _) =>
                      SgFadeDigit(value: '$digito'),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Próximo (+1)')),
                      onClick: () => _digito.value = (_digito.value + 1) % 10,
                    ),
                    SgButton(
                      label: Text(context.tx('Anterior (-1)')),
                      onClick: () => _digito.value = (_digito.value + 9) % 10,
                    ),
                    SgButton(
                      label: Text(context.tx('Aleatório')),
                      onClick: () => _digito.value =
                          (_digito.value + 1 + Random().nextInt(9)) % 10,
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitBasico,
      ),
      ShowcaseExample(
        title: 'Letras (A-Z)',
        description: 'Aceita qualquer caractere - letras, símbolos, espaços.',
        preview:
            // #region sg-fade-digit-letras
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _letra,
                  builder: (context, letra, _) =>
                      SgFadeDigit(value: String.fromCharCode(65 + letra)),
                ),
                SgButton(
                  label: Text(context.tx('Próxima letra')),
                  onClick: () => _letra.value = (_letra.value + 1) % 26,
                ),
              ],
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitLetras,
      ),
      ShowcaseExample(
        title: 'Cores personalizadas',
        description:
            'color e backgroundColor são totalmente livres - qualquer paleta funciona.',
        preview:
            // #region sg-fade-digit-personalizadas
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Column(
                  children: [
                    Text(context.tx('Padrão')),
                    const SgFadeDigit(
                      value: '7',
                      color: '#edebeb',
                      backgroundColor: '#333232',
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(context.tx('Verde')),
                    const SgFadeDigit(
                      value: '7',
                      color: '#4ade80',
                      backgroundColor: '#052e16',
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(context.tx('Azul')),
                    const SgFadeDigit(
                      value: '7',
                      color: '#60a5fa',
                      backgroundColor: '#0f172a',
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(context.tx('Rosa')),
                    const SgFadeDigit(
                      value: '7',
                      color: '#f472b6',
                      backgroundColor: '#2d0a1e',
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(context.tx('Âmbar')),
                    const SgFadeDigit(
                      value: '7',
                      color: '#fbbf24',
                      backgroundColor: '#1c1007',
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitPersonalizadas,
      ),
      ShowcaseExample(
        title: 'Incremento automático',
        description:
            'Incremento automático para validar transições contínuas e rápidas.',
        preview:
            // #region sg-fade-digit-auto
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _contador,
                  builder: (context, contador, _) =>
                      SgFadeDigit(value: '$contador'),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _rodando,
                  builder: (context, rodando, _) => SgButton(
                    label: Text(rodando ? context.tx('Parar') : context.tx('Iniciar')),
                    onClick: _alternarContador,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitAuto,
      ),
      ShowcaseExample(
        title: 'Sequência estilo relógio',
        description:
            'Composição de vários SgFadeDigit em linha - cada dígito atualiza de forma independente.',
        preview:
            // #region sg-fade-digit-relogio
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _segundos,
                  builder: (context, total, _) {
                    String dois(int n) => n.toString().padLeft(2, '0');
                    final horas = dois(total ~/ 3600);
                    final minutos = dois(total % 3600 ~/ 60);
                    final segundos = dois(total % 60);
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SgFadeDigit(value: horas[0]),
                        SgFadeDigit(value: horas[1]),
                        const Text(
                          ':',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SgFadeDigit(value: minutos[0]),
                        SgFadeDigit(value: minutos[1]),
                        const Text(
                          ':',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SgFadeDigit(value: segundos[0]),
                        SgFadeDigit(value: segundos[1]),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<bool>(
                  valueListenable: _relogioRodando,
                  builder: (context, rodando, _) => SgButton(
                    label: Text(rodando ? context.tx('Parar') : context.tx('Iniciar')),
                    size: SgSize.sm,
                    onClick: _alternarRelogio,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitRelogio,
      ),
      ShowcaseExample(
        title: 'Tamanhos',
        description:
            'Ajuste de escala via fontSize - largura e altura do cartão são proporcionais.',
        preview:
            // #region sg-fade-digit-tamanhos
            Wrap(
              spacing: 24,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Column(
                  children: [
                    Text(context.tx('Pequeno (40px)')),
                    const SgFadeDigit(value: '5', fontSize: 40),
                  ],
                ),
                Column(
                  children: [
                    Text(context.tx('Médio (70px)')),
                    const SgFadeDigit(value: '5', fontSize: 70),
                  ],
                ),
                Column(
                  children: [
                    Text(context.tx('Grande (110px)')),
                    const SgFadeDigit(value: '5', fontSize: 110),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitTamanhos,
      ),
      ShowcaseExample(
        title: 'Cartão com fade',
        description:
            'O cartão tem as mesmas proporções do SgFlipDigit: 88% x 138% do fontSize.',
        preview:
            // #region sg-fade-digit-cartao
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SgFadeDigit(value: '1'),
                SizedBox(width: 8),
                SgFadeDigit(value: '4'),
                SizedBox(width: 8),
                SgFadeDigit(value: '0'),
                SizedBox(width: 8),
                SgFadeDigit(value: '7'),
              ],
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitCartao,
      ),
      ShowcaseExample(
        title: 'Cores e tamanhos',
        description: 'color, backgroundColor, fontSize e font.',
        preview:
            // #region sg-fade-digit-cores
            const Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                SgFadeDigit(
                  value: '2',
                  color: '#111827',
                  backgroundColor: '#fde68a',
                ),
                SgFadeDigit(
                  value: '9',
                  fontSize: 40,
                  color: '#22c55e',
                  backgroundColor: '#052e16',
                ),
                SgFadeDigit(value: '0', fontSize: 100),
                SgFadeDigit(value: '1', fontSize: 24, font: 'monospace'),
              ],
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitCores,
      ),
      ShowcaseExample(
        title: 'Troca de valor',
        description:
            'O dígito atual apaga (200 ms), o novo entra invisível e acende (200 ms).',
        preview:
            // #region sg-fade-digit-troca
            Builder(
              builder: (context) {
                var value = 0;
                return StatefulBuilder(
                  builder: (context, set) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SgFadeDigit(value: '$value'),
                      const SizedBox(width: 24),
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
        code: SgFadeDigitPageSnippets.sgFadeDigitTroca,
      ),
    ];

    return SgShowcasePage(
      name: 'SgFadeDigit',
      description:
          'Cartão que apaga o dígito atual e acende o novo, como uma lâmpada ou display trocando de valor.',
      examples: examples,
      propSpecs: sgPropSpecs['SgFadeDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgFadeDigit']!
            .where(
              (s) => const {
                'value',
                'color',
                'backgroundColor',
                'font',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgFadeDigit(
          value: (v['value'] as String?) ?? '5',
          color: (v['color'] as String?) ?? '#edebeb',
          backgroundColor: (v['backgroundColor'] as String?) ?? '#333232',
          font: v['font'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["value: '${(v['value'] as String?) ?? '5'}'"];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add("${e.key}: '${e.value}'");
          }
          return 'SgFadeDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
