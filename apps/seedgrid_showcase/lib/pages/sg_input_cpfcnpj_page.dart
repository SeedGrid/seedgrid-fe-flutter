// Showcase do SgInputCPFCNPJ. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_cpfcnpj_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgInputCPFCNPJPage extends StatefulWidget {
  const SgInputCPFCNPJPage({super.key});

  @override
  State<SgInputCPFCNPJPage> createState() => _SgInputCPFCNPJPageState();
}

class _SgInputCPFCNPJPageState extends State<SgInputCPFCNPJPage> {
  final SgFormController _form = SgFormController();
  String _enviado = '';
  Object? _publicaResultado;
  String? _publicaErro;

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
            'Até 11 dígitos é CPF; passando disso, ou com letra, é CNPJ.',
        preview:
            // #region sg-input-cpfcnpj-basico
            const SgInputCPFCNPJ(id: 'documento', labelText: 'CPF ou CNPJ'),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfcnpjBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório e mensagens',
        preview:
            // #region sg-input-cpfcnpj-obrigatorio
            const SgInputCPFCNPJ(
              id: 'documento-obrigatorio',
              labelText: 'Documento',
              required: true,
              requiredMessage: 'Informe o documento',
              lengthMessage: 'Documento incompleto',
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfcnpjObrigatorio,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        preview:
            // #region sg-input-cpfcnpj-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputCPFCNPJ(
                  id: 'campo',
                  name: 'campo',
                  control: _form,
                  labelText: 'Campo',
                  rules: const SgRules(required: 'Preencha o campo'),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['campo']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfcnpjFormulario,
      ),
      ShowcaseExample(
        title: 'Consulta na base pública',
        description:
            'Com um CNPJ numérico válido, consulta de verdade em publica.cnpj.ws (precisa de internet; a API limita a 3 consultas por minuto). CPF não consulta. Para testar sem rede, passe publicaCnpjFetch.',
        preview:
            // #region sg-input-cpfcnpj-consulta
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputCPFCNPJ(
                  id: 'documento-consulta',
                  labelText: 'CPF ou CNPJ com consulta',
                  validateWithPublicaCnpj: true,
                  publicaCnpjErrorMessage: 'CNPJ não encontrado na Receita',
                  onPublicaCnpjResult: (data) => setState(() {
                    _publicaResultado = data;
                    _publicaErro = null;
                  }),
                  onPublicaCnpjError: (_) => setState(
                    () => _publicaErro =
                        'Não foi possível consultar a base pública agora.',
                  ),
                ),
                if (_publicaResultado != null) ...[
                  const SizedBox(height: 8),
                  Text(context.tx('Resultado da consulta')),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        const JsonEncoder.withIndent(
                          '  ',
                        ).convert(_publicaResultado),
                      ),
                    ),
                  ),
                ],
                if (_publicaErro != null) Text(_publicaErro!),
              ],
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfcnpjConsulta,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputCPFCNPJ',
      description:
          'Campo único que aceita CPF ou CNPJ e decide pela quantidade de caracteres.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputCPFCNPJ']!,
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
        specs: sgPropSpecs['SgInputCPFCNPJ']!
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
        builder: (context, v) => SgInputCPFCNPJ(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputCPFCNPJLabelPosition.fromValue(
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
                'labelPosition: SgInputCPFCNPJLabelPosition.${SgInputCPFCNPJLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputCPFCNPJ(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
