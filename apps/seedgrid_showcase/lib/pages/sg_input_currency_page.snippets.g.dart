// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_currency_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCurrencyPageSnippets {
  /// Region `sg-input-currency-basico`.
  static const String sgInputCurrencyBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputCurrency(
      id: 'preco',
      labelText: 'Preço',
      onChange: (v) => setState(() => _valor = v),
    ),
    const SizedBox(height: 8),
    Text(
      'onChange: ${_valor.isEmpty ? '(nada digitado)' : _valor}',
    ),
  ],
)
''';

  /// Region `sg-input-currency-formulario`.
  static const String sgInputCurrencyFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputCurrency(
      id: 'preco-form',
      name: 'preco',
      control: _form,
      labelText: 'Preço',
      emptyValue: SgInputCurrencyEmptyValue.nullValue,
      required: true,
      requiredMessage: 'Informe o preço',
      rules: SgRules(
        validate: (v) =>
            (num.tryParse('$v') ?? 0) > 0 ? true : 'Maior que zero',
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['preco']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-input-currency-moedas`.
  static const String sgInputCurrencyMoedas = r'''
const Column(
  children: [
    SgInputCurrency(
      id: 'usd',
      labelText: 'Dólar (en-US)',
      currency: 'USD',
      locale: 'en-US',
      initialValue: '1234.5',
    ),
    SizedBox(height: 12),
    SgInputCurrency(
      id: 'eur',
      labelText: 'Euro (fr)',
      currency: 'EUR',
      locale: 'fr',
      initialValue: '1234.5',
    ),
    SizedBox(height: 12),
    SgInputCurrency(
      id: 'jpy',
      labelText: 'Iene (sem casas)',
      currency: 'JPY',
      initialValue: '1234',
    ),
  ],
)
''';

  /// Region `sg-input-currency-simbolo`.
  static const String sgInputCurrencySimbolo = r'''
const Column(
  children: [
    SgInputCurrency(
      id: 'codigo',
      labelText: 'Código no fim',
      currencyDisplay: SgInputCurrencyCurrencyDisplay.code,
      currencySymbolPlacement:
          SgInputCurrencyCurrencySymbolPlacement.suffix,
      initialValue: '1234.5',
    ),
    SizedBox(height: 12),
    SgInputCurrency(
      id: 'pontos',
      labelText: 'Símbolo próprio',
      currencySymbolOverride: 'pts',
      initialValue: '10',
    ),
    SizedBox(height: 12),
    SgInputCurrency(
      id: 'semsimbolo',
      labelText: 'Sem símbolo nem milhar',
      showCurrencySymbol: false,
      useGrouping: false,
      initialValue: '1234567.8',
    ),
  ],
)
''';

  /// Region `sg-input-currency-validacao`.
  static const String sgInputCurrencyValidacao = r'''
const Column(
  children: [
    SgInputCurrency(
      id: 'obrigatorio',
      labelText: 'Obrigatório',
      required: true,
    ),
    SizedBox(height: 12),
    SgInputCurrency(
      id: 'faixa',
      labelText: 'Entre 10 e 500',
      minValue: 10,
      maxValue: 500,
      maxValueMessage: 'Acima do limite',
    ),
  ],
)
''';
}
