// Showcase do SgInputCurrency. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';
import 'sg_input_currency_page.snippets.g.dart';

class SgInputCurrencyPage extends StatefulWidget {
  const SgInputCurrencyPage({super.key});

  @override
  State<SgInputCurrencyPage> createState() => _SgInputCurrencyPageState();
}

class _SgInputCurrencyPageState extends State<SgInputCurrencyPage> {
  final SgFormController _form = SgFormController(
    defaultValues: {
      'valor': '',
      'controlled': '',
      'prefix': '',
      'suffix': '',
      'both': '',
    },
  );
  String _enviado = '';
  String? _validationMsg;
  final List<String> _eventLog = [];
  final List<String> _iconLog = [];
  final Map<String, String> _standalone = {};
  String _standaloneResult = '';

  void _log(String entry) => setState(() => _eventLog.insert(0, entry));

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
            'Campo ligado a um formulário (SgFormController): name + control; o valor sai no envio.',
        preview:
            // #region sg-input-currency-basico
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCurrency(
                    id: 'demo-basic',
                    currency: 'BRL',
                    labelText: context.tx('Valor'),
                    name: 'valor',
                    control: _form,
                  ),
                  const SizedBox(height: 8),
                  SgButton(
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                    label: Text(context.tx('Enviar')),
                    onClick: () => _form.handleSubmit(
                      (values) =>
                          setState(() => _enviado = '${values['valor']}'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${context.tx('Valor')}: $_enviado'),
                ],
              ),
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description:
            'Valida ao perder o foco (validateOnBlur=true por padrão).',
        preview:
            // #region sg-input-currency-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-required',
                    currency: 'BRL',
                    labelText: context.tx('Campo obrigatório'),
                    required: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-required-custom',
                    currency: 'BRL',
                    labelText: context.tx('Mensagem customizada'),
                    required: true,
                    requiredMessage: context.tx('Informe um valor.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyObrigatorio,
      ),
      ShowcaseExample(
        title: 'Controlado',
        description:
            'Use quando precisa do valor em tempo real e de setValue externos.',
        preview:
            // #region sg-input-currency-controlado
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCurrency(
                    id: 'demo-controlled',
                    currency: 'BRL',
                    labelText: context.tx('Valor controlado'),
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
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        label: Text(context.tx('Setar via API')),
                        onClick: () => _form.setValue('controlled', '12345.00'),
                      ),
                      SgButton(
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        label: Text(context.tx('Resetar')),
                        onClick: () => _form.setValue('controlled', '0.00'),
                      ),
                      SgButton(
                        size: SgSize.sm,
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
        code: SgInputCurrencyPageSnippets.sgInputCurrencyControlado,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem ou null.',
        preview:
            // #region sg-input-currency-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCurrency(
                    id: 'demo-validation',
                    labelText: context.tx('Valor mínimo (>= 1000)'),
                    currency: 'BRL',
                    validation: (v) {
                      final n = num.tryParse(v);
                      return n != null && n >= 1000
                          ? null
                          : context.tx('Valor deve ser ≥ 1000.');
                    },
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
        code: SgInputCurrencyPageSnippets.sgInputCurrencyValidacao,
      ),
      ShowcaseExample(
        title: 'Moeda e locale',
        description: 'O display muda conforme currency + locale.',
        preview:
            // #region sg-input-currency-moeda
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-brl',
                    labelText: context.tx('Preço (BRL)'),
                    currency: 'BRL',
                    locale: 'pt-BR',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-usd',
                    labelText: context.tx('Price (USD)'),
                    currency: 'USD',
                    locale: 'en-US',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-eur',
                    labelText: context.tx('Preço (EUR)'),
                    currency: 'EUR',
                    locale: 'pt-PT',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyMoeda,
      ),
      ShowcaseExample(
        title: 'Símbolo e posicionamento',
        description: 'Mostre/oculte símbolo e altere o posicionamento.',
        preview:
            // #region sg-input-currency-simbolo
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-no-symbol',
                    labelText: context.tx('Sem símbolo'),
                    currency: 'BRL',
                    showCurrencySymbol: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-code',
                    labelText: context.tx('USD no sufixo'),
                    currency: 'USD',
                    currencyDisplay: SgInputCurrencyCurrencyDisplay.code,
                    currencySymbolPlacement:
                        SgInputCurrencyCurrencySymbolPlacement.suffix,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencySimbolo,
      ),
      ShowcaseExample(
        title: 'Botões de ícone',
        description: 'iconButtons recebe uma lista de widgets.',
        preview:
            // #region sg-input-currency-botoes
            SizedBox(
              width: 384,
              child: Column(
                children: [
                  SgInputCurrency(
                    id: 'demo-iconbtns',
                    currency: 'BRL',
                    labelText: context.tx('Valor para copiar'),
                    iconButtons: [
                      SgButton(
                        iconOnly: true,
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        leftIcon: const Icon(Icons.copy),
                        onClick: () => setState(
                          () => _iconLog.insert(0, context.tx('Copiado')),
                        ),
                      ),
                      SgButton(
                        iconOnly: true,
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        leftIcon: const Icon(Icons.notifications_outlined),
                        onClick: () => setState(
                          () => _iconLog.insert(
                            0,
                            context.tx('Alerta disparado!'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ShowcaseLogBox(
                    entries: _iconLog,
                    hint: context.tx('Digite algo e clique nos ícones...'),
                    height: 96,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyBotoes,
      ),
      ShowcaseExample(
        title: 'Sem negativo',
        description: 'Bloqueia o sinal de menos.',
        preview:
            // #region sg-input-currency-sem-negativo
            SizedBox(
              width: 320,
              child: SgInputCurrency(
                id: 'demo-no-negative',
                currency: 'BRL',
                labelText: context.tx('Apenas positivo'),
                allowNegative: false,
              ),
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencySemNegativo,
      ),
      ShowcaseExample(
        title: 'Sem decimais',
        description: 'decimals=0 (apenas inteiro com separador de milhar).',
        preview:
            // #region sg-input-currency-sem-decimais
            SizedBox(
              width: 320,
              child: SgInputCurrency(
                id: 'demo-no-decimals',
                currency: 'BRL',
                labelText: context.tx('Quantidade'),
                decimals: 0,
              ),
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencySemDecimais,
      ),
      ShowcaseExample(
        title: 'Min/Max',
        description: 'Valida intervalo numérico.',
        preview:
            // #region sg-input-currency-minmax
            SizedBox(
              width: 320,
              child: SgInputCurrency(
                id: 'demo-minmax',
                currency: 'BRL',
                labelText: context.tx('Entre 10 e 100'),
                minValue: 10,
                maxValue: 100,
              ),
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyMinmax,
      ),
      ShowcaseExample(
        title: 'Valor vazio',
        description: 'emptyValue="null" permite limpar totalmente.',
        preview:
            // #region sg-input-currency-vazio
            SizedBox(
              width: 320,
              child: SgInputCurrency(
                id: 'demo-empty',
                currency: 'BRL',
                labelText: context.tx('Pode ficar vazio'),
                emptyValue: SgInputCurrencyEmptyValue.nullValue,
              ),
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyVazio,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-currency-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-noborder',
                    currency: 'BRL',
                    labelText: context.tx('Sem borda'),
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputCurrency(
                    id: 'demo-filled',
                    currency: 'BRL',
                    labelText: context.tx('Preenchido'),
                    filled: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyVariacoes,
      ),
      ShowcaseExample(
        title: 'Standalone (form completo)',
        description:
            'Exemplo 100% standalone com default no load e botão salvar.',
        preview:
            // #region sg-input-currency-standalone
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCurrency(
                    id: 'standalone-a',
                    currency: 'BRL',
                    labelText: context.tx('Entrada 1'),
                    onChange: (v) => _standalone['a'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgInputCurrency(
                    id: 'standalone-b',
                    currency: 'BRL',
                    labelText: context.tx('Entrada 2'),
                    onChange: (v) => _standalone['b'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgInputCurrency(
                    id: 'standalone-c',
                    currency: 'BRL',
                    labelText: context.tx('Entrada 3'),
                    onChange: (v) => _standalone['c'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgButton(
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                    label: Text(context.tx('Salvar')),
                    onClick: () => setState(
                      () => _standaloneResult = jsonEncode({
                        'a': _standalone['a'] ?? '',
                        'b': _standalone['b'] ?? '',
                        'c': _standalone['c'] ?? '',
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${context.tx('Resultado')}: ${_standaloneResult.isEmpty ? '-' : _standaloneResult}',
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyStandalone,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description:
            'Exemplo sem formulário com onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-currency-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputCurrency(
                    id: 'demo-events',
                    currency: 'BRL',
                    labelText: context.tx('Digite e observe o log'),
                    required: true,
                    onChange: (v) => _log('onChange: $v'),
                    onEnter: () => _log('onEnter (focus)'),
                    onExit: () => _log('onExit (blur)'),
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
        code: SgInputCurrencyPageSnippets.sgInputCurrencyEventos,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-currency-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputCurrency(
                  id: 'demo-w200',
                  currency: 'BRL',
                  labelText: context.tx('200px'),
                  width: 200,
                ),
                SgInputCurrency(
                  id: 'demo-w300',
                  currency: 'BRL',
                  labelText: context.tx('300px arredondado'),
                  width: 300,
                  borderRadius: 20,
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyLargura,
      ),
    ];

    // currencyDisplay e currencySymbolPlacement ficam de fora: o dropdown do SgPlayground (arquivo
    // compartilhado, sem isExpanded) estoura 1,8 px com esses rotulos longos; os dois estao nos exemplos.
    const playgroundProps = {
      'emptyValue',
      'allowNegative',
      'enabled',
      'readOnly',
      'required',
      'filled',
      'withBorder',
      'clearButton',
      'showCurrencySymbol',
      'useGrouping',
      'currency',
      'locale',
    };
    return SgShowcasePage(
      name: 'SgInputCurrency',
      description:
          'Campo de moeda com símbolo, posição e separadores do idioma (Intl), casas da moeda, limites e ligação a formulário.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputCurrency']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'inputProps.defaultValue',
          type: 'Object?',
          tsType: 'string | number',
          required: false,
          description: 'Valor inicial sem formulário ("1234.56").',
          exact: false,
        ),
        const SgPropSpec(
          name: 'value',
          reactName: 'inputProps.value',
          type: 'Object?',
          tsType: 'string | number',
          required: false,
          description: 'Valor controlado de fora; mudar atualiza o campo.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputCurrency']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => SgInputCurrency(
          key: ValueKey(
            'pg-${v['emptyValue']}-${v['currency']}-${v['locale']}',
          ),
          id: 'pg',
          labelText: 'Valor',
          currency: v['currency'] as String?,
          locale: v['locale'] as String?,
          currencyDisplay: SgInputCurrencyCurrencyDisplay.fromValue(
            v['currencyDisplay'] as String?,
          ),
          currencySymbolPlacement:
              SgInputCurrencyCurrencySymbolPlacement.fromValue(
                v['currencySymbolPlacement'] as String?,
              ),
          emptyValue: SgInputCurrencyEmptyValue.fromValue(
            v['emptyValue'] as String?,
          ),
          allowNegative: v['allowNegative'] as bool?,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          filled: v['filled'] as bool?,
          withBorder: v['withBorder'] as bool?,
          clearButton: v['clearButton'] as bool?,
          showCurrencySymbol: v['showCurrencySymbol'] as bool?,
          useGrouping: v['useGrouping'] as bool?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Valor'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'currencyDisplay' =>
                'currencyDisplay: SgInputCurrencyCurrencyDisplay.${SgInputCurrencyCurrencyDisplay.fromValue(e.value as String)!.name}',
              'currencySymbolPlacement' =>
                'currencySymbolPlacement: SgInputCurrencyCurrencySymbolPlacement.${SgInputCurrencyCurrencySymbolPlacement.fromValue(e.value as String)!.name}',
              'emptyValue' =>
                'emptyValue: SgInputCurrencyEmptyValue.${SgInputCurrencyEmptyValue.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputCurrency(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
