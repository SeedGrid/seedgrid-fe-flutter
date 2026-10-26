// Showcase do SgInputEmail. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_input_email_page.snippets.g.dart';

class SgInputEmailPage extends StatefulWidget {
  const SgInputEmailPage({super.key});

  @override
  State<SgInputEmailPage> createState() => _SgInputEmailPageState();
}

class _SgInputEmailPageState extends State<SgInputEmailPage> {
  final SgFormController _form = SgFormController();
  String _evento = 'nenhum';
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
        description: 'Valida o formato a cada digitação e ao sair do campo.',
        preview:
            // #region sg-input-email-basico
            const SgInputEmail(
              id: 'email',
              labelText: 'E-mail',
              placeholder: 'voce@empresa.com',
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório e mensagens próprias',
        description: 'Saia do campo vazio para ver a mensagem de obrigatório.',
        preview:
            // #region sg-input-email-obrigatorio
            const Column(
              children: [
                SgInputEmail(
                  id: 'obrigatorio',
                  labelText: 'Obrigatório',
                  required: true,
                ),
                SizedBox(height: 12),
                SgInputEmail(
                  id: 'proprias',
                  labelText: 'Mensagens próprias',
                  required: true,
                  requiredMessage: 'Informe o e-mail do responsável',
                  invalidMessage: 'Esse e-mail não parece certo',
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailObrigatorio,
      ),
      ShowcaseExample(
        title: 'E-mails descartáveis',
        description:
            'Domínios temporários (yopmail.com, guerrillamail.com...) são bloqueados por padrão; blockFakeMail desliga e blockedEmailDomains acrescenta.',
        preview:
            // #region sg-input-email-descartaveis
            const Column(
              children: [
                SgInputEmail(
                  id: 'padrao',
                  labelText: 'Bloqueio padrão (tente a@yopmail.com)',
                ),
                SizedBox(height: 12),
                SgInputEmail(
                  id: 'livre',
                  labelText: 'blockFakeMail: false',
                  blockFakeMail: false,
                ),
                SizedBox(height: 12),
                SgInputEmail(
                  id: 'extra',
                  labelText: 'Bloqueia @concorrente.com',
                  blockedEmailDomains: ['concorrente.com'],
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailDescartaveis,
      ),
      ShowcaseExample(
        title: 'Validação própria',
        description: 'A validação própria vem antes da checagem de formato.',
        preview:
            // #region sg-input-email-validacao
            SgInputEmail(
              id: 'corporativo',
              labelText: 'E-mail corporativo',
              validation: (v) => v.endsWith('@empresa.com')
                  ? null
                  : 'Use o e-mail @empresa.com',
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailValidacao,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description:
            'filled alterna o fundo preenchido; withBorder remove a borda.',
        preview:
            // #region sg-input-email-variacoes
            const Column(
              children: [
                SgInputEmail(
                  id: 'preenchido',
                  labelText: 'Preenchido',
                  filled: true,
                ),
                SizedBox(height: 12),
                SgInputEmail(
                  id: 'vazado',
                  labelText: 'Sem preenchimento',
                  filled: false,
                ),
                SizedBox(height: 12),
                SgInputEmail(
                  id: 'semborda',
                  labelText: 'Sem borda',
                  withBorder: false,
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description:
            'clearButton: false esconde o botão de limpar (por padrão ele aparece com texto).',
        preview:
            // #region sg-input-email-sem-limpar
            const SgInputEmail(
              id: 'semlimpar',
              labelText: 'E-mail',
              initialValue: 'ana@exemplo.com',
              clearButton: false,
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description:
            'width aceita número (px) ou porcentagem; borderRadius arredonda os cantos.',
        preview:
            // #region sg-input-email-largura
            const SgInputEmail(
              id: 'largura',
              labelText: 'E-mail',
              width: 240,
              borderRadius: 20,
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado e somente leitura',
        description:
            'disabled bloqueia o campo; readOnly deixa copiar, mas não editar.',
        preview:
            // #region sg-input-email-estados
            const Column(
              children: [
                SgInputEmail(
                  id: 'desabilitado',
                  labelText: 'Desabilitado',
                  initialValue: 'ana@exemplo.com',
                  disabled: true,
                ),
                SizedBox(height: 12),
                SgInputEmail(
                  id: 'leitura',
                  labelText: 'Somente leitura',
                  initialValue: 'ana@exemplo.com',
                  readOnly: true,
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailEstados,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description:
            'onChange, onEnter (foco), onExit (saída) e onClear informam o que o usuário fez.',
        preview:
            // #region sg-input-email-eventos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputEmail(
                  id: 'eventos',
                  labelText: 'E-mail',
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
        code: SgInputEmailPageSnippets.sgInputEmailEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'labelPosition: float (padrão), top ou left; labelWidth fixa a largura do rótulo à esquerda.',
        preview:
            // #region sg-input-email-rotulo
            const Column(
              children: [
                SgInputEmail(
                  id: 'topo',
                  labelText: 'Rótulo no topo',
                  labelPosition: SgInputEmailLabelPosition.top,
                ),
                SizedBox(height: 12),
                SgInputEmail(
                  id: 'esquerda',
                  labelText: 'À esquerda',
                  labelPosition: SgInputEmailLabelPosition.left,
                  labelWidth: 110,
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailRotulo,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        preview:
            // #region sg-input-email-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputEmail(
                  id: 'form-email',
                  name: 'email',
                  control: _form,
                  labelText: 'E-mail',
                  required: true,
                  requiredMessage: 'Informe o e-mail',
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['email']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputEmail',
      description:
          'Campo de e-mail com validação de formato, bloqueio de e-mails descartáveis e ligação a formulário.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputEmail']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'inputProps.defaultValue',
          type: 'String?',
          tsType: 'string',
          required: false,
          description:
              'Valor inicial quando não há control (no React vai em inputProps).',
        ),
        const SgPropSpec(
          name: 'inputFormatters',
          reactName: 'inputProps',
          type: 'List<TextInputFormatter>?',
          tsType: 'InputHTMLAttributes',
          required: false,
          description:
              'Lista fechada que substitui inputProps (ADR 50): formatadores de entrada.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'autofocus',
          reactName: 'inputProps.autoFocus',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'Foca o campo ao montar.',
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
          description: 'Ação do teclado.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'onSubmitted',
          reactName: 'inputProps.onKeyDown',
          type: 'ValueChanged<String>?',
          tsType: '(value: string) => void',
          required: false,
          description:
              'Tecla Enter / ação do teclado; recebe o valor completo.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'focusNode',
          reactName: 'inputProps.ref',
          type: 'FocusNode?',
          tsType: 'Ref<HTMLInputElement>',
          required: false,
          description: 'Foco externo.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputEmail']!
            .where(
              (s) => const {
                'required',
                'blockFakeMail',
                'labelPosition',
                'filled',
                'disabled',
                'readOnly',
                'clearButton',
                'placeholder',
                'hintText',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputEmail(
          id: 'pg',
          labelText: 'E-mail',
          required: v['required'] as bool?,
          blockFakeMail: v['blockFakeMail'] as bool?,
          labelPosition: SgInputEmailLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          filled: v['filled'] as bool?,
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          clearButton: v['clearButton'] as bool?,
          placeholder: v['placeholder'] as String?,
          hintText: v['hintText'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'E-mail'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputEmailLabelPosition.${SgInputEmailLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputEmail(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
