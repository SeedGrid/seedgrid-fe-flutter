// Showcase do SgInputPhone. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_phone_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';

class SgInputPhonePage extends StatefulWidget {
  const SgInputPhonePage({super.key});

  @override
  State<SgInputPhonePage> createState() => _SgInputPhonePageState();
}

class _SgInputPhonePageState extends State<SgInputPhonePage> {
  final SgFormController _formControl = SgFormController(
    defaultValues: {'telefone': '11987654321'},
  );
  final ValueNotifier<String> _basico = ValueNotifier('');
  final ValueNotifier<String?> _validationMsg = ValueNotifier(null);
  final ValueNotifier<List<String>> _eventLog = ValueNotifier(const []);

  void _log(String entry) => _eventLog.value = [entry, ..._eventLog.value];

  @override
  void dispose() {
    _formControl.dispose();
    _basico.dispose();
    _validationMsg.dispose();
    _eventLog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Telefone com label e hint.',
        preview:
            // #region sg-input-phone-basico
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPhone(
                    id: 'demo-basic',
                    labelText: context.tx('Telefone'),
                    hintText: context.tx('(00) 00000-0000'),
                    onChange: (v) => _basico.value = v,
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: _basico,
                    builder: (context, valor, _) =>
                        Text('${context.tx('Valor')}: "$valor"'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description: 'Valida se está vazio e mostra mensagem customizada.',
        preview:
            // #region sg-input-phone-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputPhone(
                    id: 'demo-required',
                    labelText: context.tx('Telefone obrigatório'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputPhone(
                    id: 'demo-required-custom',
                    labelText: context.tx('Mensagem customizada'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                    requiredMessage: context.tx('Informe o telefone.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneObrigatorio,
      ),
      ShowcaseExample(
        title: 'Mensagem inválida',
        description: 'Personaliza mensagem de telefone inválido.',
        preview:
            // #region sg-input-phone-invalida
            SizedBox(
              width: 320,
              child: SgInputPhone(
                id: 'demo-invalid',
                labelText: context.tx('Telefone'),
                hintText: context.tx('(00) 00000-0000'),
                invalidMessage: context.tx('Telefone inválido.'),
              ),
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneInvalida,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem ou null.',
        preview:
            // #region sg-input-phone-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPhone(
                    id: 'demo-validation',
                    labelText: context.tx('Telefone'),
                    hintText: context.tx('(00) 00000-0000'),
                    validation: (v) => v.startsWith('(00)')
                        ? context.tx('DDD inválido.')
                        : null,
                    onValidation: (msg) => _validationMsg.value = msg,
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String?>(
                    valueListenable: _validationMsg,
                    builder: (context, msg, _) => Text(
                      'onValidation: ${msg == null ? context.tx('válido') : '"$msg"'}',
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneValidacao,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-phone-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputPhone(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    hintText: context.tx('Telefone'),
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputPhone(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    hintText: context.tx('Telefone'),
                    filled: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description: 'clearButton=false remove o X do input.',
        preview:
            // #region sg-input-phone-sem-limpar
            SizedBox(
              width: 320,
              child: SgInputPhone(
                id: 'demo-noclear',
                labelText: context.tx('Sem limpar'),
                hintText: context.tx('Telefone'),
                clearButton: false,
              ),
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-phone-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputPhone(
                  id: 'demo-w200',
                  labelText: context.tx('200px'),
                  hintText: context.tx('Telefone'),
                  width: 200,
                ),
                SgInputPhone(
                  id: 'demo-w300',
                  labelText: context.tx('300px arredondado'),
                  hintText: context.tx('Telefone'),
                  width: 300,
                  borderRadius: 20,
                ),
              ],
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'enabled=false desabilita.',
        preview:
            // #region sg-input-phone-desabilitado
            SizedBox(
              width: 320,
              child: SgInputPhone(
                id: 'demo-disabled',
                labelText: context.tx('Desabilitado'),
                hintText: context.tx('Telefone'),
                enabled: false,
                initialValue: '(11) 99999-0000',
              ),
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneDesabilitado,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description: 'onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-phone-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPhone(
                    id: 'demo-events',
                    labelText: context.tx('Digite e observe o log'),
                    hintText: context.tx('Telefone'),
                    required: true,
                    onChange: (v) => _log('onChange: "$v"'),
                    onEnter: () => _log(context.tx('onEnter (focus)')),
                    onExit: () => _log(context.tx('onExit (blur)')),
                    onClear: () => _log('onClear'),
                    onValidation: (msg) =>
                        _log('onValidation: ${msg ?? context.tx('válido')}'),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: _eventLog,
                    builder: (context, entries, _) => ShowcaseLogBox(
                      entries: entries,
                      hint: context.tx('Interaja com o input...'),
                      height: 160,
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-phone-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputPhone(
                    id: 'sg-input-phone-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputPhoneLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputPhone(
                    id: 'sg-input-phone-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputPhoneLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputPhone(
                    id: 'sg-input-phone-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputPhoneLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputPhoneLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneRotulo,
      ),
      ShowcaseExample(
        title: 'Formulário com control',
        description:
            'Com `name` e `control`, o valor do formulário vem sempre mascarado. Para enviar só os dígitos, limpe com value.replaceAll(RegExp(r\'\\D\'), \'\').',
        preview:
            // #region sg-input-phone-formulario-control
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPhone(
                    id: 'telefone-control',
                    name: 'telefone',
                    labelText: context.tx('Telefone'),
                    control: _formControl,
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: _formControl,
                    builder: (context, _) {
                      final value =
                          '${_formControl.getValue('telefone') ?? ''}';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${context.tx('Valor no formulário')}: "$value"',
                          ),
                          Text(
                            '${context.tx('Só os dígitos')}: "${value.replaceAll(RegExp(r'\D'), '')}"',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneFormularioControl,
      ),
      ShowcaseExample(
        title: 'Formulário com register',
        description:
            'Dentro de um SgForm, o campo com `name` se liga ao formulário (equivale ao register do React) e o valor também vem mascarado. Para enviar só os dígitos, limpe com value.replaceAll(RegExp(r\'\\D\'), \'\').',
        preview:
            // #region sg-input-phone-formulario-register
            SgForm(
              defaultValues: {'telefone': '11987654321'},
              child: Builder(
                builder: (context) {
                  final form = SgForm.of(context);
                  return SizedBox(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SgInputPhone(
                          id: 'telefone-register',
                          name: 'telefone',
                          labelText: context.tx('Telefone'),
                        ),
                        const SizedBox(height: 8),
                        ListenableBuilder(
                          listenable: form,
                          builder: (context, _) {
                            final value = '${form.getValue('telefone') ?? ''}';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${context.tx('Valor no formulário')}: "$value"',
                                ),
                                Text(
                                  '${context.tx('Só os dígitos')}: "${value.replaceAll(RegExp(r'\D'), '')}"',
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        // #endregion
        code: SgInputPhonePageSnippets.sgInputPhoneFormularioRegister,
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
                'enabled',
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
          enabled: v['enabled'] as bool?,
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
