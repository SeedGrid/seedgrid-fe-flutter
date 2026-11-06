// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_email_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputEmailPageSnippets {
  /// Region `sg-input-email-basico`.
  static const String sgInputEmailBasico = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputEmail(
        id: 'demo-basic',
        labelText: context.tx('Email'),
        hintText: context.tx('exemplo@dominio.com'),
        onChange: (v) => setState(() => _basico = v),
      ),
      const SizedBox(height: 8),
      Text('${context.tx('Valor')}: $_basico'),
    ],
  ),
)
''';

  /// Region `sg-input-email-bloqueio`.
  static const String sgInputEmailBloqueio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputEmail(
        id: 'demo-blocked',
        labelText: context.tx('Email'),
        hintText: context.tx('exemplo@dominio.com'),
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputEmail(
        id: 'demo-blocked-off',
        labelText: context.tx('Sem bloqueio'),
        hintText: context.tx('exemplo@dominio.com'),
        blockFakeMail: false,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-email-desabilitado`.
  static const String sgInputEmailDesabilitado = r'''
SizedBox(
  width: 320,
  child: SgInputEmail(
    id: 'demo-disabled',
    labelText: context.tx('Desabilitado'),
    hintText: context.tx('Email'),
    enabled: false,
    initialValue: context.tx('Não editável'),
  ),
)
''';

  /// Region `sg-input-email-eventos`.
  static const String sgInputEmailEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputEmail(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        hintText: context.tx('Email'),
        required: true,
        onChange: (v) => _log('onChange: "$v"'),
        onEnter: () => _log('onEnter (focus)'),
        onExit: () => _log('onExit (blur)'),
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

  /// Region `sg-input-email-invalido`.
  static const String sgInputEmailInvalido = r'''
SizedBox(
  width: 320,
  child: SgInputEmail(
    id: 'demo-invalid',
    labelText: context.tx('Email'),
    hintText: context.tx('exemplo@dominio.com'),
    invalidMessage: context.tx('Email inválido.'),
  ),
)
''';

  /// Region `sg-input-email-json`.
  static const String sgInputEmailJson = r'''
SizedBox(
  width: 320,
  child: SgInputEmail(
    id: 'demo-json',
    labelText: context.tx('Email'),
    hintText: context.tx('exemplo@dominio.com'),
    blockedEmailDomains:
        ((jsonDecode('{"blockedEmailDomains": ["concorrente.com"]}')
                    as Map<String, dynamic>)['blockedEmailDomains']
                as List)
            .cast<String>(),
  ),
)
''';

  /// Region `sg-input-email-largura`.
  static const String sgInputEmailLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputEmail(
      id: 'demo-w200',
      labelText: context.tx('200px'),
      hintText: context.tx('Email'),
      width: 200,
    ),
    SgInputEmail(
      id: 'demo-w300',
      labelText: context.tx('300px arredondado'),
      hintText: context.tx('Email'),
      width: 300,
      borderRadius: 20,
    ),
  ],
)
''';

  /// Region `sg-input-email-lista`.
  static const String sgInputEmailLista = r'''
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.05),
    border: Border.all(color: Theme.of(context).dividerColor),
    borderRadius: BorderRadius.circular(4),
  ),
  child: Text(
    defaultBlockedEmailDomains.join(', '),
    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
  ),
)
''';

  /// Region `sg-input-email-obrigatorio`.
  static const String sgInputEmailObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputEmail(
        id: 'demo-required',
        labelText: context.tx('Email obrigatório'),
        hintText: context.tx('Obrigatório'),
        required: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputEmail(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        hintText: context.tx('Obrigatório'),
        required: true,
        requiredMessage: context.tx('Informe o email.'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-email-rotulo`.
  static const String sgInputEmailRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputEmail(
        id: 'sg-input-email-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputEmailLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputEmail(
        id: 'sg-input-email-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputEmailLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputEmail(
        id: 'sg-input-email-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputEmailLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputEmailLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-email-sem-limpar`.
  static const String sgInputEmailSemLimpar = r'''
SizedBox(
  width: 320,
  child: SgInputEmail(
    id: 'demo-noclear',
    labelText: context.tx('Sem limpar'),
    hintText: context.tx('Email'),
    clearButton: false,
  ),
)
''';

  /// Region `sg-input-email-validacao`.
  static const String sgInputEmailValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputEmail(
        id: 'demo-validation',
        labelText: context.tx('Somente domínio .com'),
        hintText: context.tx('seu@dominio.com'),
        validation: (v) => v.endsWith('.com')
            ? null
            : context.tx('Use domínio .com.'),
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

  /// Region `sg-input-email-variacoes`.
  static const String sgInputEmailVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputEmail(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        hintText: context.tx('Email'),
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputEmail(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        hintText: context.tx('Email'),
        filled: true,
      ),
    ),
  ],
)
''';
}
