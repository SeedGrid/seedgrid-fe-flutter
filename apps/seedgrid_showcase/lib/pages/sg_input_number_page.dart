// Showcase do SgInputNumber. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_input_number_page.snippets.g.dart';

class SgInputNumberPage extends StatefulWidget {
  const SgInputNumberPage({super.key});

  @override
  State<SgInputNumberPage> createState() => _SgInputNumberPageState();
}

class _SgInputNumberPageState extends State<SgInputNumberPage> {
  final SgFormController _form = SgFormController(defaultValues: {'qtd': ''});
  String _valor = '';
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
            'Digite os números: o campo mostra o valor formatado pelo idioma e entrega o valor com ponto (1234.50) em onChange.',
        preview:
            // #region sg-input-number-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputNumber(
                  id: 'quantidade',
                  labelText: 'Quantidade',
                  onChange: (v) => setState(() => _valor = v),
                ),
                const SizedBox(height: 8),
                Text(
                  'onChange: ${_valor.isEmpty ? '(nada digitado)' : _valor}',
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberBasico,
      ),
      ShowcaseExample(
        title: 'Casas decimais e sinal',
        description:
            'decimals muda as casas (0 a n); allowNegative: false ignora o sinal de menos.',
        preview:
            // #region sg-input-number-decimais
            const Column(
              children: [
                SgInputNumber(
                  id: 'inteiro',
                  labelText: 'Inteiro (decimals: 0)',
                  decimals: 0,
                ),
                SizedBox(height: 12),
                SgInputNumber(
                  id: 'tres',
                  labelText: 'Três casas (decimals: 3)',
                  decimals: 3,
                ),
                SizedBox(height: 12),
                SgInputNumber(
                  id: 'positivo',
                  labelText: 'Só positivo',
                  allowNegative: false,
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberDecimais,
      ),
      ShowcaseExample(
        title: 'Rótulo, afixos e vazio',
        description:
            'labelPosition, prefixText/suffixText e emptyValue: nullValue (o campo começa vazio em vez de 0,00).',
        preview:
            // #region sg-input-number-afixos
            const Column(
              children: [
                SgInputNumber(
                  id: 'peso',
                  labelText: 'Peso',
                  labelPosition: SgInputNumberLabelPosition.top,
                  suffixText: 'kg',
                ),
                SizedBox(height: 12),
                SgInputNumber(
                  id: 'distancia',
                  labelText: 'Distância',
                  labelPosition: SgInputNumberLabelPosition.left,
                  labelWidth: 110,
                  suffixText: 'km',
                  emptyValue: SgInputNumberEmptyValue.nullValue,
                  hintText: 'digite',
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberAfixos,
      ),
      ShowcaseExample(
        title: 'Validação',
        description:
            'required (zero conta como vazio), minValue e maxValue com mensagens do idioma; a mensagem aparece ao sair do campo.',
        preview:
            // #region sg-input-number-validacao
            const Column(
              children: [
                SgInputNumber(
                  id: 'obrigatorio',
                  labelText: 'Obrigatório',
                  required: true,
                ),
                SizedBox(height: 12),
                SgInputNumber(
                  id: 'faixa',
                  labelText: 'Entre 10 e 20',
                  minValue: 10,
                  maxValue: 20,
                ),
                SizedBox(height: 12),
                SgInputNumber(
                  id: 'mensagem',
                  labelText: 'Mínimo 5',
                  minValue: 5,
                  minValueMessage: 'Muito pouco',
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberValidacao,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control + rules, como o useForm do react-hook-form. O formulário guarda o valor com ponto.',
        preview:
            // #region sg-input-number-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputNumber(
                  id: 'qtd',
                  name: 'qtd',
                  control: _form,
                  labelText: 'Quantidade',
                  emptyValue: SgInputNumberEmptyValue.nullValue,
                  required: true,
                  requiredMessage: 'Informe a quantidade',
                  rules: SgRules(
                    validate: (v) =>
                        (num.tryParse('$v') ?? 0) >= 1 ? true : 'Mínimo 1',
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['qtd']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberFormulario,
      ),
    ];

    const playgroundProps = {
      'labelPosition',
      'elevation',
      'emptyValue',
      'allowNegative',
      'disabled',
      'readOnly',
      'required',
      'filled',
      'withBorder',
      'clearButton',
      'prefixText',
      'suffixText',
      'hintText',
      'placeholder',
    };
    return SgShowcasePage(
      name: 'SgInputNumber',
      description:
          'Campo numérico com formatação por idioma, casas decimais, sinal, limites e ligação a formulário (SgForm).',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputNumber']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'inputProps.defaultValue',
          type: 'Object?',
          tsType: 'string | number',
          required: false,
          description: 'Valor inicial sem formulário ("1234.5" ou "12,5").',
          exact: false,
        ),
        const SgPropSpec(
          name: 'value',
          reactName: 'inputProps.value',
          type: 'Object?',
          tsType: 'string | number',
          required: false,
          description: 'Valor controlado de fora; mudar atualiza o campo.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputNumber']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => SgInputNumber(
          key: ValueKey('pg-${v['emptyValue']}'),
          id: 'pg',
          labelText: 'Valor',
          labelPosition: SgInputNumberLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          elevation: SgInputNumberElevation.fromValue(
            v['elevation'] as String?,
          ),
          emptyValue: SgInputNumberEmptyValue.fromValue(
            v['emptyValue'] as String?,
          ),
          allowNegative: v['allowNegative'] as bool?,
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          filled: v['filled'] as bool?,
          withBorder: v['withBorder'] as bool?,
          clearButton: v['clearButton'] as bool?,
          prefixText: v['prefixText'] as String?,
          suffixText: v['suffixText'] as String?,
          hintText: v['hintText'] as String?,
          placeholder: v['placeholder'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Valor'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputNumberLabelPosition.${SgInputNumberLabelPosition.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgInputNumberElevation.${SgInputNumberElevation.fromValue(e.value as String)!.name}',
              'emptyValue' =>
                'emptyValue: SgInputNumberEmptyValue.${SgInputNumberEmptyValue.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputNumber(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
