// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_postal_code_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputPostalCodePageSnippets {
  /// Region `sg-input-postal-code-basico`.
  static const String sgInputPostalCodeBasico = r'''
const SgInputPostalCode(id: 'cep', labelText: 'CEP')
''';

  /// Region `sg-input-postal-code-formulario`.
  static const String sgInputPostalCodeFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputPostalCode(
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

  /// Region `sg-input-postal-code-paises`.
  static const String sgInputPostalCodePaises = r'''
const Column(
  children: [
    SgInputPostalCode(
      id: 'cp-pt',
      labelText: 'Portugal',
      country: SgInputPostalCodeCountry.pt,
    ),
    SizedBox(height: 12),
    SgInputPostalCode(
      id: 'cp-us',
      labelText: 'Estados Unidos',
      country: SgInputPostalCodeCountry.us,
    ),
    SizedBox(height: 12),
    SgInputPostalCode(
      id: 'cp-ar',
      labelText: 'Argentina',
      country: SgInputPostalCodeCountry.ar,
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-viacep`.
  static const String sgInputPostalCodeViacep = r'''
SgInputPostalCode(
  id: 'cep-consulta',
  labelText: 'CEP com consulta',
  validateWithViaCep: true,
  viaCepErrorMessage: 'CEP inexistente',
  viaCepFetch: (cep) async => cep.startsWith('99')
      ? const SgViaCepResult(erro: true)
      : SgViaCepResult(cep: cep, uf: 'SP'),
)
''';
}
