// Showcase do SgSlider. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_slider_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgSliderPage extends StatefulWidget {
  const SgSliderPage({super.key});

  @override
  State<SgSliderPage> createState() => _SgSliderPageState();
}

class _SgSliderPageState extends State<SgSliderPage> {
  final ValueNotifier<num> _basico = ValueNotifier<num>(50);
  final ValueNotifier<num> _controlado = ValueNotifier<num>(35);
  final ValueNotifier<num> _passo = ValueNotifier<num>(25);
  final SgFormController _form = SgFormController(
    defaultValues: {'brilho': 40},
  );
  final ValueNotifier<String> _enviado = ValueNotifier<String>('');

  @override
  void dispose() {
    _form.dispose();
    _basico.dispose();
    _controlado.dispose();
    _passo.dispose();
    _enviado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Define minValue e maxValue com um valor inicial via defaultValue.',
        preview:
            // #region sg-slider-basico
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 384),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgSlider(
                    id: 'slider-basic',
                    minValue: 0,
                    maxValue: 100,
                    defaultValue: 50,
                    onChange: (v) => _basico.value = v,
                  ),
                  ValueListenableBuilder<num>(
                    valueListenable: _basico,
                    builder: (context, valor, _) =>
                        Text('${context.tx('Valor atual')}: $valor'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderBasico,
      ),
      ShowcaseExample(
        title: 'Controle externo',
        description: 'O valor pode ser definido externamente pela prop value.',
        preview:
            // #region sg-slider-controle-externo
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 384),
              child: ValueListenableBuilder<num>(
                valueListenable: _controlado,
                builder: (context, valor, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgSlider(
                      id: 'slider-controlled',
                      minValue: 0,
                      maxValue: 100,
                      value: valor,
                      onChange: (v) => _controlado.value = v,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SgButton(
                          size: SgSize.sm,
                          appearance: SgAppearance.outline,
                          label: Text(context.tx('Mín')),
                          onClick: () => _controlado.value = 0,
                        ),
                        SgButton(
                          size: SgSize.sm,
                          appearance: SgAppearance.outline,
                          label: Text(context.tx('Meio')),
                          onClick: () => _controlado.value = 50,
                        ),
                        SgButton(
                          size: SgSize.sm,
                          appearance: SgAppearance.outline,
                          label: Text(context.tx('Máx')),
                          onClick: () => _controlado.value = 100,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${context.tx('Valor controlado')}: $valor'),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderControleExterno,
      ),
      ShowcaseExample(
        title: 'Passo e largura',
        description: 'Mostra step com width numérica e width em string CSS.',
        preview:
            // #region sg-slider-passo-largura
            ValueListenableBuilder<num>(
              valueListenable: _passo,
              builder: (context, valor, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgSlider(
                    id: 'slider-step-width-number',
                    minValue: 0,
                    maxValue: 60,
                    step: 5,
                    width: 320,
                    value: valor,
                    onChange: (v) => _passo.value = v,
                  ),
                  const SgSlider(
                    id: 'slider-step-width-string',
                    minValue: -20,
                    maxValue: 20,
                    step: 2,
                    width: '18rem',
                    defaultValue: 4,
                  ),
                  Text('${context.tx('Valor com step 5')}: $valor'),
                ],
              ),
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderPassoLargura,
      ),
      ShowcaseExample(
        title: 'ariaLabel e desabilitado',
        description: 'Mostra acessibilidade (ariaLabel) e estado desabilitado.',
        preview:
            // #region sg-slider-aria-desabilitado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgSlider(
                  id: 'slider-aria',
                  minValue: 0,
                  maxValue: 100,
                  defaultValue: 40,
                  width: '20rem',
                  ariaLabel: context.tx('Nível de prioridade'),
                ),
                SgSlider(
                  id: 'slider-disabled',
                  minValue: 0,
                  maxValue: 100,
                  defaultValue: 65,
                  enabled: false,
                  width: '20rem',
                  ariaLabel: context.tx('Slider desabilitado'),
                ),
              ],
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderAriaDesabilitado,
      ),
      ShowcaseExample(
        title: 'Mensagem de erro',
        description:
            'O texto de error aparece abaixo do slider e marca o campo como inválido.',
        preview:
            // #region sg-slider-erro
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 384),
              child: SgSlider(
                id: 'slider-error',
                minValue: 0,
                maxValue: 10,
                defaultValue: 9,
                error: context.tx('Valor alto demais'),
              ),
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderErro,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'name + control: o formulário guarda o valor escolhido.',
        preview:
            // #region sg-slider-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgSlider(
                  id: 'brilho',
                  name: 'brilho',
                  control: _form,
                  minValue: 0,
                  maxValue: 100,
                  step: 10,
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => _enviado.value = '${values['brilho']}',
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, enviado, _) => enviado.isEmpty
                      ? const SizedBox()
                      : Text(context.txf('Enviado: {valor}', {'valor': enviado})),
                ),
              ],
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgSlider',
      description:
          'Controle deslizante numérico com faixa, passo, largura e ligação a formulário.',
      examples: examples,
      propSpecs: sgPropSpecs['SgSlider']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgSlider']!
            .where(
              (s) => const {'enabled', 'error', 'ariaLabel'}.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgSlider(
          id: 'pg',
          minValue: 0,
          maxValue: 100,
          defaultValue: 40,
          enabled: (v['enabled'] as bool?) ?? true,
          error: v['error'] as String?,
          ariaLabel: v['ariaLabel'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            'minValue: 0',
            'maxValue: 100',
            'defaultValue: 40',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgSlider(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
