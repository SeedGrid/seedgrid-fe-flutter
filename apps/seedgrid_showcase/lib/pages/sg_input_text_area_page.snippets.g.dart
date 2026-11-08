// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_text_area_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputTextAreaPageSnippets {
  /// Region `sg-input-text-area-basico`.
  static const String sgInputTextAreaBasico = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputTextArea(
        id: 'demo-basic',
        labelText: context.tx('Descrição'),
        onChange: (v) => _basico.value = v,
      ),
      const SizedBox(height: 8),
      ValueListenableBuilder<String>(
        valueListenable: _basico,
        builder: (context, valor, _) =>
            Text('${context.tx('Valor')}: $valor'),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-area-contador`.
  static const String sgInputTextAreaContador = r'''
SizedBox(
  width: 384,
  child: SgInputTextArea(
    id: 'demo-counter',
    labelText: context.tx('Máximo 100 caracteres'),
    maxLength: 100,
    showCharCounter: true,
  ),
)
''';

  /// Region `sg-input-text-area-controlado`.
  static const String sgInputTextAreaControlado = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputTextArea(
        id: 'demo-controlled',
        labelText: context.tx('Observações'),
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
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            label: Text(
              context.tx('Simular preenchimento via API'),
            ),
            onClick: () => _form.setValue(
              'controlled',
              context.tx('Texto preenchido via API.'),
            ),
          ),
          SgButton(
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            label: Text(context.tx('Setar outro valor')),
            onClick: () => _form.setValue(
              'controlled',
              context.tx('Outro valor qualquer'),
            ),
          ),
          SgButton(
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            severity: SgSeverity.danger,
            label: Text(context.tx('Limpar campo')),
            onClick: () => _form.setValue('controlled', ''),
          ),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-area-elevacao`.
  static const String sgInputTextAreaElevacao = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputTextArea(
        id: 'sg-input-text-area-elevation-none',
        labelText: context.tx('Elevação none'),
        elevation: SgInputTextAreaElevation.none,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputTextArea(
        id: 'sg-input-text-area-elevation-sm',
        labelText: context.tx('Elevação sm'),
        elevation: SgInputTextAreaElevation.sm,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputTextArea(
        id: 'sg-input-text-area-elevation-md',
        labelText: context.tx('Elevação md'),
        elevation: SgInputTextAreaElevation.md,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputTextArea(
        id: 'sg-input-text-area-elevation-lg',
        labelText: context.tx('Elevação lg'),
        elevation: SgInputTextAreaElevation.lg,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-area-erro-externo`.
  static const String sgInputTextAreaErroExterno = r'''
SizedBox(
  width: 384,
  child: SgInputTextArea(
    id: 'demo-error',
    labelText: context.tx('Com erro externo'),
    error: context.tx('Descrição muito curta.'),
  ),
)
''';

  /// Region `sg-input-text-area-estados`.
  static const String sgInputTextAreaEstados = r'''
Column(
  children: [
    SizedBox(
      width: 384,
      child: SgInputTextArea(
        id: 'demo-disabled',
        labelText: context.tx('Desabilitado'),
        enabled: false,
        initialValue: context.tx('Não editável'),
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 384,
      child: SgInputTextArea(
        id: 'demo-readonly',
        labelText: context.tx('Somente leitura'),
        readOnly: true,
        initialValue: context.tx('Apenas leitura'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-area-eventos`.
  static const String sgInputTextAreaEventos = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputTextArea(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        required: true,
        onChange: (v) =>
            _log('onChange: "${v.replaceAll('\n', r'\n')}"'),
        onEnter: () => _log(context.tx('onEnter (focus)')),
        onExit: () => _log(context.tx('onExit (blur)')),
        onClear: () => _log('onClear'),
        onValidation: (msg) =>
            _log('onValidation: ${msg ?? context.tx('válido')}'),
      ),
      const SizedBox(height: 12),
      ValueListenableBuilder<List<String>>(
        valueListenable: _eventLog,
        builder: (context, entries, _) => ShowcaseLogBox(
          entries: entries,
          hint: context.tx('Interaja com o textarea...'),
          height: 160,
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-area-icone`.
  static const String sgInputTextAreaIcone = r'''
SizedBox(
  width: 384,
  child: SgInputTextArea(
    id: 'demo-prefix',
    labelText: context.tx('Observações'),
    prefixIcon: const Icon(Icons.notes, size: 16),
  ),
)
''';

  /// Region `sg-input-text-area-largura`.
  static const String sgInputTextAreaLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputTextArea(
      id: 'demo-w250',
      labelText: context.tx('250px'),
      width: 250,
    ),
    SgInputTextArea(
      id: 'demo-w350',
      labelText: context.tx('350px arredondado'),
      width: 350,
      borderRadius: 16,
    ),
  ],
)
''';

  /// Region `sg-input-text-area-linhas`.
  static const String sgInputTextAreaLinhas = r'''
Column(
  children: [
    SizedBox(
      width: 384,
      child: SgInputTextArea(
        id: 'demo-height-small',
        labelText: context.tx('Altura 100px, 2 rows'),
        height: 100,
        maxLines: 2,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 384,
      child: SgInputTextArea(
        id: 'demo-height-large',
        labelText: context.tx('Altura 250px, 8 rows'),
        height: 250,
        maxLines: 8,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-area-linhas-minimo`.
  static const String sgInputTextAreaLinhasMinimo = r'''
SizedBox(
  width: 384,
  child: SgInputTextArea(
    id: 'demo-minlines',
    labelText: context.tx('Mínimo 3 linhas'),
    minLines: 3,
    minLinesMessage: context.tx('Escreva pelo menos 3 linhas.'),
  ),
)
''';

  /// Region `sg-input-text-area-obrigatorio`.
  static const String sgInputTextAreaObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 384,
      child: SgInputTextArea(
        id: 'demo-required',
        labelText: context.tx('Campo obrigatório'),
        required: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 384,
      child: SgInputTextArea(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        required: true,
        requiredMessage: context.tx('Preencha este campo!'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-area-palavras`.
  static const String sgInputTextAreaPalavras = r'''
SizedBox(
  width: 384,
  child: SgInputTextArea(
    id: 'demo-words',
    labelText: context.tx('Mínimo 5 palavras'),
    minNumberOfWords: 5,
    minNumberOfWordsMessage: context.tx(
      'Digite pelo menos 5 palavras.',
    ),
  ),
)
''';

  /// Region `sg-input-text-area-rotulo`.
  static const String sgInputTextAreaRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputTextArea(
        id: 'sg-input-text-area-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputTextAreaLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputTextArea(
        id: 'sg-input-text-area-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputTextAreaLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputTextArea(
        id: 'sg-input-text-area-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputTextAreaLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputTextAreaLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-area-sem-limpar`.
  static const String sgInputTextAreaSemLimpar = r'''
SizedBox(
  width: 384,
  child: SgInputTextArea(
    id: 'demo-noclear',
    labelText: context.tx('Sem limpar'),
    clearButton: false,
  ),
)
''';

  /// Region `sg-input-text-area-tamanho-minimo`.
  static const String sgInputTextAreaTamanhoMinimo = r'''
SizedBox(
  width: 384,
  child: SgInputTextArea(
    id: 'demo-minlength',
    labelText: context.tx('Mínimo 10 caracteres'),
    minLength: 10,
    showCharCounter: true,
  ),
)
''';

  /// Region `sg-input-text-area-validacao`.
  static const String sgInputTextAreaValidacao = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputTextArea(
        id: 'demo-validation',
        labelText: context.tx('Sem números'),
        validation: (v) => RegExp(r'\d').hasMatch(v)
            ? context.tx('Números não são permitidos.')
            : null,
        onValidation: (msg) => _validationMsg.value = msg,
      ),
      const SizedBox(height: 8),
      ValueListenableBuilder<String?>(
        valueListenable: _validationMsg,
        builder: (context, msg, _) => Text(
          'onValidation: ${msg == null ? context.tx('válido') : '"$msg"'}',
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-area-variacoes`.
  static const String sgInputTextAreaVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 384,
      child: SgInputTextArea(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 384,
      child: SgInputTextArea(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        filled: true,
      ),
    ),
  ],
)
''';
}
