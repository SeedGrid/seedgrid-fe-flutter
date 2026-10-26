// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_postal_code_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputPostalCodePageSnippets {
  /// Region `sg-input-postal-code-basico`.
  static const String sgInputPostalCodeBasico = r'''
const SgInputPostalCode(id: 'cep', labelText: 'CEP')
''';

  /// Region `sg-input-postal-code-estados`.
  static const String sgInputPostalCodeEstados = r'''
const Column(
  children: [
    SgInputPostalCode(
      id: 'desabilitado',
      labelText: 'Desabilitado',
      initialValue: '01310100',
      disabled: true,
    ),
    SizedBox(height: 12),
    SgInputPostalCode(
      id: 'leitura',
      labelText: 'Somente leitura',
      initialValue: '01310100',
      readOnly: true,
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-eventos`.
  static const String sgInputPostalCodeEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputPostalCode(
      id: 'eventos',
      labelText: 'CEP',
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

  /// Region `sg-input-postal-code-largura`.
  static const String sgInputPostalCodeLargura = r'''
const SgInputPostalCode(
  id: 'largura',
  labelText: 'CEP',
  width: 240,
  borderRadius: 20,
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

  /// Region `sg-input-postal-code-rotulo`.
  static const String sgInputPostalCodeRotulo = r'''
const Column(
  children: [
    SgInputPostalCode(
      id: 'topo',
      labelText: 'Rótulo no topo',
      labelPosition: SgInputPostalCodeLabelPosition.top,
    ),
    SizedBox(height: 12),
    SgInputPostalCode(
      id: 'esquerda',
      labelText: 'À esquerda',
      labelPosition: SgInputPostalCodeLabelPosition.left,
      labelWidth: 110,
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-sem-limpar`.
  static const String sgInputPostalCodeSemLimpar = r'''
const SgInputPostalCode(
  id: 'semlimpar',
  labelText: 'CEP',
  initialValue: '01310100',
  clearButton: false,
)
''';

  /// Region `sg-input-postal-code-variacoes`.
  static const String sgInputPostalCodeVariacoes = r'''
const Column(
  children: [
    SgInputPostalCode(
      id: 'preenchido',
      labelText: 'Preenchido',
      filled: true,
    ),
    SizedBox(height: 12),
    SgInputPostalCode(
      id: 'vazado',
      labelText: 'Sem preenchimento',
      filled: false,
    ),
    SizedBox(height: 12),
    SgInputPostalCode(
      id: 'semborda',
      labelText: 'Sem borda',
      withBorder: false,
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
