// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_date_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputDatePageSnippets {
  /// Region `sg-input-date-basico`.
  static const String sgInputDateBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputDate(
      id: 'demo-basic',
      labelText: context.tx('Data'),
      hintText: context.tx('Selecione uma data'),
      onChange: (value) => _valor.value = value,
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<String>(
      valueListenable: _valor,
      builder: (context, valor, _) =>
          Text(context.txf('Valor: {valor}', {'valor': valor})),
    ),
  ],
)
''';

  /// Region `sg-input-date-formulario`.
  static const String sgInputDateFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputDate(
      id: 'campo',
      name: 'campo',
      control: _form,
      labelText: context.tx('Data'),
      required: true,
      requiredMessage: context.tx('Escolha uma data'),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = '${values['campo']}',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, enviado, _) => enviado.isEmpty
          ? const SizedBox.shrink()
          : Text(
              context.txf('Enviado: {valor}', {'valor': enviado}),
            ),
    ),
  ],
)
''';

  /// Region `sg-input-date-limites`.
  static const String sgInputDateLimites = r'''
SgInputDate(
  id: 'demo-range',
  labelText: context.tx('Período'),
  minDate: '2020-01-01',
  maxDate: '2030-12-31',
)
''';

  /// Region `sg-input-date-obrigatorio`.
  static const String sgInputDateObrigatorio = r'''
SgInputDate(
  id: 'demo-required',
  labelText: context.tx('Data da consulta'),
  required: true,
  requiredMessage: context.tx('Escolha uma data'),
)
''';

  /// Region `sg-input-date-rotulo`.
  static const String sgInputDateRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputDate(
        id: 'sg-input-date-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputDateLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputDate(
        id: 'sg-input-date-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputDateLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputDate(
        id: 'sg-input-date-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputDateLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputDateLabelAlign.end,
      ),
    ),
  ],
)
''';
}
