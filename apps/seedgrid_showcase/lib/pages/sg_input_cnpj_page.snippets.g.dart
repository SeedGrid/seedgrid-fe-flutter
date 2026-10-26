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

  /// Region `sg-input-cnpj-estados`.
  static const String sgInputCnpjEstados = r'''
const Column(
  children: [
    SgInputCNPJ(
      id: 'desabilitado',
      labelText: 'Desabilitado',
      initialValue: '05952365000130',
      disabled: true,
    ),
    SizedBox(height: 12),
    SgInputCNPJ(
      id: 'leitura',
      labelText: 'Somente leitura',
      initialValue: '05952365000130',
      readOnly: true,
    ),
  ],
)
''';

  /// Region `sg-input-cnpj-eventos`.
  static const String sgInputCnpjEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputCNPJ(
      id: 'eventos',
      labelText: 'CNPJ',
      onChange: (v) => setState(() => _evento = 'onChange: $v'),
      onEnter: () => setState(() => _evento = 'onEnter'),
      onExit: () => setState(() => _evento = 'onExit'),
      onClear: () => setState(() => _evento = 'onClear'),
    ),
    const SizedBox(height: 8),
    Text('Último evento: $_evento'),
  ],
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

  /// Region `sg-input-cnpj-largura`.
  static const String sgInputCnpjLargura = r'''
const SgInputCNPJ(
  id: 'largura',
  labelText: 'CNPJ',
  width: 240,
  borderRadius: 20,
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

  /// Region `sg-input-cnpj-rotulo`.
  static const String sgInputCnpjRotulo = r'''
const Column(
  children: [
    SgInputCNPJ(
      id: 'topo',
      labelText: 'Rótulo no topo',
      labelPosition: SgInputCNPJLabelPosition.top,
    ),
    SizedBox(height: 12),
    SgInputCNPJ(
      id: 'esquerda',
      labelText: 'À esquerda',
      labelPosition: SgInputCNPJLabelPosition.left,
      labelWidth: 110,
    ),
  ],
)
''';

  /// Region `sg-input-cnpj-sem-limpar`.
  static const String sgInputCnpjSemLimpar = r'''
const SgInputCNPJ(
  id: 'semlimpar',
  labelText: 'CNPJ',
  initialValue: '05952365000130',
  clearButton: false,
)
''';

  /// Region `sg-input-cnpj-variacoes`.
  static const String sgInputCnpjVariacoes = r'''
const Column(
  children: [
    SgInputCNPJ(
      id: 'preenchido',
      labelText: 'Preenchido',
      filled: true,
    ),
    SizedBox(height: 12),
    SgInputCNPJ(
      id: 'vazado',
      labelText: 'Sem preenchimento',
      filled: false,
    ),
    SizedBox(height: 12),
    SgInputCNPJ(
      id: 'semborda',
      labelText: 'Sem borda',
      withBorder: false,
    ),
  ],
)
''';
}
