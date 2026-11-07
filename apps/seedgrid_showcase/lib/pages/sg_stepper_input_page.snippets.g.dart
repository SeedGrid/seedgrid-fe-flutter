// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_stepper_input_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgStepperInputPageSnippets {
  /// Region `sg-stepper-input-basico`.
  static const String sgStepperInputBasico = r'''
SgStack(
  gap: 8,
  align: SgStackAlign.start,
  children: [
    SgStepperInput(
      id: 'stepper-basic',
      minValue: 0,
      maxValue: 40,
      step: 2,
      defaultValue: 12,
      width: 210,
      onChange: (v) => _atual.value = v,
    ),
    ValueListenableBuilder<num>(
      valueListenable: _atual,
      builder: (context, v, _) =>
          Text('${context.tx('Valor atual')}: $v'),
    ),
  ],
)
''';

  /// Region `sg-stepper-input-controle-externo`.
  static const String sgStepperInputControleExterno = r'''
SgStack(
  gap: 12,
  align: SgStackAlign.start,
  children: [
    ValueListenableBuilder<num>(
      valueListenable: _controlado,
      builder: (context, v, _) => SgStepperInput(
        id: 'stepper-controlled',
        minValue: 10,
        maxValue: 30,
        step: 1,
        value: v,
        width: 210,
        onChange: (n) => _controlado.value = n,
      ),
    ),
    SgStack(
      direction: SgStackDirection.row,
      wrap: true,
      gap: 8,
      children: [
        for (final n in [10, 20, 30])
          SgButton(
            label: Text('$n'),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _controlado.value = n,
          ),
      ],
    ),
    ValueListenableBuilder<num>(
      valueListenable: _controlado,
      builder: (context, v, _) =>
          Text('${context.tx('Valor controlado')}: $v'),
    ),
  ],
)
''';

  /// Region `sg-stepper-input-formulario`.
  static const String sgStepperInputFormulario = r'''
SgStack(
  gap: 12,
  align: SgStackAlign.start,
  children: [
    SgStepperInput(
      id: 'qtd',
      name: 'qtd',
      control: _form,
      minValue: 0,
      maxValue: 9,
      width: 160,
    ),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = '${values['qtd']}',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, v, _) => v.isEmpty
          ? const SizedBox.shrink()
          : Text('${context.tx('Enviado')}: $v'),
    ),
  ],
)
''';

  /// Region `sg-stepper-input-passo`.
  static const String sgStepperInputPasso = r'''
const SgStack(
  gap: 12,
  align: SgStackAlign.start,
  children: [
    SgStepperInput(
      id: 'de-cinco',
      minValue: 0,
      maxValue: 50,
      step: 5,
      width: 160,
    ),
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

  /// Region `sg-stepper-input-somente-leitura`.
  static const String sgStepperInputSomenteLeitura = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 16,
  children: [
    const SgStepperInput(
      id: 'stepper-readonly',
      minValue: 0,
      maxValue: 10,
      value: 7,
      readOnly: true,
    ),
    const SgStepperInput(
      id: 'stepper-disabled',
      minValue: 0,
      maxValue: 10,
      value: 4,
      enabled: false,
    ),
    SgStepperInput(
      id: 'stepper-error',
      minValue: 0,
      maxValue: 10,
      error: context.tx('Escolha ao menos 1'),
    ),
  ],
)
''';
}
