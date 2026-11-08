// Showcase do SgInputEmail. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';
import 'sg_input_email_page.snippets.g.dart';

class SgInputEmailPage extends StatefulWidget {
  const SgInputEmailPage({super.key});

  @override
  State<SgInputEmailPage> createState() => _SgInputEmailPageState();
}

class _SgInputEmailPageState extends State<SgInputEmailPage> {
  final ValueNotifier<String> _basico = ValueNotifier('');
  final ValueNotifier<String?> _validationMsg = ValueNotifier(null);
  final ValueNotifier<List<String>> _eventLog = ValueNotifier(const []);

  void _log(String entry) => _eventLog.value = [entry, ..._eventLog.value];

  @override
  void dispose() {
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
        description: 'Email com label e hint.',
        preview:
            // #region sg-input-email-basico
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputEmail(
                    id: 'demo-basic',
                    labelText: context.tx('Email'),
                    hintText: context.tx('exemplo@dominio.com'),
                    onChange: (v) => _basico.value = v,
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: _basico,
                    builder: (context, valor, _) =>
                        Text('${context.tx('Valor')}: $valor'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description: 'Valida se está vazio e mostra mensagem customizada.',
        preview:
            // #region sg-input-email-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputEmail(
                    id: 'demo-required',
                    labelText: context.tx('Email obrigatório'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputEmail(
                    id: 'demo-required-custom',
                    labelText: context.tx('Mensagem customizada'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                    requiredMessage: context.tx('Informe o email.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailObrigatorio,
      ),
      ShowcaseExample(
        title: 'Mensagem inválida',
        description: 'Personaliza mensagem de email inválido.',
        preview:
            // #region sg-input-email-invalido
            SizedBox(
              width: 320,
              child: SgInputEmail(
                id: 'demo-invalid',
                labelText: context.tx('Email'),
                hintText: context.tx('exemplo@dominio.com'),
                invalidMessage: context.tx('Email inválido.'),
              ),
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailInvalido,
      ),
      ShowcaseExample(
        title: 'Bloqueio de email temporário',
        description:
            'blockFakeMail=true (padrão) bloqueia domínios descartáveis.',
        preview:
            // #region sg-input-email-bloqueio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputEmail(
                    id: 'demo-blocked',
                    labelText: context.tx('Email'),
                    hintText: context.tx('exemplo@dominio.com'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputEmail(
                    id: 'demo-blocked-off',
                    labelText: context.tx('Sem bloqueio'),
                    hintText: context.tx('exemplo@dominio.com'),
                    blockFakeMail: false,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailBloqueio,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem ou null.',
        preview:
            // #region sg-input-email-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputEmail(
                    id: 'demo-validation',
                    labelText: context.tx('Somente domínio .com'),
                    hintText: context.tx('seu@dominio.com'),
                    validation: (v) => v.endsWith('.com')
                        ? null
                        : context.tx('Use domínio .com.'),
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
        code: SgInputEmailPageSnippets.sgInputEmailValidacao,
      ),
      ShowcaseExample(
        title: 'Lista bloqueada padrão',
        description: 'Domínios bloqueados por default.',
        preview:
            // #region sg-input-email-lista
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.05),
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                defaultBlockedEmailDomains.join(', '),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailLista,
      ),
      ShowcaseExample(
        title: 'Config JSON',
        description:
            'A aplicação host pode carregar um JSON e adicionar domínios em runtime.',
        preview:
            // #region sg-input-email-json
            SizedBox(
              width: 320,
              child: SgInputEmail(
                id: 'demo-json',
                labelText: context.tx('Email'),
                hintText: context.tx('exemplo@dominio.com'),
                blockedEmailDomains:
                    ((jsonDecode('{"blockedEmailDomains": ["concorrente.com"]}')
                                as Map<String, dynamic>)['blockedEmailDomains']
                            as List)
                        .cast<String>(),
              ),
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailJson,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-email-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputEmail(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    hintText: context.tx('Email'),
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputEmail(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    hintText: context.tx('Email'),
                    filled: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description: 'clearButton=false remove o X do input.',
        preview:
            // #region sg-input-email-sem-limpar
            SizedBox(
              width: 320,
              child: SgInputEmail(
                id: 'demo-noclear',
                labelText: context.tx('Sem limpar'),
                hintText: context.tx('Email'),
                clearButton: false,
              ),
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-email-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputEmail(
                  id: 'demo-w200',
                  labelText: context.tx('200px'),
                  hintText: context.tx('Email'),
                  width: 200,
                ),
                SgInputEmail(
                  id: 'demo-w300',
                  labelText: context.tx('300px arredondado'),
                  hintText: context.tx('Email'),
                  width: 300,
                  borderRadius: 20,
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'enabled=false desabilita.',
        preview:
            // #region sg-input-email-desabilitado
            SizedBox(
              width: 320,
              child: SgInputEmail(
                id: 'demo-disabled',
                labelText: context.tx('Desabilitado'),
                hintText: context.tx('Email'),
                enabled: false,
                initialValue: context.tx('Não editável'),
              ),
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailDesabilitado,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description: 'onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-email-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputEmail(
                    id: 'demo-events',
                    labelText: context.tx('Digite e observe o log'),
                    hintText: context.tx('Email'),
                    required: true,
                    onChange: (v) => _log('onChange: "$v"'),
                    onEnter: () => _log('onEnter (focus)'),
                    onExit: () => _log('onExit (blur)'),
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
        code: SgInputEmailPageSnippets.sgInputEmailEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-email-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputEmail(
                    id: 'sg-input-email-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputEmailLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputEmail(
                    id: 'sg-input-email-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputEmailLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputEmail(
                    id: 'sg-input-email-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputEmailLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputEmailLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputEmailPageSnippets.sgInputEmailRotulo,
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
                'enabled',
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
          enabled: v['enabled'] as bool?,
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
