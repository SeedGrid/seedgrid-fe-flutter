// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_password_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputPasswordPageSnippets {
  /// Region `sg-input-password-basico`.
  static const String sgInputPasswordBasico = r'''
const SgInputPassword(id: 'senha', labelText: 'Senha')
''';

  /// Region `sg-input-password-formulario`.
  static const String sgInputPasswordFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputPassword(
      id: 'f-senha',
      name: 'senha',
      control: _form,
      labelText: 'Senha',
      required: true,
    ),
    const SizedBox(height: 12),
    SgInputPassword(
      id: 'f-confirma',
      name: 'confirma',
      control: _form,
      labelText: 'Confirme a senha',
      showStrengthBar: false,
      rules: SgRules(
        validate: (v) => v == _form.getValue('senha')
            ? true
            : 'As senhas não conferem',
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Criar conta')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _resultado = 'Conta criada'),
      ),
    ),
    if (_resultado.isNotEmpty) Text(_resultado),
  ],
)
''';

  /// Region `sg-input-password-gerar`.
  static const String sgInputPasswordGerar = r'''
const SgInputPassword(
  id: 'gerada',
  labelText: 'Senha',
  createNewPasswordButton: true,
  newPasswordLength: 12,
  maxLength: 32,
  hidePassword: false,
)
''';

  /// Region `sg-input-password-politica`.
  static const String sgInputPasswordPolitica = r'''
const SgInputPassword(
  id: 'politica',
  labelText: 'PIN alfanumérico',
  minSize: 6,
  upperRequired: false,
  specialCharacterRequired: false,
  prohibitsSequentialAscCharacters: false,
  prohibitsSequentialDescCharacters: false,
  showStrengthBar: false,
  commonPasswordCheck: false,
)
''';

  /// Region `sg-input-password-validacao`.
  static const String sgInputPasswordValidacao = r'''
SgInputPassword(
  id: 'regra',
  labelText: 'Senha',
  required: true,
  requiredMessage: 'Informe a senha',
  validation: (v) => v.toLowerCase().contains('empresa')
      ? 'Não use o nome da empresa'
      : null,
)
''';
}
