// Showcase do SgStepperInput. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_stepper_input_page.snippets.g.dart';

class SgStepperInputPage extends StatefulWidget {
  const SgStepperInputPage({super.key});

  @override
  State<SgStepperInputPage> createState() => _SgStepperInputPageState();
}

class _SgStepperInputPageState extends State<SgStepperInputPage> {
  final SgFormController _form = SgFormController();
  final ValueNotifier<num> _atual = ValueNotifier<num>(12);
  final ValueNotifier<num> _controlado = ValueNotifier<num>(18);
  final ValueNotifier<String> _enviado = ValueNotifier<String>('');

  @override
  void dispose() {
    _form.dispose();
    _atual.dispose();
    _controlado.dispose();
    _enviado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Ajuste por setas com minValue, maxValue e step.',
        preview:
            // #region sg-stepper-input-basico
            SgStack(
              gap: 8,
              align: SgStackAlign.start,
              children: [
                SgStepperInput(
                  id: 'stepper-basic',
                  minValue: 0,
                  maxValue: 40,
                  step: 2,
                  defaultValue: 12,
                  width: 210,
                  onChange: (v) => _atual.value = v,
                ),
                ValueListenableBuilder<num>(
                  valueListenable: _atual,
                  builder: (context, v, _) =>
                      Text('${context.tx('Valor atual')}: $v'),
                ),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputBasico,
      ),
      ShowcaseExample(
        title: 'Controle externo',
        description:
            'O valor é controlado pela prop value; os botões alteram o número de fora do campo.',
        preview:
            // #region sg-stepper-input-controle-externo
            SgStack(
              gap: 12,
              align: SgStackAlign.start,
              children: [
                ValueListenableBuilder<num>(
                  valueListenable: _controlado,
                  builder: (context, v, _) => SgStepperInput(
                    id: 'stepper-controlled',
                    minValue: 10,
                    maxValue: 30,
                    step: 1,
                    value: v,
                    width: 210,
                    onChange: (n) => _controlado.value = n,
                  ),
                ),
                SgStack(
                  direction: SgStackDirection.row,
                  wrap: true,
                  gap: 8,
                  children: [
                    for (final n in [10, 20, 30])
                      SgButton(
                        label: Text('$n'),
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        onClick: () => _controlado.value = n,
                      ),
                  ],
                ),
                ValueListenableBuilder<num>(
                  valueListenable: _controlado,
                  builder: (context, v, _) =>
                      Text('${context.tx('Valor controlado')}: $v'),
                ),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputControleExterno,
      ),
      ShowcaseExample(
        title: 'Somente leitura e desabilitado',
        description:
            'readOnly bloqueia a edição, enabled: false desabilita o campo e error mostra a mensagem de erro.',
        preview:
            // #region sg-stepper-input-somente-leitura
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 16,
              children: [
                const SgStepperInput(
                  id: 'stepper-readonly',
                  minValue: 0,
                  maxValue: 10,
                  value: 7,
                  readOnly: true,
                ),
                const SgStepperInput(
                  id: 'stepper-disabled',
                  minValue: 0,
                  maxValue: 10,
                  value: 4,
                  enabled: false,
                ),
                SgStepperInput(
                  id: 'stepper-error',
                  minValue: 0,
                  maxValue: 10,
                  error: context.tx('Escolha ao menos 1'),
                ),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputSomenteLeitura,
      ),
      ShowcaseExample(
        title: 'Passo e limites',
        description:
            'step define o incremento (aceita decimais); no limite o botão fica desabilitado.',
        preview:
            // #region sg-stepper-input-passo
            const SgStack(
              gap: 12,
              align: SgStackAlign.start,
              children: [
                SgStepperInput(
                  id: 'de-cinco',
                  minValue: 0,
                  maxValue: 50,
                  step: 5,
                  width: 160,
                ),
                SgStepperInput(
                  id: 'meio',
                  minValue: 0,
                  maxValue: 5,
                  step: 0.5,
                  defaultValue: 2.5,
                  width: 160,
                ),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputPasso,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'name + control: o formulário guarda um número.',
        preview:
            // #region sg-stepper-input-formulario
            SgStack(
              gap: 12,
              align: SgStackAlign.start,
              children: [
                SgStepperInput(
                  id: 'qtd',
                  name: 'qtd',
                  control: _form,
                  minValue: 0,
                  maxValue: 9,
                  width: 160,
                ),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => _enviado.value = '${values['qtd']}',
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, v, _) => v.isEmpty
                      ? const SizedBox.shrink()
                      : Text('${context.tx('Enviado')}: $v'),
                ),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputFormulario,
      ),
      ShowcaseExample(
        title: 'Rótulo de acessibilidade (ariaLabel)',
        description:
            'ariaLabel dá um nome acessível ao campo quando não há rótulo visível; leitores de tela anunciam esse texto.',
        preview:
            // #region sg-stepper-input-aria-label
            SgStack(
              gap: 8,
              align: SgStackAlign.start,
              children: [
                SgStepperInput(
                  id: 'ingressos',
                  ariaLabel: context.tx('Quantidade de ingressos'),
                  minValue: 1,
                  maxValue: 10,
                  defaultValue: 2,
                  width: 160,
                ),
                Text('ariaLabel: ${context.tx('Quantidade de ingressos')}'),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputAriaLabel,
      ),
    ];

    return SgShowcasePage(
      name: 'SgStepperInput',
      description:
          'Campo numérico com botões de aumentar e diminuir, passo configurável e limites.',
      examples: examples,
      propSpecs: sgPropSpecs['SgStepperInput']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgStepperInput']!
            .where((s) => const {'enabled', 'readOnly'}.contains(s.name))
            .toList(),
        builder: (context, v) => SgStepperInput(
          id: 'pg',
          minValue: 0,
          maxValue: 10,
          defaultValue: 3,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          width: 160,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            'minValue: 0',
            'maxValue: 10',
            'defaultValue: 3',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add('${e.key}: ${e.value}');
          }
          return 'SgStepperInput(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
