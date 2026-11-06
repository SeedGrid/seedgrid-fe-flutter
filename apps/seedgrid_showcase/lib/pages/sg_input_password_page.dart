// Showcase do SgInputPassword. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';
import 'sg_input_password_page.snippets.g.dart';

class SgInputPasswordPage extends StatefulWidget {
  const SgInputPasswordPage({super.key});

  @override
  State<SgInputPasswordPage> createState() => _SgInputPasswordPageState();
}

class _SgInputPasswordPageState extends State<SgInputPasswordPage> {
  String _basico = '';
  String? _validationMsg;
  final List<String> _eventLog = [];

  void _log(String entry) => setState(() => _eventLog.insert(0, entry));

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Senha com label, hint e toggle de visibilidade.',
        preview:
            // #region sg-input-password-basico
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPassword(
                    id: 'demo-basic',
                    labelText: context.tx('Senha'),
                    hintText: context.tx('Digite sua senha'),
                    onChange: (v) => setState(() => _basico = v),
                  ),
                  const SizedBox(height: 8),
                  Text('${context.tx('Valor')}: $_basico'),
                ],
              ),
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description: 'Valida se está vazio e mostra mensagem customizada.',
        preview:
            // #region sg-input-password-obrigatorio
            SizedBox(
              width: 320,
              child: SgInputPassword(
                id: 'demo-required',
                labelText: context.tx('Senha obrigatória'),
                hintText: context.tx('Obrigatório'),
                required: true,
              ),
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordObrigatorio,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem ou null.',
        preview:
            // #region sg-input-password-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPassword(
                    id: 'demo-validation',
                    labelText: context.tx('Mínimo 8'),
                    hintText: context.tx('Mínimo 8 caracteres'),
                    validation: (value) => value.length < 8
                        ? context.tx(
                            'Senha precisa ter no mínimo 8 caracteres.',
                          )
                        : null,
                    onValidation: (msg) => setState(() => _validationMsg = msg),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'onValidation: ${_validationMsg ?? context.tx('válido')}',
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordValidacao,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-password-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputPassword(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputPassword(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputPassword(
                    id: 'demo-noclear',
                    labelText: context.tx('Sem limpar'),
                    clearButton: false,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordVariacoes,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description: 'onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-password-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPassword(
                    id: 'demo-events',
                    labelText: context.tx('Digite e observe o log'),
                    required: true,
                    onChange: (value) => _log('onChange: "$value"'),
                    onEnter: () => _log(context.tx('onEnter (focus)')),
                    onExit: () => _log(context.tx('onExit (blur)')),
                    onClear: () => _log('onClear'),
                  ),
                  const SizedBox(height: 12),
                  ShowcaseLogBox(
                    entries: _eventLog,
                    hint: context.tx('Interaja com o input...'),
                    height: 160,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-password-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputPassword(
                    id: 'sg-input-password-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputPasswordLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputPassword(
                    id: 'sg-input-password-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputPasswordLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputPassword(
                    id: 'sg-input-password-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputPasswordLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputPasswordLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordRotulo,
      ),
      ShowcaseExample(
        title: 'Gerar senha forte',
        description:
            'O botão gera uma senha que cumpre a política; newPasswordLength define o tamanho.',
        preview:
            // #region sg-input-password-gerar
            const SgInputPassword(
              id: 'gerada',
              labelText: 'Senha',
              createNewPasswordButton: true,
              newPasswordLength: 12,
              maxLength: 32,
              hidePassword: false,
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordGerar,
      ),
      ShowcaseExample(
        title: 'Política própria',
        description:
            'Cada critério liga e desliga; minSize muda o tamanho mínimo e showStrengthBar esconde a barra.',
        preview:
            // #region sg-input-password-politica
            const SgInputPassword(
              id: 'politica',
              labelText: 'PIN alfanumérico',
              minSize: 6,
              upperRequired: false,
              specialCharacterRequired: false,
              prohibitsSequentialAscCharacters: false,
              prohibitsSequentialDescCharacters: false,
              showStrengthBar: false,
              commonPasswordCheck: false,
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordPolitica,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputPassword',
      description:
          'Campo de senha com política configurável, barra de força, lista de senhas comuns, mostrar/ocultar e gerador de senha forte.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputPassword']!,
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
        specs: sgPropSpecs['SgInputPassword']!
            .where(
              (s) => const {
                'createNewPasswordButton',
                'required',
                'enabled',
                'readOnly',
                'filled',
                'showCharCounter',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputPassword(
          // Remonta ao mudar um controle: createNewPasswordButton e required valem desde a montagem.
          key: ValueKey(v.entries.map((e) => '${e.key}=${e.value}').join(',')),
          id: 'pg',
          labelText: 'Senha',
          createNewPasswordButton:
              (v['createNewPasswordButton'] as bool?) ?? false,
          required: v['required'] as bool?,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          filled: v['filled'] as bool?,
          showCharCounter: v['showCharCounter'] as bool?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Senha'"];
          for (final e in v.entries) {
            if (e.value == true) args.add('${e.key}: true');
          }
          return 'SgInputPassword(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
