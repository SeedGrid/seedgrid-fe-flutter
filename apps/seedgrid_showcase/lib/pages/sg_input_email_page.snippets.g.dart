// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_email_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputEmailPageSnippets {
  /// Region `sg-input-email-basico`.
  static const String sgInputEmailBasico = r'''
const SgInputEmail(
  id: 'email',
  labelText: 'E-mail',
  placeholder: 'voce@empresa.com',
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
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['email']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
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
}
