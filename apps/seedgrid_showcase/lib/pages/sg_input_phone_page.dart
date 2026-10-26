// Showcase do SgInputPhone. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_phone_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgInputPhonePage extends StatefulWidget {
  const SgInputPhonePage({super.key});

  @override
  State<SgInputPhonePage> createState() => _SgInputPhonePageState();
}

class _SgInputPhonePageState extends State<SgInputPhonePage> {
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
        description:
            'Fixo (10 dígitos) e celular (11 dígitos) formatam sozinhos.',
        preview:
            // #region sg-input-phone-basico
            const SgInputPhone(id: 'telefone', labelText: 'Telefone'),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório e mensagem própria',
        preview:
            // #region sg-input-phone-obrigatorio
            const SgInputPhone(
              id: 'telefone-obrigatorio',
              labelText: 'Celular',
              required: true,
              requiredMessage: 'Informe um telefone',
              invalidMessage: 'Telefone incompleto',
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneObrigatorio,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description:
            'filled alterna o fundo preenchido; withBorder remove a borda.',
        preview:
            // #region sg-input-phone-variacoes
            const Column(
              children: [
                SgInputPhone(
                  id: 'preenchido',
                  labelText: 'Preenchido',
                  filled: true,
                ),
                SizedBox(height: 12),
                SgInputPhone(
                  id: 'vazado',
                  labelText: 'Sem preenchimento',
                  filled: false,
                ),
                SizedBox(height: 12),
                SgInputPhone(
                  id: 'semborda',
                  labelText: 'Sem borda',
                  withBorder: false,
                ),
              ],
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description:
            'clearButton: false esconde o botão de limpar (por padrão ele aparece com texto).',
        preview:
            // #region sg-input-phone-sem-limpar
            const SgInputPhone(
              id: 'semlimpar',
              labelText: 'Telefone',
              initialValue: '11987654321',
              clearButton: false,
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description:
            'width aceita número (px) ou porcentagem; borderRadius arredonda os cantos.',
        preview:
            // #region sg-input-phone-largura
            const SgInputPhone(
              id: 'largura',
              labelText: 'Telefone',
              width: 240,
              borderRadius: 20,
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado e somente leitura',
        description:
            'disabled bloqueia o campo; readOnly deixa copiar, mas não editar.',
        preview:
            // #region sg-input-phone-estados
            const Column(
              children: [
                SgInputPhone(
                  id: 'desabilitado',
                  labelText: 'Desabilitado',
                  initialValue: '11987654321',
                  disabled: true,
                ),
                SizedBox(height: 12),
                SgInputPhone(
                  id: 'leitura',
                  labelText: 'Somente leitura',
                  initialValue: '11987654321',
                  readOnly: true,
                ),
              ],
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneEstados,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description:
            'onChange, onEnter (foco), onExit (saída) e onClear informam o que o usuário fez.',
        preview:
            // #region sg-input-phone-eventos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputPhone(
                  id: 'eventos',
                  labelText: 'Telefone',
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
        code: SgInputPhonePageSnippets.sgInputPhoneEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'labelPosition: float (padrão), top ou left; labelWidth fixa a largura do rótulo à esquerda.',
        preview:
            // #region sg-input-phone-rotulo
            const Column(
              children: [
                SgInputPhone(
                  id: 'topo',
                  labelText: 'Rótulo no topo',
                  labelPosition: SgInputPhoneLabelPosition.top,
                ),
                SizedBox(height: 12),
                SgInputPhone(
                  id: 'esquerda',
                  labelText: 'À esquerda',
                  labelPosition: SgInputPhoneLabelPosition.left,
                  labelWidth: 110,
                ),
              ],
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneRotulo,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        preview:
            // #region sg-input-phone-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputPhone(
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
        code: SgInputPhonePageSnippets.sgInputPhoneFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputPhone',
      description:
          'Telefone brasileiro (10 ou 11 dígitos) com máscara (00) 00000-0000.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputPhone']!,
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
        specs: sgPropSpecs['SgInputPhone']!
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
        builder: (context, v) => SgInputPhone(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputPhoneLabelPosition.fromValue(
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
                'labelPosition: SgInputPhoneLabelPosition.${SgInputPhoneLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputPhone(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
