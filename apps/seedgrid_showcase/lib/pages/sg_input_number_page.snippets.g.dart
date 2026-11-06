// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_number_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputNumberPageSnippets {
  /// Region `sg-input-number-afixos`.
  static const String sgInputNumberAfixos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgInputNumber(
        id: 'demo-prefix-text',
        labelText: context.tx('Preço'),
        prefixText: r'R$',
        name: 'prefix',
        control: _form,
        decimals: 2,
      ),
    ),
    ListenableBuilder(
      listenable: _form,
      builder: (context, _) => Text(
        '${context.tx('Valor')}: ${_form.getValue('prefix') ?? ''}',
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputNumber(
        id: 'demo-suffix-text',
        labelText: context.tx('Peso'),
        suffixText: 'kg',
        name: 'suffix',
        control: _form,
        decimals: 2,
      ),
    ),
    ListenableBuilder(
      listenable: _form,
      builder: (context, _) => Text(
        '${context.tx('Valor')}: ${_form.getValue('suffix') ?? ''}',
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputNumber(
        id: 'demo-both',
        labelText: context.tx('Valor total'),
        prefixText: r'R$',
        suffixText: 'm',
        name: 'both',
        control: _form,
        decimals: 2,
      ),
    ),
    ListenableBuilder(
      listenable: _form,
      builder: (context, _) => Text(
        '${context.tx('Valor')}: ${_form.getValue('both') ?? ''}',
      ),
    ),
  ],
)
''';

  /// Region `sg-input-number-basico`.
  static const String sgInputNumberBasico = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputNumber(
        id: 'demo-basic',
        labelText: context.tx('Valor'),
        name: 'valor',
        control: _form,
        decimals: 2,
      ),
      const SizedBox(height: 8),
      SgButton(
        size: SgSize.sm,
        appearance: SgAppearance.outline,
        label: Text(context.tx('Enviar')),
        onClick: () => _form.handleSubmit(
          (values) =>
              setState(() => _enviado = '${values['valor']}'),
        ),
      ),
      const SizedBox(height: 8),
      Text('${context.tx('Valor')}: $_enviado'),
    ],
  ),
)
''';

  /// Region `sg-input-number-botoes`.
  static const String sgInputNumberBotoes = r'''
SizedBox(
  width: 384,
  child: Column(
    children: [
      SgInputNumber(
        id: 'demo-iconbtns',
        labelText: context.tx('Número para copiar'),
        decimals: 2,
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
        hint: context.tx('Digite algo e clique nos ícones...'),
        height: 96,
      ),
    ],
  ),
)
''';

  /// Region `sg-input-number-controlado`.
  static const String sgInputNumberControlado = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputNumber(
        id: 'demo-controlled',
        labelText: context.tx('Valor controlado'),
        name: 'controlled',
        control: _form,
        decimals: 2,
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
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            label: Text(context.tx('Setar via API')),
            onClick: () => _form.setValue('controlled', '12345.00'),
          ),
          SgButton(
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            label: Text(context.tx('Resetar')),
            onClick: () => _form.setValue('controlled', '0.00'),
          ),
          SgButton(
            size: SgSize.sm,
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

  /// Region `sg-input-number-eventos`.
  static const String sgInputNumberEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputNumber(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        required: true,
        decimals: 2,
        onChange: (v) => _log('onChange: $v'),
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

  /// Region `sg-input-number-icone`.
  static const String sgInputNumberIcone = r'''
SizedBox(
  width: 320,
  child: SgInputNumber(
    id: 'demo-prefix-icon',
    labelText: context.tx('Buscar valor'),
    decimals: 2,
    prefixIcon: const Icon(Icons.search, size: 16),
  ),
)
''';

  /// Region `sg-input-number-largura`.
  static const String sgInputNumberLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputNumber(
      id: 'demo-w200',
      labelText: context.tx('200px'),
      width: 200,
      decimals: 2,
    ),
    SgInputNumber(
      id: 'demo-w300',
      labelText: context.tx('300px arredondado'),
      width: 300,
      borderRadius: 20,
      decimals: 2,
    ),
  ],
)
''';

  /// Region `sg-input-number-minmax`.
  static const String sgInputNumberMinmax = r'''
SizedBox(
  width: 320,
  child: SgInputNumber(
    id: 'demo-minmax',
    labelText: context.tx('Entre 10 e 100'),
    minValue: 10,
    maxValue: 100,
    decimals: 2,
  ),
)
''';

  /// Region `sg-input-number-obrigatorio`.
  static const String sgInputNumberObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputNumber(
        id: 'demo-required',
        labelText: context.tx('Campo obrigatório'),
        required: true,
        decimals: 2,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputNumber(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        required: true,
        requiredMessage: context.tx('Informe um valor.'),
        decimals: 2,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-number-rotulo`.
  static const String sgInputNumberRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputNumber(
        id: 'sg-input-number-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputNumberLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputNumber(
        id: 'sg-input-number-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputNumberLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputNumber(
        id: 'sg-input-number-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputNumberLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputNumberLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-number-sem-decimais`.
  static const String sgInputNumberSemDecimais = r'''
SizedBox(
  width: 320,
  child: SgInputNumber(
    id: 'demo-no-decimals',
    labelText: context.tx('Quantidade'),
    decimals: 0,
  ),
)
''';

  /// Region `sg-input-number-sem-negativo`.
  static const String sgInputNumberSemNegativo = r'''
SizedBox(
  width: 320,
  child: SgInputNumber(
    id: 'demo-no-negative',
    labelText: context.tx('Apenas positivo'),
    allowNegative: false,
    decimals: 2,
  ),
)
''';

  /// Region `sg-input-number-standalone`.
  static const String sgInputNumberStandalone = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputNumber(
        id: 'standalone-a',
        labelText: context.tx('Entrada 1'),
        decimals: 2,
        onChange: (v) => _standalone['a'] = v,
      ),
      const SizedBox(height: 12),
      SgInputNumber(
        id: 'standalone-b',
        labelText: context.tx('Entrada 2'),
        decimals: 2,
        onChange: (v) => _standalone['b'] = v,
      ),
      const SizedBox(height: 12),
      SgInputNumber(
        id: 'standalone-c',
        labelText: context.tx('Entrada 3'),
        decimals: 2,
        onChange: (v) => _standalone['c'] = v,
      ),
      const SizedBox(height: 12),
      SgButton(
        size: SgSize.sm,
        appearance: SgAppearance.outline,
        label: Text(context.tx('Salvar')),
        onClick: () => setState(
          () => _standaloneResult = jsonEncode({
            'a': _standalone['a'] ?? '',
            'b': _standalone['b'] ?? '',
            'c': _standalone['c'] ?? '',
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

  /// Region `sg-input-number-validacao`.
  static const String sgInputNumberValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputNumber(
        id: 'demo-validation',
        labelText: context.tx('Apenas número par'),
        decimals: 0,
        validation: (v) {
          final n = num.tryParse(v);
          return n != null && n % 2 == 0
              ? null
              : context.tx('Use um número par.');
        },
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

  /// Region `sg-input-number-variacoes`.
  static const String sgInputNumberVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputNumber(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        withBorder: false,
        decimals: 2,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputNumber(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        filled: true,
        decimals: 2,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-number-vazio`.
  static const String sgInputNumberVazio = r'''
SizedBox(
  width: 320,
  child: SgInputNumber(
    id: 'demo-empty',
    labelText: context.tx('Pode ficar vazio'),
    emptyValue: SgInputNumberEmptyValue.nullValue,
    decimals: 2,
  ),
)
''';
}
