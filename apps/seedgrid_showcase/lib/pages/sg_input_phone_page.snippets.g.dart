// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_phone_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputPhonePageSnippets {
  /// Region `sg-input-phone-basico`.
  static const String sgInputPhoneBasico = r'''
const SgInputPhone(id: 'telefone', labelText: 'Telefone')
''';

  /// Region `sg-input-phone-estados`.
  static const String sgInputPhoneEstados = r'''
const Column(
  children: [
    SgInputPhone(
      id: 'desabilitado',
      labelText: 'Desabilitado',
      initialValue: '11987654321',
      disabled: true,
    ),
    SizedBox(height: 12),
    SgInputPhone(
      id: 'leitura',
      labelText: 'Somente leitura',
      initialValue: '11987654321',
      readOnly: true,
    ),
  ],
)
''';

  /// Region `sg-input-phone-eventos`.
  static const String sgInputPhoneEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputPhone(
      id: 'eventos',
      labelText: 'Telefone',
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

  /// Region `sg-input-phone-largura`.
  static const String sgInputPhoneLargura = r'''
const SgInputPhone(
  id: 'largura',
  labelText: 'Telefone',
  width: 240,
  borderRadius: 20,
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

  /// Region `sg-input-phone-rotulo`.
  static const String sgInputPhoneRotulo = r'''
const Column(
  children: [
    SgInputPhone(
      id: 'topo',
      labelText: 'Rótulo no topo',
      labelPosition: SgInputPhoneLabelPosition.top,
    ),
    SizedBox(height: 12),
    SgInputPhone(
      id: 'esquerda',
      labelText: 'À esquerda',
      labelPosition: SgInputPhoneLabelPosition.left,
      labelWidth: 110,
    ),
  ],
)
''';

  /// Region `sg-input-phone-sem-limpar`.
  static const String sgInputPhoneSemLimpar = r'''
const SgInputPhone(
  id: 'semlimpar',
  labelText: 'Telefone',
  initialValue: '11987654321',
  clearButton: false,
)
''';

  /// Region `sg-input-phone-variacoes`.
  static const String sgInputPhoneVariacoes = r'''
const Column(
  children: [
    SgInputPhone(
      id: 'preenchido',
      labelText: 'Preenchido',
      filled: true,
    ),
    SizedBox(height: 12),
    SgInputPhone(
      id: 'vazado',
      labelText: 'Sem preenchimento',
      filled: false,
    ),
    SizedBox(height: 12),
    SgInputPhone(
      id: 'semborda',
      labelText: 'Sem borda',
      withBorder: false,
    ),
  ],
)
''';
}
