// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_postal_code_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputPostalCodePageSnippets {
  /// Region `sg-input-postal-code-afixos`.
  static const String sgInputPostalCodeAfixos = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-prefix-text',
        labelText: context.tx('Com prefixo'),
        hintText: '00000-000',
        prefixText: 'CEP:',
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-suffix-text',
        labelText: context.tx('Com sufixo'),
        hintText: '00000-000',
        suffixText: 'BR',
      ),
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-basico`.
  static const String sgInputPostalCodeBasico = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPostalCode(
        id: 'demo-basic',
        labelText: context.tx('CEP (Brasil)'),
        hintText: '00000-000',
        name: 'cep',
        control: _form,
      ),
      const SizedBox(height: 8),
      ListenableBuilder(
        listenable: _form,
        builder: (context, _) => Text(
          '${context.tx('Valor')}: "${_form.getValue('cep') ?? ''}"',
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-postal-code-botoes`.
  static const String sgInputPostalCodeBotoes = r'''
SizedBox(
  width: 384,
  child: Column(
    children: [
      SgInputPostalCode(
        id: 'demo-iconbtns',
        labelText: context.tx('Copiar CEP'),
        hintText: '00000-000',
        iconButtons: [
          SgButton(
            iconOnly: true,
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            leftIcon: const Icon(Icons.copy),
            onClick: () => setState(
              () => _iconLog.insert(0, context.tx('Copiado')),
            ),
          ),
          SgButton(
            iconOnly: true,
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            leftIcon: const Icon(Icons.notifications_outlined),
            onClick: () => setState(
              () => _iconLog.insert(
                0,
                context.tx('Alerta disparado!'),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      ShowcaseLogBox(
        entries: _iconLog,
        hint: context.tx('Clique nos ícones para testar...'),
        height: 96,
      ),
    ],
  ),
)
''';

  /// Region `sg-input-postal-code-controlado`.
  static const String sgInputPostalCodeControlado = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPostalCode(
        id: 'demo-controlled',
        labelText: context.tx('CEP do cliente'),
        hintText: '00000-000',
        name: 'controlled',
        control: _form,
      ),
      const SizedBox(height: 12),
      ListenableBuilder(
        listenable: _form,
        builder: (context, _) => Text(
          '${context.tx('Estado atual')}: "${_form.getValue('controlled') ?? ''}"',
        ),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          SgButton(
            label: Text(context.tx('Setar via API')),
            onClick: () =>
                _form.setValue('controlled', '04538-132'),
          ),
          SgButton(
            appearance: SgAppearance.outline,
            label: Text(context.tx('Outro valor')),
            onClick: () =>
                _form.setValue('controlled', '20040-020'),
          ),
          SgButton(
            appearance: SgAppearance.outline,
            severity: SgSeverity.danger,
            label: Text(context.tx('Limpar')),
            onClick: () => _form.setValue('controlled', ''),
          ),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-input-postal-code-estados`.
  static const String sgInputPostalCodeEstados = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-disabled',
        labelText: context.tx('Desabilitado'),
        hintText: '00000-000',
        enabled: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-readonly',
        labelText: context.tx('Somente leitura'),
        hintText: '00000-000',
        readOnly: true,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-eventos`.
  static const String sgInputPostalCodeEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPostalCode(
        id: 'demo-events',
        labelText: context.tx('Com eventos'),
        hintText: '00000-000',
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

  /// Region `sg-input-postal-code-icone`.
  static const String sgInputPostalCodeIcone = r'''
SizedBox(
  width: 320,
  child: SgInputPostalCode(
    id: 'demo-prefix-icon',
    labelText: context.tx('Buscar CEP'),
    hintText: '00000-000',
    prefixIcon: const Icon(Icons.search, size: 16),
  ),
)
''';

  /// Region `sg-input-postal-code-largura`.
  static const String sgInputPostalCodeLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputPostalCode(
      id: 'demo-w200',
      labelText: context.tx('200px'),
      hintText: '00000-000',
      width: 200,
    ),
    SgInputPostalCode(
      id: 'demo-w300',
      labelText: context.tx('300px arredondado'),
      hintText: '00000-000',
      width: 300,
      borderRadius: 20,
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-obrigatorio`.
  static const String sgInputPostalCodeObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-required',
        labelText: context.tx('Código postal obrigatório'),
        hintText: context.tx('Obrigatório'),
        required: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        hintText: context.tx('Obrigatório'),
        required: true,
        requiredMessage: context.tx('Informe o código postal.'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-paises`.
  static const String sgInputPostalCodePaises = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    for (final (country, label, hint) in [
      (
        SgInputPostalCodeCountry.br,
        context.tx('CEP (Brasil)'),
        '00000-000',
      ),
      (
        SgInputPostalCodeCountry.pt,
        context.tx('Código postal (Portugal)'),
        '0000-000',
      ),
      (
        SgInputPostalCodeCountry.us,
        context.tx('ZIP code (EUA)'),
        '00000',
      ),
      (
        SgInputPostalCodeCountry.es,
        context.tx('Código postal (Espanha)'),
        '00000',
      ),
      (
        SgInputPostalCodeCountry.uy,
        context.tx('Código postal (Uruguai)'),
        '00000',
      ),
      (
        SgInputPostalCodeCountry.ar,
        context.tx('Código postal (Argentina)'),
        'A0000AAA',
      ),
      (
        SgInputPostalCodeCountry.py,
        context.tx('Código postal (Paraguai)'),
        '000000',
      ),
    ])
      SizedBox(
        width: 280,
        child: SgInputPostalCode(
          id: 'demo-${country.name}',
          country: country,
          labelText: label,
          hintText: hint,
        ),
      ),
  ],
)
''';

  /// Region `sg-input-postal-code-rotulo`.
  static const String sgInputPostalCodeRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputPostalCode(
        id: 'sg-input-postal-code-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputPostalCodeLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputPostalCode(
        id: 'sg-input-postal-code-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputPostalCodeLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputPostalCode(
        id: 'sg-input-postal-code-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputPostalCodeLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputPostalCodeLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-sem-limpar`.
  static const String sgInputPostalCodeSemLimpar = r'''
SizedBox(
  width: 320,
  child: SgInputPostalCode(
    id: 'demo-noclear',
    labelText: context.tx('Sem limpar'),
    hintText: '00000-000',
    clearButton: false,
  ),
)
''';

  /// Region `sg-input-postal-code-standalone`.
  static const String sgInputPostalCodeStandalone = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPostalCode(
        id: 'standalone-a',
        labelText: context.tx('CEP de entrega'),
        hintText: '00000-000',
        onChange: (v) => _standalone['entrega'] = v,
      ),
      const SizedBox(height: 12),
      SgInputPostalCode(
        id: 'standalone-b',
        labelText: context.tx('CEP de cobrança'),
        hintText: '00000-000',
        onChange: (v) => _standalone['cobranca'] = v,
      ),
      const SizedBox(height: 12),
      SgInputPostalCode(
        id: 'standalone-c',
        labelText: context.tx('CEP comercial'),
        hintText: '00000-000',
        onChange: (v) => _standalone['comercial'] = v,
      ),
      const SizedBox(height: 12),
      SgButton(
        label: Text(context.tx('Salvar')),
        onClick: () => setState(
          () => _standaloneResult = jsonEncode({
            'entrega': _standalone['entrega'] ?? '',
            'cobranca': _standalone['cobranca'] ?? '',
            'comercial': _standalone['comercial'] ?? '',
          }),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        '${context.tx('Resultado')}: ${_standaloneResult.isEmpty ? '-' : _standaloneResult}',
      ),
    ],
  ),
)
''';

  /// Region `sg-input-postal-code-validacao`.
  static const String sgInputPostalCodeValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputPostalCode(
        id: 'demo-validation',
        labelText: context.tx('CEP (Brasil)'),
        hintText: '00000-000',
        validation: (v) => v.startsWith('00')
            ? context.tx('CEP não pode iniciar com 00.')
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

  /// Region `sg-input-postal-code-variacoes`.
  static const String sgInputPostalCodeVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        hintText: '00000-000',
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        hintText: '00000-000',
        filled: true,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-postal-code-viacep`.
  static const String sgInputPostalCodeViacep = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgInputPostalCode(
        id: 'demo-viacep',
        labelText: context.tx('CEP (Brasil)'),
        hintText: '00000-000',
        country: SgInputPostalCodeCountry.br,
        validateWithViaCep: true,
        viaCepErrorMessage: context.tx('CEP inválido.'),
        onViaCepResult: (data) =>
            setState(() => _viaCepResult = data),
      ),
    ),
    if (_viaCepResult != null) ...[
      const SizedBox(height: 8),
      Text(context.tx('Resultado ViaCEP')),
      SelectableText(
        const JsonEncoder.withIndent('  ').convert({
          'cep': _viaCepResult!.cep,
          'logradouro': _viaCepResult!.logradouro,
          'bairro': _viaCepResult!.bairro,
          'localidade': _viaCepResult!.localidade,
          'uf': _viaCepResult!.uf,
        }),
      ),
    ],
    const SizedBox(height: 8),
    Text(
      context.tx(
        'Se a API estiver fora do ar, o componente não bloqueia o usuário.',
      ),
    ),
  ],
)
''';
}
