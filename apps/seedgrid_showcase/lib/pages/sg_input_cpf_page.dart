// Showcase do SgInputCPF. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_cpf_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgInputCPFPage extends StatefulWidget {
  const SgInputCPFPage({super.key});

  @override
  State<SgInputCPFPage> createState() => _SgInputCPFPageState();
}

class _SgInputCPFPageState extends State<SgInputCPFPage> {
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
            'A máscara é aplicada a cada dígito; a validação aparece ao digitar e ao sair do campo.',
        preview:
            // #region sg-input-cpf-basico
            const SgInputCPF(id: 'cpf', labelText: 'CPF'),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório e mensagens próprias',
        preview:
            // #region sg-input-cpf-obrigatorio
            const SgInputCPF(
              id: 'cpf-obrigatorio',
              labelText: 'CPF do titular',
              required: true,
              requiredMessage: 'Informe o CPF',
              lengthMessage: 'O CPF tem 11 dígitos',
              invalidMessage: 'Esse CPF não existe',
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfObrigatorio,
      ),
      ShowcaseExample(
        title: 'Validação própria',
        description:
            'A função recebe o valor mascarado e devolve a mensagem ou null.',
        preview:
            // #region sg-input-cpf-validacao
            SgInputCPF(
              id: 'cpf-regra',
              labelText: 'CPF (não aceita 000...)',
              validation: (v) =>
                  v.startsWith('000') ? 'CPF de teste não permitido' : null,
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfValidacao,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'O formulário guarda o valor mascarado.',
        preview:
            // #region sg-input-cpf-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputCPF(
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
        code: SgInputCpfPageSnippets.sgInputCpfFormulario,
      ),
      ShowcaseExample(
        title: 'Estados',
        preview:
            // #region sg-input-cpf-estados
            const Column(
              children: [
                SgInputCPF(
                  id: 'cpf-desabilitado',
                  labelText: 'Desabilitado',
                  disabled: true,
                  initialValue: '529.982.247-25',
                ),
                SizedBox(height: 12),
                SgInputCPF(
                  id: 'cpf-leitura',
                  labelText: 'Somente leitura',
                  readOnly: true,
                  initialValue: '529.982.247-25',
                ),
                SizedBox(height: 12),
                SgInputCPF(
                  id: 'cpf-erro',
                  labelText: 'Erro externo',
                  error: 'CPF já cadastrado',
                  initialValue: '529.982.247-25',
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfEstados,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputCPF',
      description:
          'Campo de CPF com máscara 000.000.000-00 e validação dos dígitos verificadores.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputCPF']!,
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
        specs: sgPropSpecs['SgInputCPF']!
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
        builder: (context, v) => SgInputCPF(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputCPFLabelPosition.fromValue(
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
                'labelPosition: SgInputCPFLabelPosition.${SgInputCPFLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputCPF(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
