// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_phone_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputPhonePageSnippets {
  /// Region `sg-input-phone-basico`.
  static const String sgInputPhoneBasico = r'''
const SgInputPhone(id: 'telefone', labelText: 'Telefone')
''';

  /// Region `sg-input-phone-formulario`.
  static const String sgInputPhoneFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputPhone(
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

  /// Region `sg-input-phone-obrigatorio`.
  static const String sgInputPhoneObrigatorio = r'''
const SgInputPhone(
  id: 'telefone-obrigatorio',
  labelText: 'Celular',
  required: true,
  requiredMessage: 'Informe um telefone',
  invalidMessage: 'Telefone incompleto',
)
''';
}
