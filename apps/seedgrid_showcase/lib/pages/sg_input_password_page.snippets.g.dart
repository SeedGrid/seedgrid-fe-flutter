// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_password_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputPasswordPageSnippets {
  /// Region `sg-input-password-basico`.
  static const String sgInputPasswordBasico = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPassword(
        id: 'demo-basic',
        labelText: context.tx('Senha'),
        hintText: context.tx('Digite sua senha'),
        onChange: (v) => setState(() => _basico = v),
      ),
      const SizedBox(height: 8),
      Text('${context.tx('Valor')}: $_basico'),
    ],
  ),
)
''';

  /// Region `sg-input-password-eventos`.
  static const String sgInputPasswordEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPassword(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        required: true,
        onChange: (value) => _log('onChange: "$value"'),
        onEnter: () => _log(context.tx('onEnter (focus)')),
        onExit: () => _log(context.tx('onExit (blur)')),
        onClear: () => _log('onClear'),
      ),
      const SizedBox(height: 12),
      ShowcaseLogBox(
        entries: _eventLog,
        hint: context.tx('Interaja com o input...'),
        height: 160,
      ),
    ],
  ),
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

  /// Region `sg-input-password-obrigatorio`.
  static const String sgInputPasswordObrigatorio = r'''
SizedBox(
  width: 320,
  child: SgInputPassword(
    id: 'demo-required',
    labelText: context.tx('Senha obrigatória'),
    hintText: context.tx('Obrigatório'),
    required: true,
  ),
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

  /// Region `sg-input-password-rotulo`.
  static const String sgInputPasswordRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputPassword(
        id: 'sg-input-password-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputPasswordLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputPassword(
        id: 'sg-input-password-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputPasswordLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputPassword(
        id: 'sg-input-password-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputPasswordLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputPasswordLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-password-validacao`.
  static const String sgInputPasswordValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPassword(
        id: 'demo-validation',
        labelText: context.tx('Mínimo 8'),
        hintText: context.tx('Mínimo 8 caracteres'),
        validation: (value) => value.length < 8
            ? context.tx(
                'Senha precisa ter no mínimo 8 caracteres.',
              )
            : null,
        onValidation: (msg) => setState(() => _validationMsg = msg),
      ),
      const SizedBox(height: 8),
      Text(
        'onValidation: ${_validationMsg ?? context.tx('válido')}',
      ),
    ],
  ),
)
''';

  /// Region `sg-input-password-variacoes`.
  static const String sgInputPasswordVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputPassword(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputPassword(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        filled: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputPassword(
        id: 'demo-noclear',
        labelText: context.tx('Sem limpar'),
        clearButton: false,
      ),
    ),
  ],
)
''';
}
