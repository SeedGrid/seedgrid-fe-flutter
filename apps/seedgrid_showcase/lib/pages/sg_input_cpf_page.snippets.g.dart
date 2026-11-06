// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_cpf_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCpfPageSnippets {
  /// Region `sg-input-cpf-basico`.
  static const String sgInputCpfBasico = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCPF(
        id: 'demo-basic',
        labelText: context.tx('CPF'),
        hintText: context.tx('000.000.000-00'),
        onChange: (v) => setState(() => _basico = v),
      ),
      const SizedBox(height: 8),
      Text('${context.tx('Valor')}: $_basico'),
    ],
  ),
)
''';

  /// Region `sg-input-cpf-desabilitado`.
  static const String sgInputCpfDesabilitado = r'''
SizedBox(
  width: 320,
  child: SgInputCPF(
    id: 'demo-disabled',
    labelText: context.tx('Desabilitado'),
    hintText: context.tx('CPF'),
    enabled: false,
    initialValue: '000.000.000-00',
  ),
)
''';

  /// Region `sg-input-cpf-eventos`.
  static const String sgInputCpfEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCPF(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        hintText: context.tx('CPF'),
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

  /// Region `sg-input-cpf-invalida`.
  static const String sgInputCpfInvalida = r'''
SizedBox(
  width: 320,
  child: SgInputCPF(
    id: 'demo-invalid',
    labelText: context.tx('CPF'),
    hintText: context.tx('000.000.000-00'),
    invalidMessage: context.tx('CPF inválido.'),
  ),
)
''';

  /// Region `sg-input-cpf-largura`.
  static const String sgInputCpfLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputCPF(
      id: 'demo-w200',
      labelText: context.tx('200px'),
      hintText: context.tx('CPF'),
      width: 200,
    ),
    SgInputCPF(
      id: 'demo-w300',
      labelText: context.tx('300px arredondado'),
      hintText: context.tx('CPF'),
      width: 300,
      borderRadius: 20,
    ),
  ],
)
''';

  /// Region `sg-input-cpf-obrigatorio`.
  static const String sgInputCpfObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputCPF(
        id: 'demo-required',
        labelText: context.tx('CPF obrigatório'),
        hintText: context.tx('Obrigatório'),
        required: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputCPF(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        hintText: context.tx('Obrigatório'),
        required: true,
        requiredMessage: context.tx('Informe o CPF.'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-cpf-rotulo`.
  static const String sgInputCpfRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputCPF(
        id: 'sg-input-cpf-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputCPFLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputCPF(
        id: 'sg-input-cpf-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputCPFLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputCPF(
        id: 'sg-input-cpf-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputCPFLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputCPFLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-cpf-sem-limpar`.
  static const String sgInputCpfSemLimpar = r'''
SizedBox(
  width: 320,
  child: SgInputCPF(
    id: 'demo-noclear',
    labelText: context.tx('Sem limpar'),
    hintText: context.tx('CPF'),
    clearButton: false,
  ),
)
''';

  /// Region `sg-input-cpf-tamanho`.
  static const String sgInputCpfTamanho = r'''
SizedBox(
  width: 320,
  child: SgInputCPF(
    id: 'demo-length',
    labelText: context.tx('CPF'),
    hintText: context.tx('000.000.000-00'),
    lengthMessage: context.tx('CPF deve ter 11 dígitos.'),
  ),
)
''';

  /// Region `sg-input-cpf-validacao`.
  static const String sgInputCpfValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCPF(
        id: 'demo-validation',
        labelText: context.tx('CPF'),
        hintText: context.tx('000.000.000-00'),
        validation: (v) => v.startsWith('123')
            ? context.tx('CPF não pode iniciar com 123.')
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

  /// Region `sg-input-cpf-variacoes`.
  static const String sgInputCpfVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputCPF(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        hintText: context.tx('CPF'),
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputCPF(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        hintText: context.tx('CPF'),
        filled: true,
      ),
    ),
  ],
)
''';
}
