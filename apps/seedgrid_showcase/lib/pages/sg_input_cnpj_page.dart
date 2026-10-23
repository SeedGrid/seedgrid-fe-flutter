// Showcase do SgInputCNPJ. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_cnpj_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgInputCNPJPage extends StatefulWidget {
  const SgInputCNPJPage({super.key});

  @override
  State<SgInputCNPJPage> createState() => _SgInputCNPJPageState();
}

class _SgInputCNPJPageState extends State<SgInputCNPJPage> {
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
            'Aceita o CNPJ numérico e o alfanumérico (letras viram maiúsculas).',
        preview:
            // #region sg-input-cnpj-basico
            const SgInputCNPJ(id: 'cnpj', labelText: 'CNPJ'),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório e mensagens próprias',
        preview:
            // #region sg-input-cnpj-obrigatorio
            const SgInputCNPJ(
              id: 'cnpj-obrigatorio',
              labelText: 'CNPJ da empresa',
              required: true,
              requiredMessage: 'Informe o CNPJ',
              invalidMessage: 'CNPJ inválido, confira os dígitos',
            ),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjObrigatorio,
      ),
      ShowcaseExample(
        title: 'Consulta na base pública',
        description:
            'Aqui a consulta é simulada (publicaCnpjFetch); sem ela, o padrão consulta publica.cnpj.ws.',
        preview:
            // #region sg-input-cnpj-consulta
            SgInputCNPJ(
              id: 'cnpj-consulta',
              labelText: 'CNPJ com consulta',
              validateWithPublicaCnpj: true,
              publicaCnpjErrorMessage: 'CNPJ não encontrado na Receita',
              publicaCnpjFetch: (cnpj) async =>
                  cnpj.endsWith('81') ? {'razao_social': 'ACME LTDA'} : null,
            ),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjConsulta,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        preview:
            // #region sg-input-cnpj-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputCNPJ(
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
        code: SgInputCnpjPageSnippets.sgInputCnpjFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputCNPJ',
      description:
          'Campo de CNPJ (numérico e alfanumérico) com máscara 00.000.000/0000-00, validação dos dígitos e consulta opcional na base pública.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputCNPJ']!,
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
        specs: sgPropSpecs['SgInputCNPJ']!
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
        builder: (context, v) => SgInputCNPJ(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputCNPJLabelPosition.fromValue(
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
                'labelPosition: SgInputCNPJLabelPosition.${SgInputCNPJLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputCNPJ(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
