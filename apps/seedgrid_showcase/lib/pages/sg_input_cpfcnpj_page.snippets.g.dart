// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_cpfcnpj_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCpfcnpjPageSnippets {
  /// Region `sg-input-cpfcnpj-basico`.
  static const String sgInputCpfcnpjBasico = r'''
const SgInputCPFCNPJ(id: 'documento', labelText: 'CPF ou CNPJ')
''';

  /// Region `sg-input-cpfcnpj-formulario`.
  static const String sgInputCpfcnpjFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputCPFCNPJ(
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

  /// Region `sg-input-cpfcnpj-obrigatorio`.
  static const String sgInputCpfcnpjObrigatorio = r'''
const SgInputCPFCNPJ(
  id: 'documento-obrigatorio',
  labelText: 'Documento',
  required: true,
  requiredMessage: 'Informe o documento',
  lengthMessage: 'Documento incompleto',
)
''';
}
