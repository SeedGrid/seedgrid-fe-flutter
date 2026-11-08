// Showcase do SgInputPostalCode. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_postal_code_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';

class SgInputPostalCodePage extends StatefulWidget {
  const SgInputPostalCodePage({super.key});

  @override
  State<SgInputPostalCodePage> createState() => _SgInputPostalCodePageState();
}

class _SgInputPostalCodePageState extends State<SgInputPostalCodePage> {
  final SgFormController _form = SgFormController(
    defaultValues: {'cep': '', 'controlled': ''},
  );
  final ValueNotifier<String?> _validationMsg = ValueNotifier(null);
  final ValueNotifier<SgViaCepResult?> _viaCepResult = ValueNotifier(null);
  final ValueNotifier<List<String>> _eventLog = ValueNotifier(const []);
  final ValueNotifier<List<String>> _iconLog = ValueNotifier(const []);
  final Map<String, String> _standalone = {};
  final ValueNotifier<String> _standaloneResult = ValueNotifier('');

  void _log(String entry) => _eventLog.value = [entry, ..._eventLog.value];

  @override
  void dispose() {
    _form.dispose();
    _validationMsg.dispose();
    _viaCepResult.dispose();
    _eventLog.dispose();
    _iconLog.dispose();
    _standaloneResult.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Código postal com label e hint (padrão: Brasil).',
        preview:
            // #region sg-input-postal-code-basico
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPostalCode(
                    id: 'demo-basic',
                    labelText: context.tx('CEP (Brasil)'),
                    hintText: '00000-000',
                    name: 'cep',
                    control: _form,
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: _form,
                    builder: (context, _) => Text(
                      '${context.tx('Valor')}: "${_form.getValue('cep') ?? ''}"',
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeBasico,
      ),
      ShowcaseExample(
        title: 'Países',
        description: 'Cada país tem máscara, tamanho e validação específicos.',
        preview:
            // #region sg-input-postal-code-paises
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                for (final (country, label, hint) in [
                  (
                    SgInputPostalCodeCountry.br,
                    context.tx('CEP (Brasil)'),
                    '00000-000',
                  ),
                  (
                    SgInputPostalCodeCountry.pt,
                    context.tx('Código postal (Portugal)'),
                    '0000-000',
                  ),
                  (
                    SgInputPostalCodeCountry.us,
                    context.tx('ZIP code (EUA)'),
                    '00000',
                  ),
                  (
                    SgInputPostalCodeCountry.es,
                    context.tx('Código postal (Espanha)'),
                    '00000',
                  ),
                  (
                    SgInputPostalCodeCountry.uy,
                    context.tx('Código postal (Uruguai)'),
                    '00000',
                  ),
                  (
                    SgInputPostalCodeCountry.ar,
                    context.tx('Código postal (Argentina)'),
                    'A0000AAA',
                  ),
                  (
                    SgInputPostalCodeCountry.py,
                    context.tx('Código postal (Paraguai)'),
                    '000000',
                  ),
                ])
                  SizedBox(
                    width: 280,
                    child: SgInputPostalCode(
                      id: 'demo-${country.name}',
                      country: country,
                      labelText: label,
                      hintText: hint,
                    ),
                  ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodePaises,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description: 'Valida se está vazio e mostra mensagem customizada.',
        preview:
            // #region sg-input-postal-code-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-required',
                    labelText: context.tx('Código postal obrigatório'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-required-custom',
                    labelText: context.tx('Mensagem customizada'),
                    hintText: context.tx('Obrigatório'),
                    required: true,
                    requiredMessage: context.tx('Informe o código postal.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeObrigatorio,
      ),
      ShowcaseExample(
        title: 'Controlado (setValue)',
        description:
            'Use quando precisa do valor em tempo real e de setValue externos.',
        preview:
            // #region sg-input-postal-code-controlado
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPostalCode(
                    id: 'demo-controlled',
                    labelText: context.tx('CEP do cliente'),
                    hintText: '00000-000',
                    name: 'controlled',
                    control: _form,
                  ),
                  const SizedBox(height: 12),
                  ListenableBuilder(
                    listenable: _form,
                    builder: (context, _) => Text(
                      '${context.tx('Estado atual')}: "${_form.getValue('controlled') ?? ''}"',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SgButton(
                        label: Text(context.tx('Setar via API')),
                        onClick: () =>
                            _form.setValue('controlled', '04538-132'),
                      ),
                      SgButton(
                        appearance: SgAppearance.outline,
                        label: Text(context.tx('Outro valor')),
                        onClick: () =>
                            _form.setValue('controlled', '20040-020'),
                      ),
                      SgButton(
                        appearance: SgAppearance.outline,
                        severity: SgSeverity.danger,
                        label: Text(context.tx('Limpar')),
                        onClick: () => _form.setValue('controlled', ''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeControlado,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem ou null.',
        preview:
            // #region sg-input-postal-code-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPostalCode(
                    id: 'demo-validation',
                    labelText: context.tx('CEP (Brasil)'),
                    hintText: '00000-000',
                    validation: (v) => v.startsWith('00')
                        ? context.tx('CEP não pode iniciar com 00.')
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
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeValidacao,
      ),
      ShowcaseExample(
        title: 'Validação ViaCEP (somente BR)',
        description:
            'Consulta ViaCEP para verificar se o CEP existe. Disponível apenas para country="BR".',
        preview:
            // #region sg-input-postal-code-viacep
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-viacep',
                    labelText: context.tx('CEP (Brasil)'),
                    hintText: '00000-000',
                    country: SgInputPostalCodeCountry.br,
                    validateWithViaCep: true,
                    viaCepErrorMessage: context.tx('CEP inválido.'),
                    onViaCepResult: (data) => _viaCepResult.value = data,
                  ),
                ),
                ValueListenableBuilder<SgViaCepResult?>(
                  valueListenable: _viaCepResult,
                  builder: (context, resultado, _) => resultado == null
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(context.tx('Resultado ViaCEP')),
                            SelectableText(
                              const JsonEncoder.withIndent('  ').convert({
                                'cep': resultado.cep,
                                'logradouro': resultado.logradouro,
                                'bairro': resultado.bairro,
                                'localidade': resultado.localidade,
                                'uf': resultado.uf,
                              }),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tx(
                    'Se a API estiver fora do ar, o componente não bloqueia o usuário.',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeViacep,
      ),
      ShowcaseExample(
        title: 'Ícone de prefixo',
        description: 'Ícone posicionado à esquerda do input.',
        preview:
            // #region sg-input-postal-code-icone
            SizedBox(
              width: 320,
              child: SgInputPostalCode(
                id: 'demo-prefix-icon',
                labelText: context.tx('Buscar CEP'),
                hintText: '00000-000',
                prefixIcon: const Icon(Icons.search, size: 16),
              ),
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeIcone,
      ),
      ShowcaseExample(
        title: 'Prefixo e sufixo',
        description: 'Prefixo/sufixo são apenas visuais.',
        preview:
            // #region sg-input-postal-code-afixos
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-prefix-text',
                    labelText: context.tx('Com prefixo'),
                    hintText: '00000-000',
                    prefixText: 'CEP:',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-suffix-text',
                    labelText: context.tx('Com sufixo'),
                    hintText: '00000-000',
                    suffixText: 'BR',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeAfixos,
      ),
      ShowcaseExample(
        title: 'Botões de ícone',
        description:
            'iconButtons recebe uma lista de botões; cada botão tem o onClick que você definir.',
        preview:
            // #region sg-input-postal-code-botoes
            SizedBox(
              width: 384,
              child: Column(
                children: [
                  SgInputPostalCode(
                    id: 'demo-iconbtns',
                    labelText: context.tx('Copiar CEP'),
                    hintText: '00000-000',
                    iconButtons: [
                      SgButton(
                        iconOnly: true,
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        leftIcon: const Icon(Icons.copy),
                        onClick: () => _iconLog.value = [
                          context.tx('Copiado'),
                          ..._iconLog.value,
                        ],
                      ),
                      SgButton(
                        iconOnly: true,
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        leftIcon: const Icon(Icons.notifications_outlined),
                        onClick: () => _iconLog.value = [
                          context.tx('Alerta disparado!'),
                          ..._iconLog.value,
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: _iconLog,
                    builder: (context, entries, _) => ShowcaseLogBox(
                      entries: entries,
                      hint: context.tx('Clique nos ícones para testar...'),
                      height: 96,
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeBotoes,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-postal-code-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    hintText: '00000-000',
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    hintText: '00000-000',
                    filled: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeVariacoes,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-postal-code-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputPostalCode(
                  id: 'demo-w200',
                  labelText: context.tx('200px'),
                  hintText: '00000-000',
                  width: 200,
                ),
                SgInputPostalCode(
                  id: 'demo-w300',
                  labelText: context.tx('300px arredondado'),
                  hintText: '00000-000',
                  width: 300,
                  borderRadius: 20,
                ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado e somente leitura',
        description: 'enabled=false desabilita, readOnly impede edição.',
        preview:
            // #region sg-input-postal-code-estados
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-disabled',
                    labelText: context.tx('Desabilitado'),
                    hintText: '00000-000',
                    enabled: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputPostalCode(
                    id: 'demo-readonly',
                    labelText: context.tx('Somente leitura'),
                    hintText: '00000-000',
                    readOnly: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeEstados,
      ),
      ShowcaseExample(
        title: 'Standalone (sem RHF)',
        description:
            'Sem controlador de formulário: cada campo avisa o valor em onChange.',
        preview:
            // #region sg-input-postal-code-standalone
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPostalCode(
                    id: 'standalone-a',
                    labelText: context.tx('CEP de entrega'),
                    hintText: '00000-000',
                    onChange: (v) => _standalone['entrega'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgInputPostalCode(
                    id: 'standalone-b',
                    labelText: context.tx('CEP de cobrança'),
                    hintText: '00000-000',
                    onChange: (v) => _standalone['cobranca'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgInputPostalCode(
                    id: 'standalone-c',
                    labelText: context.tx('CEP comercial'),
                    hintText: '00000-000',
                    onChange: (v) => _standalone['comercial'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgButton(
                    label: Text(context.tx('Salvar')),
                    onClick: () => _standaloneResult.value = jsonEncode({
                      'entrega': _standalone['entrega'] ?? '',
                      'cobranca': _standalone['cobranca'] ?? '',
                      'comercial': _standalone['comercial'] ?? '',
                    }),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: _standaloneResult,
                    builder: (context, resultado, _) => Text(
                      '${context.tx('Resultado')}: ${resultado.isEmpty ? '-' : resultado}',
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeStandalone,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description: 'onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-postal-code-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputPostalCode(
                    id: 'demo-events',
                    labelText: context.tx('Com eventos'),
                    hintText: '00000-000',
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
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-postal-code-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputPostalCode(
                    id: 'sg-input-postal-code-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputPostalCodeLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputPostalCode(
                    id: 'sg-input-postal-code-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputPostalCodeLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputPostalCode(
                    id: 'sg-input-postal-code-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputPostalCodeLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputPostalCodeLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeRotulo,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description: 'clearButton=false remove o X do input.',
        preview:
            // #region sg-input-postal-code-sem-limpar
            SizedBox(
              width: 320,
              child: SgInputPostalCode(
                id: 'demo-noclear',
                labelText: context.tx('Sem limpar'),
                hintText: '00000-000',
                clearButton: false,
              ),
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeSemLimpar,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputPostalCode',
      description:
          'Código postal por país (BR, PT, US, ES, UY, AR, PY) com máscara e consulta opcional ao ViaCEP.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputPostalCode']!,
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
        specs: sgPropSpecs['SgInputPostalCode']!
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
                'country',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputPostalCode(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputPostalCodeLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          country: SgInputPostalCodeCountry.fromValue(v['country'] as String?),
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
                'labelPosition: SgInputPostalCodeLabelPosition.${SgInputPostalCodeLabelPosition.fromValue(e.value as String)!.name}',
              'country' =>
                'country: SgInputPostalCodeCountry.${SgInputPostalCodeCountry.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputPostalCode(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
