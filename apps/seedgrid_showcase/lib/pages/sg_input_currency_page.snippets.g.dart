// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_currency_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCurrencyPageSnippets {
  /// Region `sg-input-currency-basico`.
  static const String sgInputCurrencyBasico = r'''
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
          (values) => _enviado.value = '${values['valor']}',
        ),
      ),
      const SizedBox(height: 8),
      ValueListenableBuilder<String>(
        valueListenable: _enviado,
        builder: (context, enviado, _) =>
            Text('${context.tx('Valor')}: $enviado'),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-currency-botoes`.
  static const String sgInputCurrencyBotoes = r'''
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
          hint: context.tx('Digite algo e clique nos ícones...'),
          height: 96,
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-currency-controlado`.
  static const String sgInputCurrencyControlado = r'''
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
)
''';

  /// Region `sg-input-currency-eventos`.
  static const String sgInputCurrencyEventos = r'''
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
)
''';

  /// Region `sg-input-currency-largura`.
  static const String sgInputCurrencyLargura = r'''
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
)
''';

  /// Region `sg-input-currency-minmax`.
  static const String sgInputCurrencyMinmax = r'''
SizedBox(
  width: 320,
  child: SgInputCurrency(
    id: 'demo-minmax',
    currency: 'BRL',
    labelText: context.tx('Entre 10 e 100'),
    minValue: 10,
    maxValue: 100,
  ),
)
''';

  /// Region `sg-input-currency-moeda`.
  static const String sgInputCurrencyMoeda = r'''
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
)
''';

  /// Region `sg-input-currency-obrigatorio`.
  static const String sgInputCurrencyObrigatorio = r'''
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
)
''';

  /// Region `sg-input-currency-sem-decimais`.
  static const String sgInputCurrencySemDecimais = r'''
SizedBox(
  width: 320,
  child: SgInputCurrency(
    id: 'demo-no-decimals',
    currency: 'BRL',
    labelText: context.tx('Quantidade'),
    decimals: 0,
  ),
)
''';

  /// Region `sg-input-currency-sem-negativo`.
  static const String sgInputCurrencySemNegativo = r'''
SizedBox(
  width: 320,
  child: SgInputCurrency(
    id: 'demo-no-negative',
    currency: 'BRL',
    labelText: context.tx('Apenas positivo'),
    allowNegative: false,
  ),
)
''';

  /// Region `sg-input-currency-simbolo`.
  static const String sgInputCurrencySimbolo = r'''
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
)
''';

  /// Region `sg-input-currency-standalone`.
  static const String sgInputCurrencyStandalone = r'''
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
        onClick: () => _standaloneResult.value = jsonEncode({
          'a': _standalone['a'] ?? '',
          'b': _standalone['b'] ?? '',
          'c': _standalone['c'] ?? '',
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
)
''';

  /// Region `sg-input-currency-validacao`.
  static const String sgInputCurrencyValidacao = r'''
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
)
''';

  /// Region `sg-input-currency-variacoes`.
  static const String sgInputCurrencyVariacoes = r'''
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
)
''';

  /// Region `sg-input-currency-vazio`.
  static const String sgInputCurrencyVazio = r'''
SizedBox(
  width: 320,
  child: SgInputCurrency(
    id: 'demo-empty',
    currency: 'BRL',
    labelText: context.tx('Pode ficar vazio'),
    emptyValue: SgInputCurrencyEmptyValue.nullValue,
  ),
)
''';
}
