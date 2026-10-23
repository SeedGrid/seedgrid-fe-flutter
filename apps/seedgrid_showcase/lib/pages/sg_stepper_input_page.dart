// Showcase do SgStepperInput. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_stepper_input_page.snippets.g.dart';

class SgStepperInputPage extends StatefulWidget {
  const SgStepperInputPage({super.key});

  @override
  State<SgStepperInputPage> createState() => _SgStepperInputPageState();
}

class _SgStepperInputPageState extends State<SgStepperInputPage> {
  final SgFormController _form = SgFormController();
  num _quantidade = 2;
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
            'Botões de aumentar e diminuir; o valor fica sempre entre minValue e maxValue.',
        preview:
            // #region sg-stepper-input-basico
            const SgStepperInput(
              id: 'basico',
              minValue: 0,
              maxValue: 10,
              defaultValue: 3,
              width: 160,
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputBasico,
      ),
      ShowcaseExample(
        title: 'Passo e limites',
        description:
            'step define o incremento (aceita decimais); no limite o botão fica desabilitado.',
        preview:
            // #region sg-stepper-input-passo
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgStepperInput(
                  id: 'de-cinco',
                  minValue: 0,
                  maxValue: 50,
                  step: 5,
                  width: 160,
                ),
                SizedBox(height: 12),
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
        title: 'Controlado',
        description:
            'Com value o pai manda no campo e recebe o novo número em onChange.',
        preview:
            // #region sg-stepper-input-controlado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgStepperInput(
                  id: 'controlado',
                  minValue: 1,
                  maxValue: 9,
                  value: _quantidade,
                  onChange: (v) => setState(() => _quantidade = v),
                  ariaLabel: 'Quantidade de itens',
                  width: 160,
                ),
                const SizedBox(height: 8),
                Text('Quantidade: $_quantidade'),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputControlado,
      ),
      ShowcaseExample(
        title: 'Estados',
        preview:
            // #region sg-stepper-input-estados
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgStepperInput(
                  id: 'desabilitado',
                  minValue: 0,
                  maxValue: 10,
                  defaultValue: 4,
                  disabled: true,
                  width: 160,
                ),
                SizedBox(height: 12),
                SgStepperInput(
                  id: 'leitura',
                  minValue: 0,
                  maxValue: 10,
                  defaultValue: 4,
                  readOnly: true,
                  width: 160,
                ),
                SizedBox(height: 12),
                SgStepperInput(
                  id: 'erro',
                  minValue: 0,
                  maxValue: 10,
                  error: 'Escolha ao menos 1',
                  width: 200,
                ),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputEstados,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'name + control + rules. O formulário guarda um número.',
        preview:
            // #region sg-stepper-input-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgStepperInput(
                  id: 'qtd',
                  name: 'qtd',
                  control: _form,
                  minValue: 0,
                  maxValue: 9,
                  width: 160,
                  rules: SgRules(
                    validate: (v) => (v as num) >= 2 ? true : 'Mínimo 2',
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['qtd']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgStepperInputPageSnippets.sgStepperInputFormulario,
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
            .where((s) => const {'disabled', 'readOnly'}.contains(s.name))
            .toList(),
        builder: (context, v) => SgStepperInput(
          id: 'pg',
          minValue: 0,
          maxValue: 10,
          defaultValue: 3,
          disabled: v['disabled'] as bool?,
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
