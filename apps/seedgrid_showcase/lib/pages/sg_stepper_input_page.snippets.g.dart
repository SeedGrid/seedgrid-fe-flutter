// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_stepper_input_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgStepperInputPageSnippets {
  /// Region `sg-stepper-input-basico`.
  static const String sgStepperInputBasico = r'''
const SgStepperInput(
  id: 'basico',
  minValue: 0,
  maxValue: 10,
  defaultValue: 3,
  width: 160,
)
''';

  /// Region `sg-stepper-input-controlado`.
  static const String sgStepperInputControlado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgStepperInput(
      id: 'controlado',
      minValue: 1,
      maxValue: 9,
      value: _quantidade,
      onChange: (v) => setState(() => _quantidade = v),
      ariaLabel: 'Quantidade de itens',
      width: 160,
    ),
    const SizedBox(height: 8),
    Text('Quantidade: $_quantidade'),
  ],
)
''';

  /// Region `sg-stepper-input-estados`.
  static const String sgStepperInputEstados = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgStepperInput(
      id: 'desabilitado',
      minValue: 0,
      maxValue: 10,
      defaultValue: 4,
      disabled: true,
      width: 160,
    ),
    SizedBox(height: 12),
    SgStepperInput(
      id: 'leitura',
      minValue: 0,
      maxValue: 10,
      defaultValue: 4,
      readOnly: true,
      width: 160,
    ),
    SizedBox(height: 12),
    SgStepperInput(
      id: 'erro',
      minValue: 0,
      maxValue: 10,
      error: 'Escolha ao menos 1',
      width: 200,
    ),
  ],
)
''';

  /// Region `sg-stepper-input-formulario`.
  static const String sgStepperInputFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgStepperInput(
      id: 'qtd',
      name: 'qtd',
      control: _form,
      minValue: 0,
      maxValue: 9,
      width: 160,
      rules: SgRules(
        validate: (v) => (v as num) >= 2 ? true : 'Mínimo 2',
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

  /// Region `sg-stepper-input-passo`.
  static const String sgStepperInputPasso = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgStepperInput(
      id: 'de-cinco',
      minValue: 0,
      maxValue: 50,
      step: 5,
      width: 160,
    ),
    SizedBox(height: 12),
    SgStepperInput(
      id: 'meio',
      minValue: 0,
      maxValue: 5,
      step: 0.5,
      defaultValue: 2.5,
      width: 160,
    ),
  ],
)
''';
}
