// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_slider_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSliderPageSnippets {
  /// Region `sg-slider-basico`.
  static const String sgSliderBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgSlider(
      id: 'volume',
      minValue: 0,
      maxValue: 100,
      defaultValue: 30,
      ariaLabel: 'Volume',
      onChange: (v) => setState(() => _volume = v),
    ),
    Text('Volume: $_volume'),
  ],
)
''';

  /// Region `sg-slider-estados`.
  static const String sgSliderEstados = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgSlider(
      id: 'largura',
      minValue: 0,
      maxValue: 10,
      defaultValue: 4,
      width: '50%',
    ),
    SgSlider(
      id: 'off',
      minValue: 0,
      maxValue: 10,
      defaultValue: 7,
      disabled: true,
    ),
    SgSlider(
      id: 'erro',
      minValue: 0,
      maxValue: 10,
      defaultValue: 9,
      error: 'Valor alto demais',
    ),
  ],
)
''';

  /// Region `sg-slider-formulario`.
  static const String sgSliderFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgSlider(
      id: 'brilho',
      name: 'brilho',
      control: _form,
      minValue: 0,
      maxValue: 100,
      step: 10,
      rules: const SgRules(
        min: SgRuleValue(20, 'Brilho mínimo: 20'),
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) =>
            setState(() => _enviado = '${values['brilho']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-slider-passo`.
  static const String sgSliderPasso = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgSlider(
      id: 'passo',
      minValue: 0,
      maxValue: 100,
      step: 25,
      defaultValue: 50,
      onChange: (v) => setState(() => _passo = v),
    ),
    Text('Valor: $_passo'),
  ],
)
''';
}
