// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_date_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputDatePageSnippets {
  /// Region `sg-input-date-basico`.
  static const String sgInputDateBasico = r'''
const SgInputDate(id: 'data', labelText: 'Data')
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
      labelText: 'Campo',
      rules: const SgRules(required: 'Preencha o campo'),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['campo']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-input-date-limites`.
  static const String sgInputDateLimites = r'''
const SgInputDate(
  id: 'data-limites',
  labelText: 'Dentro de 2026',
  minDate: '2026-01-01',
  maxDate: '2026-12-31',
  initialValue: '2026-06-15',
)
''';

  /// Region `sg-input-date-obrigatorio`.
  static const String sgInputDateObrigatorio = r'''
const SgInputDate(
  id: 'data-obrigatoria',
  labelText: 'Data da consulta',
  required: true,
  requiredMessage: 'Escolha uma data',
)
''';
}
