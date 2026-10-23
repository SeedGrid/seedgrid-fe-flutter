// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_number_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputNumberPageSnippets {
  /// Region `sg-input-number-afixos`.
  static const String sgInputNumberAfixos = r'''
const Column(
  children: [
    SgInputNumber(
      id: 'peso',
      labelText: 'Peso',
      labelPosition: SgInputNumberLabelPosition.top,
      suffixText: 'kg',
    ),
    SizedBox(height: 12),
    SgInputNumber(
      id: 'distancia',
      labelText: 'Distância',
      labelPosition: SgInputNumberLabelPosition.left,
      labelWidth: 110,
      suffixText: 'km',
      emptyValue: SgInputNumberEmptyValue.nullValue,
      hintText: 'digite',
    ),
  ],
)
''';

  /// Region `sg-input-number-basico`.
  static const String sgInputNumberBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputNumber(
      id: 'quantidade',
      labelText: 'Quantidade',
      onChange: (v) => setState(() => _valor = v),
    ),
    const SizedBox(height: 8),
    Text(
      'onChange: ${_valor.isEmpty ? '(nada digitado)' : _valor}',
    ),
  ],
)
''';

  /// Region `sg-input-number-decimais`.
  static const String sgInputNumberDecimais = r'''
const Column(
  children: [
    SgInputNumber(
      id: 'inteiro',
      labelText: 'Inteiro (decimals: 0)',
      decimals: 0,
    ),
    SizedBox(height: 12),
    SgInputNumber(
      id: 'tres',
      labelText: 'Três casas (decimals: 3)',
      decimals: 3,
    ),
    SizedBox(height: 12),
    SgInputNumber(
      id: 'positivo',
      labelText: 'Só positivo',
      allowNegative: false,
    ),
  ],
)
''';

  /// Region `sg-input-number-formulario`.
  static const String sgInputNumberFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputNumber(
      id: 'qtd',
      name: 'qtd',
      control: _form,
      labelText: 'Quantidade',
      emptyValue: SgInputNumberEmptyValue.nullValue,
      required: true,
      requiredMessage: 'Informe a quantidade',
      rules: SgRules(
        validate: (v) =>
            (num.tryParse('$v') ?? 0) >= 1 ? true : 'Mínimo 1',
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['qtd']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-input-number-validacao`.
  static const String sgInputNumberValidacao = r'''
const Column(
  children: [
    SgInputNumber(
      id: 'obrigatorio',
      labelText: 'Obrigatório',
      required: true,
    ),
    SizedBox(height: 12),
    SgInputNumber(
      id: 'faixa',
      labelText: 'Entre 10 e 20',
      minValue: 10,
      maxValue: 20,
    ),
    SizedBox(height: 12),
    SgInputNumber(
      id: 'mensagem',
      labelText: 'Mínimo 5',
      minValue: 5,
      minValueMessage: 'Muito pouco',
    ),
  ],
)
''';
}
