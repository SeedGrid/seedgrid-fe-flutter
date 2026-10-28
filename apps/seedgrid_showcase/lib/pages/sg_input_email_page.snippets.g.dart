// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_email_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputEmailPageSnippets {
  /// Region `sg-input-email-basico`.
  static const String sgInputEmailBasico = r'''
SgInputEmail(
  id: 'email',
  labelText: 'E-mail',
  placeholder: context.tx('voce@empresa.com'),
)
''';

  /// Region `sg-input-email-descartaveis`.
  static const String sgInputEmailDescartaveis = r'''
const Column(
  children: [
    SgInputEmail(
      id: 'padrao',
      labelText: 'Bloqueio padrão (tente a@yopmail.com)',
    ),
    SizedBox(height: 12),
    SgInputEmail(
      id: 'livre',
      labelText: 'blockFakeMail: false',
      blockFakeMail: false,
    ),
    SizedBox(height: 12),
    SgInputEmail(
      id: 'extra',
      labelText: 'Bloqueia @concorrente.com',
      blockedEmailDomains: ['concorrente.com'],
    ),
  ],
)
''';

  /// Region `sg-input-email-estados`.
  static const String sgInputEmailEstados = r'''
const Column(
  children: [
    SgInputEmail(
      id: 'desabilitado',
      labelText: 'Desabilitado',
      initialValue: 'ana@exemplo.com',
      disabled: true,
    ),
    SizedBox(height: 12),
    SgInputEmail(
      id: 'leitura',
      labelText: 'Somente leitura',
      initialValue: 'ana@exemplo.com',
      readOnly: true,
    ),
  ],
)
''';

  /// Region `sg-input-email-eventos`.
  static const String sgInputEmailEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputEmail(
      id: 'eventos',
      labelText: 'E-mail',
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

  /// Region `sg-input-email-formulario`.
  static const String sgInputEmailFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputEmail(
      id: 'form-email',
      name: 'email',
      control: _form,
      labelText: 'E-mail',
      required: true,
      requiredMessage: 'Informe o e-mail',
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['email']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-input-email-largura`.
  static const String sgInputEmailLargura = r'''
const SgInputEmail(
  id: 'largura',
  labelText: 'E-mail',
  width: 240,
  borderRadius: 20,
)
''';

  /// Region `sg-input-email-obrigatorio`.
  static const String sgInputEmailObrigatorio = r'''
const Column(
  children: [
    SgInputEmail(
      id: 'obrigatorio',
      labelText: 'Obrigatório',
      required: true,
    ),
    SizedBox(height: 12),
    SgInputEmail(
      id: 'proprias',
      labelText: 'Mensagens próprias',
      required: true,
      requiredMessage: 'Informe o e-mail do responsável',
      invalidMessage: 'Esse e-mail não parece certo',
    ),
  ],
)
''';

  /// Region `sg-input-email-rotulo`.
  static const String sgInputEmailRotulo = r'''
const Column(
  children: [
    SgInputEmail(
      id: 'topo',
      labelText: 'Rótulo no topo',
      labelPosition: SgInputEmailLabelPosition.top,
    ),
    SizedBox(height: 12),
    SgInputEmail(
      id: 'esquerda',
      labelText: 'À esquerda',
      labelPosition: SgInputEmailLabelPosition.left,
      labelWidth: 110,
    ),
  ],
)
''';

  /// Region `sg-input-email-sem-limpar`.
  static const String sgInputEmailSemLimpar = r'''
const SgInputEmail(
  id: 'semlimpar',
  labelText: 'E-mail',
  initialValue: 'ana@exemplo.com',
  clearButton: false,
)
''';

  /// Region `sg-input-email-validacao`.
  static const String sgInputEmailValidacao = r'''
SgInputEmail(
  id: 'corporativo',
  labelText: 'E-mail corporativo',
  validation: (v) => v.endsWith('@empresa.com')
      ? null
      : 'Use o e-mail @empresa.com',
)
''';

  /// Region `sg-input-email-variacoes`.
  static const String sgInputEmailVariacoes = r'''
const Column(
  children: [
    SgInputEmail(
      id: 'preenchido',
      labelText: 'Preenchido',
      filled: true,
    ),
    SizedBox(height: 12),
    SgInputEmail(
      id: 'vazado',
      labelText: 'Sem preenchimento',
      filled: false,
    ),
    SizedBox(height: 12),
    SgInputEmail(
      id: 'semborda',
      labelText: 'Sem borda',
      withBorder: false,
    ),
  ],
)
''';
}
