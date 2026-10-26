// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_cpf_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCpfPageSnippets {
  /// Region `sg-input-cpf-basico`.
  static const String sgInputCpfBasico = r'''
const SgInputCPF(id: 'cpf', labelText: 'CPF')
''';

  /// Region `sg-input-cpf-estados`.
  static const String sgInputCpfEstados = r'''
const Column(
  children: [
    SgInputCPF(
      id: 'cpf-desabilitado',
      labelText: 'Desabilitado',
      disabled: true,
      initialValue: '529.982.247-25',
    ),
    SizedBox(height: 12),
    SgInputCPF(
      id: 'cpf-leitura',
      labelText: 'Somente leitura',
      readOnly: true,
      initialValue: '529.982.247-25',
    ),
    SizedBox(height: 12),
    SgInputCPF(
      id: 'cpf-erro',
      labelText: 'Erro externo',
      error: 'CPF já cadastrado',
      initialValue: '529.982.247-25',
    ),
  ],
)
''';

  /// Region `sg-input-cpf-eventos`.
  static const String sgInputCpfEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputCPF(
      id: 'eventos',
      labelText: 'CPF',
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

  /// Region `sg-input-cpf-formulario`.
  static const String sgInputCpfFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputCPF(
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

  /// Region `sg-input-cpf-largura`.
  static const String sgInputCpfLargura = r'''
const SgInputCPF(
  id: 'largura',
  labelText: 'CPF',
  width: 240,
  borderRadius: 20,
)
''';

  /// Region `sg-input-cpf-obrigatorio`.
  static const String sgInputCpfObrigatorio = r'''
const SgInputCPF(
  id: 'cpf-obrigatorio',
  labelText: 'CPF do titular',
  required: true,
  requiredMessage: 'Informe o CPF',
  lengthMessage: 'O CPF tem 11 dígitos',
  invalidMessage: 'Esse CPF não existe',
)
''';

  /// Region `sg-input-cpf-rotulo`.
  static const String sgInputCpfRotulo = r'''
const Column(
  children: [
    SgInputCPF(
      id: 'topo',
      labelText: 'Rótulo no topo',
      labelPosition: SgInputCPFLabelPosition.top,
    ),
    SizedBox(height: 12),
    SgInputCPF(
      id: 'esquerda',
      labelText: 'À esquerda',
      labelPosition: SgInputCPFLabelPosition.left,
      labelWidth: 110,
    ),
  ],
)
''';

  /// Region `sg-input-cpf-sem-limpar`.
  static const String sgInputCpfSemLimpar = r'''
const SgInputCPF(
  id: 'semlimpar',
  labelText: 'CPF',
  initialValue: '12345678909',
  clearButton: false,
)
''';

  /// Region `sg-input-cpf-validacao`.
  static const String sgInputCpfValidacao = r'''
SgInputCPF(
  id: 'cpf-regra',
  labelText: 'CPF (não aceita 000...)',
  validation: (v) =>
      v.startsWith('000') ? 'CPF de teste não permitido' : null,
)
''';

  /// Region `sg-input-cpf-variacoes`.
  static const String sgInputCpfVariacoes = r'''
const Column(
  children: [
    SgInputCPF(
      id: 'preenchido',
      labelText: 'Preenchido',
      filled: true,
    ),
    SizedBox(height: 12),
    SgInputCPF(
      id: 'vazado',
      labelText: 'Sem preenchimento',
      filled: false,
    ),
    SizedBox(height: 12),
    SgInputCPF(
      id: 'semborda',
      labelText: 'Sem borda',
      withBorder: false,
    ),
  ],
)
''';
}
