// Showcase do SgInputCPFCNPJ. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_cpfcnpj_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';

class SgInputCPFCNPJPage extends StatefulWidget {
  const SgInputCPFCNPJPage({super.key});

  @override
  State<SgInputCPFCNPJPage> createState() => _SgInputCPFCNPJPageState();
}

class _SgInputCPFCNPJPageState extends State<SgInputCPFCNPJPage> {
  final ValueNotifier<String> _basico = ValueNotifier('');
  final ValueNotifier<String?> _validationMsg = ValueNotifier(null);
  final ValueNotifier<List<String>> _eventLog = ValueNotifier(const []);
  final ValueNotifier<Object?> _publicaResultado = ValueNotifier(null);
  final ValueNotifier<String?> _publicaErro = ValueNotifier(null);

  void _log(String entry) => _eventLog.value = [entry, ..._eventLog.value];

  @override
  void dispose() {
    _basico.dispose();
    _validationMsg.dispose();
    _eventLog.dispose();
    _publicaResultado.dispose();
    _publicaErro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'CPF/CNPJ com label e hint.',
        preview:
            // #region sg-input-cpf-cnpj-basico
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCPFCNPJ(
                    id: 'demo-basic',
                    labelText: context.tx('Documento'),
                    hintText: context.tx('CPF ou CNPJ'),
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
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description: 'Valida se está vazio e mostra mensagem customizada.',
        preview:
            // #region sg-input-cpf-cnpj-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCPFCNPJ(
                    id: 'demo-required',
                    labelText: context.tx('Documento obrigatório'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCPFCNPJ(
                    id: 'demo-required-custom',
                    labelText: context.tx('Mensagem customizada'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                    requiredMessage: context.tx('Informe o CPF/CNPJ.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjObrigatorio,
      ),
      ShowcaseExample(
        title: 'Mensagem inválida',
        description: 'Personaliza mensagem de documento inválido.',
        preview:
            // #region sg-input-cpf-cnpj-invalida
            SizedBox(
              width: 320,
              child: SgInputCPFCNPJ(
                id: 'demo-invalid',
                labelText: context.tx('Documento'),
                hintText: context.tx('CPF ou CNPJ'),
                invalidMessage: context.tx('Documento inválido.'),
              ),
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjInvalida,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem ou null.',
        preview:
            // #region sg-input-cpf-cnpj-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCPFCNPJ(
                    id: 'demo-validation',
                    labelText: context.tx('Documento'),
                    hintText: context.tx('CPF ou CNPJ'),
                    validation: (v) => v.startsWith('00')
                        ? context.tx('Documento não pode iniciar com 00.')
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
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjValidacao,
      ),
      ShowcaseExample(
        title: 'Exemplo CNPJ alfanumérico',
        description: 'Aceita letras (A-Z) no corpo do CNPJ.',
        preview:
            // #region sg-input-cpf-cnpj-alfanumerico
            SizedBox(
              width: 320,
              child: SgInputCPFCNPJ(
                id: 'demo-alnum',
                labelText: context.tx('CNPJ alfanumérico'),
                hintText: '00.000.000/E08G-12',
                initialValue: '00.000.000/E08G-12',
              ),
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjAlfanumerico,
      ),
      ShowcaseExample(
        title: 'Exemplos válidos (alfanumérico)',
        description: 'Lista de CNPJs alfanuméricos válidos.',
        preview:
            // #region sg-input-cpf-cnpj-lista-alfanumerica
            const SelectableText(
              '// Exemplos válidos\n'
              '00.000.000/E08G-12  (raw: 00000000E08G12)\n'
              'GK.IPC.PIK/0001-52  (raw: GKIPCPIK000152)\n'
              'AB.12C.345/D6E7-99  (raw: AB12C345D6E799)\n'
              '12.ABC.345/DE67-34  (raw: 12ABC345DE6734)\n'
              'A1.B2C.3D4/E5F6-68  (raw: A1B2C3D4E5F668)\n'
              'ZX.CVB.NM1/2345-84  (raw: ZXCVBNM1234584)',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjListaAlfanumerica,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-cpf-cnpj-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCPFCNPJ(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    hintText: context.tx('Documento'),
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCPFCNPJ(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    hintText: context.tx('Documento'),
                    filled: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description: 'clearButton=false remove o X do input.',
        preview:
            // #region sg-input-cpf-cnpj-sem-limpar
            SizedBox(
              width: 320,
              child: SgInputCPFCNPJ(
                id: 'demo-noclear',
                labelText: context.tx('Sem limpar'),
                hintText: context.tx('Documento'),
                clearButton: false,
              ),
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-cpf-cnpj-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputCPFCNPJ(
                  id: 'demo-w200',
                  labelText: context.tx('200px'),
                  hintText: context.tx('Documento'),
                  width: 200,
                ),
                SgInputCPFCNPJ(
                  id: 'demo-w300',
                  labelText: context.tx('300px arredondado'),
                  hintText: context.tx('Documento'),
                  width: 300,
                  borderRadius: 20,
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'enabled=false desabilita.',
        preview:
            // #region sg-input-cpf-cnpj-desabilitado
            SizedBox(
              width: 320,
              child: SgInputCPFCNPJ(
                id: 'demo-disabled',
                labelText: context.tx('Desabilitado'),
                hintText: context.tx('Documento'),
                enabled: false,
                initialValue: '00.000.000/0000-00',
              ),
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjDesabilitado,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description: 'onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-cpf-cnpj-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCPFCNPJ(
                    id: 'demo-events',
                    labelText: context.tx('Digite e observe o log'),
                    hintText: context.tx('Documento'),
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
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-cpf-cnpj-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputCPFCNPJ(
                    id: 'sg-input-cpf-cnpj-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputCPFCNPJLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputCPFCNPJ(
                    id: 'sg-input-cpf-cnpj-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputCPFCNPJLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputCPFCNPJ(
                    id: 'sg-input-cpf-cnpj-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputCPFCNPJLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputCPFCNPJLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjRotulo,
      ),
      ShowcaseExample(
        title: 'Consulta na base pública',
        description:
            'Quando o documento é um CNPJ numérico válido, consulta publica.cnpj.ws para confirmar que ele existe.',
        preview:
            // #region sg-input-cpf-cnpj-consulta
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCPFCNPJ(
                    id: 'demo-publica',
                    labelText: context.tx('Documento'),
                    hintText: context.tx('CPF ou CNPJ'),
                    validateWithPublicaCnpj: true,
                    publicaCnpjErrorMessage: context.tx('CNPJ não encontrado.'),
                    onPublicaCnpjResult: (data) {
                      _publicaResultado.value = data;
                      _publicaErro.value = null;
                    },
                    onPublicaCnpjError: (_) => _publicaErro.value = context.tx(
                      'Falha ao consultar a API.',
                    ),
                  ),
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _publicaResultado,
                    _publicaErro,
                  ]),
                  builder: (context, _) {
                    final resultado = _publicaResultado.value;
                    final erro = _publicaErro.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (resultado != null) ...[
                          const SizedBox(height: 8),
                          Text(context.tx('Resultado da consulta')),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 240),
                            child: SingleChildScrollView(
                              child: SelectableText(
                                const JsonEncoder.withIndent(
                                  '  ',
                                ).convert(resultado),
                              ),
                            ),
                          ),
                        ],
                        if (erro != null) Text(erro),
                      ],
                    );
                  },
                ),
              ],
            ),
        // #endregion
        code: SgInputCpfcnpjPageSnippets.sgInputCpfCnpjConsulta,
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
        builder: (context, v) => SgInputCPFCNPJ(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputCPFCNPJLabelPosition.fromValue(
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
