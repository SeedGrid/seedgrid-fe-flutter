// Showcase do SgInputBirthDate. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_birth_date_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgInputBirthDatePage extends StatefulWidget {
  const SgInputBirthDatePage({super.key});

  @override
  State<SgInputBirthDatePage> createState() => _SgInputBirthDatePageState();
}

class _SgInputBirthDatePageState extends State<SgInputBirthDatePage> {
  final SgFormController _form = SgFormController();
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
        title: 'Maior de idade',
        description: 'minAge: 18 limita a data máxima e valida a idade.',
        preview:
            // #region sg-input-birth-date-maior
            const SgInputBirthDate(
              id: 'nascimento',
              labelText: 'Data de nascimento',
              minAge: 18,
            ),
        // #endregion
        code: SgInputBirthDatePageSnippets.sgInputBirthDateMaior,
      ),
      ShowcaseExample(
        title: 'Faixa de idade',
        preview:
            // #region sg-input-birth-date-faixa
            const SgInputBirthDate(
              id: 'nascimento-faixa',
              labelText: 'Entre 18 e 65 anos',
              minAge: 18,
              maxAge: 65,
            ),
        // #endregion
        code: SgInputBirthDatePageSnippets.sgInputBirthDateFaixa,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        preview:
            // #region sg-input-birth-date-obrigatorio
            const SgInputBirthDate(
              id: 'nascimento-obrigatorio',
              labelText: 'Nascimento',
              minAge: 0,
              required: true,
              requiredMessage: 'Informe quando nasceu',
            ),
        // #endregion
        code: SgInputBirthDatePageSnippets.sgInputBirthDateObrigatorio,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        preview:
            // #region sg-input-birth-date-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputBirthDate(
                  id: 'campo',
                  name: 'campo',
                  control: _form,
                  labelText: 'Campo',
                  minAge: 18,
                  rules: const SgRules(required: 'Preencha o campo'),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['campo']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
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
                'disabled',
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
          disabled: v['disabled'] as bool?,
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
