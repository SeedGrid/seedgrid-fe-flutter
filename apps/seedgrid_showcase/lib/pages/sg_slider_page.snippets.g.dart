// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_slider_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSliderPageSnippets {
  /// Region `sg-slider-aria-desabilitado`.
  static const String sgSliderAriaDesabilitado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgSlider(
      id: 'slider-aria',
      minValue: 0,
      maxValue: 100,
      defaultValue: 40,
      width: '20rem',
      ariaLabel: context.tx('Nível de prioridade'),
    ),
    SgSlider(
      id: 'slider-disabled',
      minValue: 0,
      maxValue: 100,
      defaultValue: 65,
      enabled: false,
      width: '20rem',
      ariaLabel: context.tx('Slider desabilitado'),
    ),
  ],
)
''';

  /// Region `sg-slider-basico`.
  static const String sgSliderBasico = r'''
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 384),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgSlider(
        id: 'slider-basic',
        minValue: 0,
        maxValue: 100,
        defaultValue: 50,
        onChange: (v) => _basico.value = v,
      ),
      ValueListenableBuilder<num>(
        valueListenable: _basico,
        builder: (context, valor, _) =>
            Text('${context.tx('Valor atual')}: $valor'),
      ),
    ],
  ),
)
''';

  /// Region `sg-slider-controle-externo`.
  static const String sgSliderControleExterno = r'''
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 384),
  child: ValueListenableBuilder<num>(
    valueListenable: _controlado,
    builder: (context, valor, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgSlider(
          id: 'slider-controlled',
          minValue: 0,
          maxValue: 100,
          value: valor,
          onChange: (v) => _controlado.value = v,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              label: Text(context.tx('Mín')),
              onClick: () => _controlado.value = 0,
            ),
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              label: Text(context.tx('Meio')),
              onClick: () => _controlado.value = 50,
            ),
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              label: Text(context.tx('Máx')),
              onClick: () => _controlado.value = 100,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('${context.tx('Valor controlado')}: $valor'),
      ],
    ),
  ),
)
''';

  /// Region `sg-slider-erro`.
  static const String sgSliderErro = r'''
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 384),
  child: SgSlider(
    id: 'slider-error',
    minValue: 0,
    maxValue: 10,
    defaultValue: 9,
    error: context.tx('Valor alto demais'),
  ),
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
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = '${values['brilho']}',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, enviado, _) => enviado.isEmpty
          ? const SizedBox()
          : Text('Enviado: $enviado'),
    ),
  ],
)
''';

  /// Region `sg-slider-passo-largura`.
  static const String sgSliderPassoLargura = r'''
ValueListenableBuilder<num>(
  valueListenable: _passo,
  builder: (context, valor, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgSlider(
        id: 'slider-step-width-number',
        minValue: 0,
        maxValue: 60,
        step: 5,
        width: 320,
        value: valor,
        onChange: (v) => _passo.value = v,
      ),
      const SgSlider(
        id: 'slider-step-width-string',
        minValue: -20,
        maxValue: 20,
        step: 2,
        width: '18rem',
        defaultValue: 4,
      ),
      Text('${context.tx('Valor com step 5')}: $valor'),
    ],
  ),
)
''';
}
