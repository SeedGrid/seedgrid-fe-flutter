// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_phone_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputPhonePageSnippets {
  /// Region `sg-input-phone-basico`.
  static const String sgInputPhoneBasico = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPhone(
        id: 'demo-basic',
        labelText: context.tx('Telefone'),
        hintText: context.tx('(00) 00000-0000'),
        onChange: (v) => setState(() => _basico = v),
      ),
      const SizedBox(height: 8),
      Text('${context.tx('Valor')}: "$_basico"'),
    ],
  ),
)
''';

  /// Region `sg-input-phone-desabilitado`.
  static const String sgInputPhoneDesabilitado = r'''
SizedBox(
  width: 320,
  child: SgInputPhone(
    id: 'demo-disabled',
    labelText: context.tx('Desabilitado'),
    hintText: context.tx('Telefone'),
    enabled: false,
    initialValue: '(11) 99999-0000',
  ),
)
''';

  /// Region `sg-input-phone-eventos`.
  static const String sgInputPhoneEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPhone(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        hintText: context.tx('Telefone'),
        required: true,
        onChange: (v) => _log('onChange: "$v"'),
        onEnter: () => _log(context.tx('onEnter (focus)')),
        onExit: () => _log(context.tx('onExit (blur)')),
        onClear: () => _log('onClear'),
        onValidation: (msg) =>
            _log('onValidation: ${msg ?? context.tx('válido')}'),
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

  /// Region `sg-input-phone-invalida`.
  static const String sgInputPhoneInvalida = r'''
SizedBox(
  width: 320,
  child: SgInputPhone(
    id: 'demo-invalid',
    labelText: context.tx('Telefone'),
    hintText: context.tx('(00) 00000-0000'),
    invalidMessage: context.tx('Telefone inválido.'),
  ),
)
''';

  /// Region `sg-input-phone-largura`.
  static const String sgInputPhoneLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputPhone(
      id: 'demo-w200',
      labelText: context.tx('200px'),
      hintText: context.tx('Telefone'),
      width: 200,
    ),
    SgInputPhone(
      id: 'demo-w300',
      labelText: context.tx('300px arredondado'),
      hintText: context.tx('Telefone'),
      width: 300,
      borderRadius: 20,
    ),
  ],
)
''';

  /// Region `sg-input-phone-obrigatorio`.
  static const String sgInputPhoneObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputPhone(
        id: 'demo-required',
        labelText: context.tx('Telefone obrigatório'),
        hintText: context.tx('Obrigatório'),
        required: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputPhone(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        hintText: context.tx('Obrigatório'),
        required: true,
        requiredMessage: context.tx('Informe o telefone.'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-phone-rotulo`.
  static const String sgInputPhoneRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputPhone(
        id: 'sg-input-phone-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputPhoneLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputPhone(
        id: 'sg-input-phone-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputPhoneLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputPhone(
        id: 'sg-input-phone-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputPhoneLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputPhoneLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-phone-sem-limpar`.
  static const String sgInputPhoneSemLimpar = r'''
SizedBox(
  width: 320,
  child: SgInputPhone(
    id: 'demo-noclear',
    labelText: context.tx('Sem limpar'),
    hintText: context.tx('Telefone'),
    clearButton: false,
  ),
)
''';

  /// Region `sg-input-phone-validacao`.
  static const String sgInputPhoneValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPhone(
        id: 'demo-validation',
        labelText: context.tx('Telefone'),
        hintText: context.tx('(00) 00000-0000'),
        validation: (v) => v.startsWith('(00)')
            ? context.tx('DDD inválido.')
            : null,
        onValidation: (msg) => setState(() => _validationMsg = msg),
      ),
      const SizedBox(height: 8),
      Text(
        'onValidation: ${_validationMsg == null ? context.tx('válido') : '"$_validationMsg"'}',
      ),
    ],
  ),
)
''';

  /// Region `sg-input-phone-variacoes`.
  static const String sgInputPhoneVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputPhone(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        hintText: context.tx('Telefone'),
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputPhone(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        hintText: context.tx('Telefone'),
        filled: true,
      ),
    ),
  ],
)
''';
}
