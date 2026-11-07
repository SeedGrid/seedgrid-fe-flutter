// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_birth_date_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputBirthDatePageSnippets {
  /// Region `sg-input-birth-date-basico`.
  static const String sgInputBirthDateBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputBirthDate(
      id: 'demo-basic',
      labelText: context.tx('Data de nascimento'),
      minAge: 18,
      onValidation: (msg) => _validacao.value = msg,
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<String?>(
      valueListenable: _validacao,
      builder: (context, msg, _) =>
          Text('onValidation: ${msg ?? context.tx('válido')}'),
    ),
  ],
)
''';

  /// Region `sg-input-birth-date-faixa`.
  static const String sgInputBirthDateFaixa = r'''
SgInputBirthDate(
  id: 'demo-range',
  labelText: context.tx('Data de nascimento'),
  minAge: 12,
  maxAge: 80,
)
''';

  /// Region `sg-input-birth-date-formulario`.
  static const String sgInputBirthDateFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputBirthDate(
      id: 'campo',
      name: 'campo',
      control: _form,
      labelText: context.tx('Data de nascimento'),
      minAge: 18,
      required: true,
      requiredMessage: context.tx('Informe a data de nascimento.'),
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

  /// Region `sg-input-birth-date-obrigatorio`.
  static const String sgInputBirthDateObrigatorio = r'''
SgInputBirthDate(
  id: 'demo-required',
  labelText: context.tx('Data de nascimento'),
  minAge: 18,
  required: true,
  requiredMessage: context.tx('Informe a data de nascimento.'),
)
''';

  /// Region `sg-input-birth-date-rotulo`.
  static const String sgInputBirthDateRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputBirthDate(
        id: 'sg-input-birth-date-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputBirthDateLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputBirthDate(
        id: 'sg-input-birth-date-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputBirthDateLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputBirthDate(
        id: 'sg-input-birth-date-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputBirthDateLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputBirthDateLabelAlign.end,
      ),
    ),
  ],
)
''';
}
