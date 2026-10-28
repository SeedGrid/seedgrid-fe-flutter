// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_cpfcnpj_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCpfcnpjPageSnippets {
  /// Region `sg-input-cpfcnpj-basico`.
  static const String sgInputCpfcnpjBasico = r'''
const SgInputCPFCNPJ(id: 'documento', labelText: 'CPF ou CNPJ')
''';

  /// Region `sg-input-cpfcnpj-consulta`.
  static const String sgInputCpfcnpjConsulta = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputCPFCNPJ(
      id: 'documento-consulta',
      labelText: 'CPF ou CNPJ com consulta',
      validateWithPublicaCnpj: true,
      publicaCnpjErrorMessage: 'CNPJ não encontrado na Receita',
      onPublicaCnpjResult: (data) => setState(() {
        _publicaResultado = data;
        _publicaErro = null;
      }),
      onPublicaCnpjError: (_) => setState(
        () => _publicaErro =
            'Não foi possível consultar a base pública agora.',
      ),
    ),
    if (_publicaResultado != null) ...[
      const SizedBox(height: 8),
      Text(context.tx('Resultado da consulta')),
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 240),
        child: SingleChildScrollView(
          child: SelectableText(
            const JsonEncoder.withIndent(
              '  ',
            ).convert(_publicaResultado),
          ),
        ),
      ),
    ],
    if (_publicaErro != null) Text(_publicaErro!),
  ],
)
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
      label: Text(context.tx('Enviar')),
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
