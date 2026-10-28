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
  num _volume = 30;
  num _passo = 50;
  final SgFormController _form = SgFormController(
    defaultValues: {'brilho': 40},
  );
  String _enviado = '';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'minValue, maxValue e defaultValue; onChange entrega o número a cada mudança.',
        preview:
            // #region sg-slider-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgSlider(
                  id: 'volume',
                  minValue: 0,
                  maxValue: 100,
                  defaultValue: 30,
                  ariaLabel: 'Volume',
                  onChange: (v) => setState(() => _volume = v),
                ),
                Text('Volume: $_volume'),
              ],
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderBasico,
      ),
      ShowcaseExample(
        title: 'Passo (step)',
        description:
            'O valor só assume múltiplos do passo, a partir de minValue.',
        preview:
            // #region sg-slider-passo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgSlider(
                  id: 'passo',
                  minValue: 0,
                  maxValue: 100,
                  step: 25,
                  defaultValue: 50,
                  onChange: (v) => setState(() => _passo = v),
                ),
                Text('Valor: $_passo'),
              ],
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderPasso,
      ),
      ShowcaseExample(
        title: 'Largura, desabilitado e erro',
        preview:
            // #region sg-slider-estados
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgSlider(
                  id: 'largura',
                  minValue: 0,
                  maxValue: 10,
                  defaultValue: 4,
                  width: '50%',
                ),
                SgSlider(
                  id: 'off',
                  minValue: 0,
                  maxValue: 10,
                  defaultValue: 7,
                  disabled: true,
                ),
                SgSlider(
                  id: 'erro',
                  minValue: 0,
                  maxValue: 10,
                  defaultValue: 9,
                  error: 'Valor alto demais',
                ),
              ],
            ),
        // #endregion
        code: SgSliderPageSnippets.sgSliderEstados,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'name + control; rules.min valida o valor no envio.',
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
                  rules: const SgRules(
                    min: SgRuleValue(20, 'Brilho mínimo: 20'),
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) =>
                        setState(() => _enviado = '${values['brilho']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
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
              (s) => const {'disabled', 'error', 'ariaLabel'}.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgSlider(
          id: 'pg',
          minValue: 0,
          maxValue: 100,
          defaultValue: 40,
          disabled: (v['disabled'] as bool?) ?? false,
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
