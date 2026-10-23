// Showcase do SgInputDate. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_date_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgInputDatePage extends StatefulWidget {
  const SgInputDatePage({super.key});

  @override
  State<SgInputDatePage> createState() => _SgInputDatePageState();
}

class _SgInputDatePageState extends State<SgInputDatePage> {
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
        title: 'Básico',
        description:
            'Digite ou abra o calendário; o valor entregue é a data ISO.',
        preview:
            // #region sg-input-date-basico
            const SgInputDate(id: 'data', labelText: 'Data'),
        // #endregion
        code: SgInputDatePageSnippets.sgInputDateBasico,
      ),
      ShowcaseExample(
        title: 'Limites de data',
        description:
            'Fora do intervalo aparece a mensagem; no calendário os dias ficam desabilitados.',
        preview:
            // #region sg-input-date-limites
            const SgInputDate(
              id: 'data-limites',
              labelText: 'Dentro de 2026',
              minDate: '2026-01-01',
              maxDate: '2026-12-31',
              initialValue: '2026-06-15',
            ),
        // #endregion
        code: SgInputDatePageSnippets.sgInputDateLimites,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        preview:
            // #region sg-input-date-obrigatorio
            const SgInputDate(
              id: 'data-obrigatoria',
              labelText: 'Data da consulta',
              required: true,
              requiredMessage: 'Escolha uma data',
            ),
        // #endregion
        code: SgInputDatePageSnippets.sgInputDateObrigatorio,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'O formulário guarda a data ISO.',
        preview:
            // #region sg-input-date-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputDate(
                  id: 'campo',
                  name: 'campo',
                  control: _form,
                  labelText: 'Campo',
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
        code: SgInputDatePageSnippets.sgInputDateFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputDate',
      description:
          'Campo de data com máscara do idioma e calendário próprio. O valor é a data ISO yyyy-MM-dd.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputDate']!,
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
        specs: sgPropSpecs['SgInputDate']!
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
        builder: (context, v) => SgInputDate(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputDateLabelPosition.fromValue(
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
                'labelPosition: SgInputDateLabelPosition.${SgInputDateLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputDate(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
