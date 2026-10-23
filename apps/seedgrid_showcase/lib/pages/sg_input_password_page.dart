// Showcase do SgInputPassword. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_input_password_page.snippets.g.dart';

class SgInputPasswordPage extends StatefulWidget {
  const SgInputPasswordPage({super.key});

  @override
  State<SgInputPasswordPage> createState() => _SgInputPasswordPageState();
}

class _SgInputPasswordPageState extends State<SgInputPasswordPage> {
  final SgFormController _form = SgFormController();
  String _resultado = '';

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
            'Política padrão: 8 caracteres, maiúscula, minúscula, número, especial, sem repetição nem sequência. A barra mostra a força.',
        preview:
            // #region sg-input-password-basico
            const SgInputPassword(id: 'senha', labelText: 'Senha'),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordBasico,
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
      ShowcaseExample(
        title: 'Obrigatória e validação própria',
        preview:
            // #region sg-input-password-validacao
            SgInputPassword(
              id: 'regra',
              labelText: 'Senha',
              required: true,
              requiredMessage: 'Informe a senha',
              validation: (v) => v.toLowerCase().contains('empresa')
                  ? 'Não use o nome da empresa'
                  : null,
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordValidacao,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário com confirmação',
        description:
            'A confirmação usa rules.validate comparando com o outro campo.',
        preview:
            // #region sg-input-password-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputPassword(
                  id: 'f-senha',
                  name: 'senha',
                  control: _form,
                  labelText: 'Senha',
                  required: true,
                ),
                const SizedBox(height: 12),
                SgInputPassword(
                  id: 'f-confirma',
                  name: 'confirma',
                  control: _form,
                  labelText: 'Confirme a senha',
                  showStrengthBar: false,
                  rules: SgRules(
                    validate: (v) => v == _form.getValue('senha')
                        ? true
                        : 'As senhas não conferem',
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Criar conta'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _resultado = 'Conta criada'),
                  ),
                ),
                if (_resultado.isNotEmpty) Text(_resultado),
              ],
            ),
        // #endregion
        code: SgInputPasswordPageSnippets.sgInputPasswordFormulario,
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
                'disabled',
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
          disabled: v['disabled'] as bool?,
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
