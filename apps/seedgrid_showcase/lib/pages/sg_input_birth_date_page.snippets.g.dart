// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_birth_date_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputBirthDatePageSnippets {
  /// Region `sg-input-birth-date-faixa`.
  static const String sgInputBirthDateFaixa = r'''
const SgInputBirthDate(
  id: 'nascimento-faixa',
  labelText: 'Entre 18 e 65 anos',
  minAge: 18,
  maxAge: 65,
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
      labelText: 'Campo',
      minAge: 18,
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

  /// Region `sg-input-birth-date-maior`.
  static const String sgInputBirthDateMaior = r'''
const SgInputBirthDate(
  id: 'nascimento',
  labelText: 'Data de nascimento',
  minAge: 18,
)
''';

  /// Region `sg-input-birth-date-obrigatorio`.
  static const String sgInputBirthDateObrigatorio = r'''
const SgInputBirthDate(
  id: 'nascimento-obrigatorio',
  labelText: 'Nascimento',
  minAge: 0,
  required: true,
  requiredMessage: 'Informe quando nasceu',
)
''';
}
