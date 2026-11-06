// Showcase do SgInputCPF. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_cpf_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';

class SgInputCPFPage extends StatefulWidget {
  const SgInputCPFPage({super.key});

  @override
  State<SgInputCPFPage> createState() => _SgInputCPFPageState();
}

class _SgInputCPFPageState extends State<SgInputCPFPage> {
  String _basico = '';
  String? _validationMsg;
  final List<String> _eventLog = [];

  void _log(String entry) => setState(() => _eventLog.insert(0, entry));

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'CPF com label e hint.',
        preview:
            // #region sg-input-cpf-basico
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCPF(
                    id: 'demo-basic',
                    labelText: context.tx('CPF'),
                    hintText: context.tx('000.000.000-00'),
                    onChange: (v) => setState(() => _basico = v),
                  ),
                  const SizedBox(height: 8),
                  Text('${context.tx('Valor')}: $_basico'),
                ],
              ),
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description: 'Valida se está vazio e mostra mensagem customizada.',
        preview:
            // #region sg-input-cpf-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCPF(
                    id: 'demo-required',
                    labelText: context.tx('CPF obrigatório'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCPF(
                    id: 'demo-required-custom',
                    labelText: context.tx('Mensagem customizada'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                    requiredMessage: context.tx('Informe o CPF.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfObrigatorio,
      ),
      ShowcaseExample(
        title: 'Mensagem de tamanho',
        description: 'Personaliza mensagem quando CPF não tem 11 dígitos.',
        preview:
            // #region sg-input-cpf-tamanho
            SizedBox(
              width: 320,
              child: SgInputCPF(
                id: 'demo-length',
                labelText: context.tx('CPF'),
                hintText: context.tx('000.000.000-00'),
                lengthMessage: context.tx('CPF deve ter 11 dígitos.'),
              ),
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfTamanho,
      ),
      ShowcaseExample(
        title: 'Mensagem inválida',
        description: 'Personaliza mensagem de CPF inválido.',
        preview:
            // #region sg-input-cpf-invalida
            SizedBox(
              width: 320,
              child: SgInputCPF(
                id: 'demo-invalid',
                labelText: context.tx('CPF'),
                hintText: context.tx('000.000.000-00'),
                invalidMessage: context.tx('CPF inválido.'),
              ),
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfInvalida,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem ou null.',
        preview:
            // #region sg-input-cpf-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCPF(
                    id: 'demo-validation',
                    labelText: context.tx('CPF'),
                    hintText: context.tx('000.000.000-00'),
                    validation: (v) => v.startsWith('123')
                        ? context.tx('CPF não pode iniciar com 123.')
                        : null,
                    onValidation: (msg) => setState(() => _validationMsg = msg),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'onValidation: ${_validationMsg == null ? context.tx('válido') : '"$_validationMsg"'}',
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfValidacao,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-cpf-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCPF(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    hintText: context.tx('CPF'),
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCPF(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    hintText: context.tx('CPF'),
                    filled: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description: 'clearButton=false remove o X do input.',
        preview:
            // #region sg-input-cpf-sem-limpar
            SizedBox(
              width: 320,
              child: SgInputCPF(
                id: 'demo-noclear',
                labelText: context.tx('Sem limpar'),
                hintText: context.tx('CPF'),
                clearButton: false,
              ),
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-cpf-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputCPF(
                  id: 'demo-w200',
                  labelText: context.tx('200px'),
                  hintText: context.tx('CPF'),
                  width: 200,
                ),
                SgInputCPF(
                  id: 'demo-w300',
                  labelText: context.tx('300px arredondado'),
                  hintText: context.tx('CPF'),
                  width: 300,
                  borderRadius: 20,
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'enabled=false desabilita.',
        preview:
            // #region sg-input-cpf-desabilitado
            SizedBox(
              width: 320,
              child: SgInputCPF(
                id: 'demo-disabled',
                labelText: context.tx('Desabilitado'),
                hintText: context.tx('CPF'),
                enabled: false,
                initialValue: '000.000.000-00',
              ),
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfDesabilitado,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description: 'onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-cpf-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCPF(
                    id: 'demo-events',
                    labelText: context.tx('Digite e observe o log'),
                    hintText: context.tx('CPF'),
                    required: true,
                    onChange: (v) => _log('onChange: "$v"'),
                    onEnter: () => _log(context.tx('onEnter (focus)')),
                    onExit: () => _log(context.tx('onExit (blur)')),
                    onClear: () => _log('onClear'),
                    onValidation: (msg) =>
                        _log('onValidation: ${msg ?? context.tx('válido')}'),
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
        code: SgInputCpfPageSnippets.sgInputCpfEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-cpf-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputCPF(
                    id: 'sg-input-cpf-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputCPFLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputCPF(
                    id: 'sg-input-cpf-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputCPFLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputCPF(
                    id: 'sg-input-cpf-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputCPFLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputCPFLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfPageSnippets.sgInputCpfRotulo,
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
        builder: (context, v) => SgInputCPF(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputCPFLabelPosition.fromValue(
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
