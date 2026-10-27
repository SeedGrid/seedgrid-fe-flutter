// Showcase do SgInputCNPJ. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

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
  String _evento = 'nenhum';
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
            'Consulta de verdade em publica.cnpj.ws (precisa de internet; a API limita a 3 consultas por minuto). Para testar sem rede, passe publicaCnpjFetch.',
        preview:
            // #region sg-input-cnpj-consulta
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputCNPJ(
                  id: 'cnpj-consulta',
                  labelText: 'CNPJ com consulta',
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
                  const Text('Resultado da consulta'),
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
        code: SgInputCnpjPageSnippets.sgInputCnpjConsulta,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description:
            'filled alterna o fundo preenchido; withBorder remove a borda.',
        preview:
            // #region sg-input-cnpj-variacoes
            const Column(
              children: [
                SgInputCNPJ(
                  id: 'preenchido',
                  labelText: 'Preenchido',
                  filled: true,
                ),
                SizedBox(height: 12),
                SgInputCNPJ(
                  id: 'vazado',
                  labelText: 'Sem preenchimento',
                  filled: false,
                ),
                SizedBox(height: 12),
                SgInputCNPJ(
                  id: 'semborda',
                  labelText: 'Sem borda',
                  withBorder: false,
                ),
              ],
            ),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description:
            'clearButton: false esconde o botão de limpar (por padrão ele aparece com texto).',
        preview:
            // #region sg-input-cnpj-sem-limpar
            const SgInputCNPJ(
              id: 'semlimpar',
              labelText: 'CNPJ',
              initialValue: '05952365000130',
              clearButton: false,
            ),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description:
            'width aceita número (px) ou porcentagem; borderRadius arredonda os cantos.',
        preview:
            // #region sg-input-cnpj-largura
            const SgInputCNPJ(
              id: 'largura',
              labelText: 'CNPJ',
              width: 240,
              borderRadius: 20,
            ),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado e somente leitura',
        description:
            'disabled bloqueia o campo; readOnly deixa copiar, mas não editar.',
        preview:
            // #region sg-input-cnpj-estados
            const Column(
              children: [
                SgInputCNPJ(
                  id: 'desabilitado',
                  labelText: 'Desabilitado',
                  initialValue: '05952365000130',
                  disabled: true,
                ),
                SizedBox(height: 12),
                SgInputCNPJ(
                  id: 'leitura',
                  labelText: 'Somente leitura',
                  initialValue: '05952365000130',
                  readOnly: true,
                ),
              ],
            ),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjEstados,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description:
            'onChange, onEnter (foco), onExit (saída) e onClear informam o que o usuário fez.',
        preview:
            // #region sg-input-cnpj-eventos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputCNPJ(
                  id: 'eventos',
                  labelText: 'CNPJ',
                  onChange: (v) => setState(() => _evento = 'onChange: $v'),
                  onEnter: () => setState(() => _evento = 'onEnter'),
                  onExit: () => setState(() => _evento = 'onExit'),
                  onClear: () => setState(() => _evento = 'onClear'),
                ),
                const SizedBox(height: 8),
                Text('Último evento: $_evento'),
              ],
            ),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'labelPosition: float (padrão), top ou left; labelWidth fixa a largura do rótulo à esquerda.',
        preview:
            // #region sg-input-cnpj-rotulo
            const Column(
              children: [
                SgInputCNPJ(
                  id: 'topo',
                  labelText: 'Rótulo no topo',
                  labelPosition: SgInputCNPJLabelPosition.top,
                ),
                SizedBox(height: 12),
                SgInputCNPJ(
                  id: 'esquerda',
                  labelText: 'À esquerda',
                  labelPosition: SgInputCNPJLabelPosition.left,
                  labelWidth: 110,
                ),
              ],
            ),
        // #endregion
        code: SgInputCnpjPageSnippets.sgInputCnpjRotulo,
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
