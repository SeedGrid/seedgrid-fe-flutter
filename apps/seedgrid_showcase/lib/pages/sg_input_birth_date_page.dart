// Showcase do SgInputBirthDate. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_birth_date_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgInputBirthDatePage extends StatefulWidget {
  const SgInputBirthDatePage({super.key});

  @override
  State<SgInputBirthDatePage> createState() => _SgInputBirthDatePageState();
}

class _SgInputBirthDatePageState extends State<SgInputBirthDatePage> {
  final SgFormController _form = SgFormController();
  final ValueNotifier<String?> _validacao = ValueNotifier<String?>(null);
  final ValueNotifier<String> _enviado = ValueNotifier<String>('');

  @override
  void dispose() {
    _form.dispose();
    _validacao.dispose();
    _enviado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'minAge: 18 limita a data máxima e valida a idade.',
        preview:
            // #region sg-input-birth-date-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputBirthDate(
                  id: 'demo-basic',
                  labelText: context.tx('Data de nascimento'),
                  minAge: 18,
                  onValidation: (msg) => _validacao.value = msg,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String?>(
                  valueListenable: _validacao,
                  builder: (context, msg, _) =>
                      Text('onValidation: ${msg ?? context.tx('válido')}'),
                ),
              ],
            ),
        // #endregion
        code: SgInputBirthDatePageSnippets.sgInputBirthDateBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description: 'Valida campo vazio.',
        preview:
            // #region sg-input-birth-date-obrigatorio
            SgInputBirthDate(
              id: 'demo-required',
              labelText: context.tx('Data de nascimento'),
              minAge: 18,
              required: true,
              requiredMessage: context.tx('Informe a data de nascimento.'),
            ),
        // #endregion
        code: SgInputBirthDatePageSnippets.sgInputBirthDateObrigatorio,
      ),
      ShowcaseExample(
        title: 'Faixa customizada',
        description: 'minAge e maxAge configuráveis.',
        preview:
            // #region sg-input-birth-date-faixa
            SgInputBirthDate(
              id: 'demo-range',
              labelText: context.tx('Data de nascimento'),
              minAge: 12,
              maxAge: 80,
            ),
        // #endregion
        code: SgInputBirthDatePageSnippets.sgInputBirthDateFaixa,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-birth-date-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputBirthDate(
                    id: 'sg-input-birth-date-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputBirthDateLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputBirthDate(
                    id: 'sg-input-birth-date-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputBirthDateLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputBirthDate(
                    id: 'sg-input-birth-date-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputBirthDateLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputBirthDateLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputBirthDatePageSnippets.sgInputBirthDateRotulo,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'O formulário guarda a data de nascimento.',
        preview:
            // #region sg-input-birth-date-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputBirthDate(
                  id: 'campo',
                  name: 'campo',
                  control: _form,
                  labelText: context.tx('Data de nascimento'),
                  minAge: 18,
                  required: true,
                  requiredMessage: context.tx('Informe a data de nascimento.'),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => _enviado.value = '${values['campo']}',
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, enviado, _) => enviado.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          context.txf('Enviado: {valor}', {'valor': enviado}),
                        ),
                ),
              ],
            ),
        // #endregion
        code: SgInputBirthDatePageSnippets.sgInputBirthDateFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputBirthDate',
      description:
          'Data de nascimento: SgInputDate com limites derivados de minAge/maxAge e validação de idade ao sair do campo.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputBirthDate']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'inputProps.defaultValue',
          type: 'String?',
          tsType: 'string',
          required: false,
          description:
              'Valor inicial quando não há control (lista fechada que substitui inputProps).',
        ),
        const SgPropSpec(
          name: 'autofocus',
          reactName: 'inputProps.autoFocus',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'Foca o campo ao abrir.',
        ),
        const SgPropSpec(
          name: 'autofillHints',
          reactName: 'inputProps.autoComplete',
          type: 'Iterable<String>?',
          tsType: 'string',
          required: false,
          description: 'Dicas de preenchimento automático.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'textInputAction',
          reactName: 'inputProps.enterKeyHint',
          type: 'TextInputAction?',
          tsType: 'string',
          required: false,
          description: 'Ação do botão de confirmar do teclado.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'onSubmitted',
          reactName: 'inputProps.onKeyDown(Enter)',
          type: 'ValueChanged<String>?',
          tsType: '(value: string) => void',
          required: false,
          description: 'Chamado com o valor ao confirmar no teclado.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'focusNode',
          reactName: 'inputProps.ref',
          type: 'FocusNode?',
          tsType: 'Ref<HTMLInputElement>',
          required: false,
          description: 'Controle externo do foco.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputBirthDate']!
            .where(
              (s) => const {
                'labelPosition',
                'filled',
                'enabled',
                'readOnly',
                'clearButton',
                'required',
                'hintText',
                'placeholder',
                'validateOnBlur',
                'showCharCounter',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputBirthDate(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputBirthDateLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          filled: v['filled'] as bool?,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          clearButton: v['clearButton'] as bool?,
          required: v['required'] as bool?,
          validateOnBlur: v['validateOnBlur'] as bool?,
          showCharCounter: v['showCharCounter'] as bool?,
          hintText: v['hintText'] as String?,
          placeholder: v['placeholder'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Rótulo'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputBirthDateLabelPosition.${SgInputBirthDateLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputBirthDate(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
