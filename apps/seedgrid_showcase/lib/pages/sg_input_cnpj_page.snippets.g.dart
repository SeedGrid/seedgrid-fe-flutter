// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_cnpj_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCnpjPageSnippets {
  /// Region `sg-input-cnpj-basico`.
  static const String sgInputCnpjBasico = r'''
const SgInputCNPJ(id: 'cnpj', labelText: 'CNPJ')
''';

  /// Region `sg-input-cnpj-consulta`.
  static const String sgInputCnpjConsulta = r'''
SgInputCNPJ(
  id: 'cnpj-consulta',
  labelText: 'CNPJ com consulta',
  validateWithPublicaCnpj: true,
  publicaCnpjErrorMessage: 'CNPJ não encontrado na Receita',
)
''';

  /// Region `sg-input-cnpj-formulario`.
  static const String sgInputCnpjFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputCNPJ(
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

  /// Region `sg-input-cnpj-obrigatorio`.
  static const String sgInputCnpjObrigatorio = r'''
const SgInputCNPJ(
  id: 'cnpj-obrigatorio',
  labelText: 'CNPJ da empresa',
  required: true,
  requiredMessage: 'Informe o CNPJ',
  invalidMessage: 'CNPJ inválido, confira os dígitos',
)
''';
}
