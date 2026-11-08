// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_text_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputTextPageSnippets {
  /// Region `sg-input-text-afixos`.
  static const String sgInputTextAfixos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-suffix',
        labelText: context.tx('Email'),
        suffixText: '@gmail.com',
        onChange: (v) => _sufixo.value = v,
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _sufixo,
      builder: (context, valor, _) =>
          Text('${context.tx('Valor completo')}: $valor'),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-prefix-text',
        labelText: context.tx('Website'),
        prefixText: 'www.',
        onChange: (v) => _prefixo.value = v,
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _prefixo,
      builder: (context, valor, _) =>
          Text('${context.tx('Valor completo')}: $valor'),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 384,
      child: SgInputText(
        id: 'demo-both',
        labelText: context.tx('Domínio'),
        prefixText: 'www.',
        suffixText: '.seedgrid.com.br',
        onChange: (v) => _ambos.value = v,
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _ambos,
      builder: (context, valor, _) =>
          Text('${context.tx('Valor completo')}: $valor'),
    ),
  ],
)
''';

  /// Region `sg-input-text-basico`.
  static const String sgInputTextBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-basic',
        labelText: context.tx('Nome completo'),
        name: 'nome',
        control: _form,
      ),
    ),
    const SizedBox(height: 8),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = '${values['nome']}',
      ),
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, enviado, _) =>
          Text('${context.tx('Valor')}: $enviado'),
    ),
  ],
)
''';

  /// Region `sg-input-text-botoes`.
  static const String sgInputTextBotoes = r'''
SizedBox(
  width: 384,
  child: Column(
    children: [
      SgInputText(
        id: 'demo-iconbtns',
        labelText: context.tx('Texto para copiar'),
        iconButtons: [
          SgButton(
            iconOnly: true,
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            leftIcon: const Icon(Icons.copy),
            onClick: () => _iconLog.value = [
              context.tx('Copiado'),
              ..._iconLog.value,
            ],
          ),
          SgButton(
            iconOnly: true,
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            leftIcon: const Icon(Icons.notifications_outlined),
            onClick: () => _iconLog.value = [
              context.tx('Alerta disparado!'),
              ..._iconLog.value,
            ],
          ),
        ],
      ),
      const SizedBox(height: 12),
      ValueListenableBuilder<List<String>>(
        valueListenable: _iconLog,
        builder: (context, entries, _) => ShowcaseLogBox(
          entries: entries,
          hint: context.tx('Digite algo e clique nos ícones...'),
          height: 96,
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-contador`.
  static const String sgInputTextContador = r'''
SizedBox(
  width: 320,
  child: SgInputText(
    id: 'demo-counter',
    labelText: context.tx('Máximo 20 caracteres'),
    maxLength: 20,
    showCharCounter: true,
  ),
)
''';

  /// Region `sg-input-text-controlado`.
  static const String sgInputTextControlado = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputText(
        id: 'demo-controlled',
        labelText: context.tx('Nome do cliente'),
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
            label: Text(
              context.tx('Simular preenchimento via API'),
            ),
            onClick: () => _form.setValue(
              'controlled',
              context.tx('Texto vindo da API'),
            ),
          ),
          SgButton(
            appearance: SgAppearance.outline,
            label: Text(context.tx('Setar outro valor')),
            onClick: () => _form.setValue(
              'controlled',
              context.tx('Outro valor'),
            ),
          ),
          SgButton(
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

  /// Region `sg-input-text-elevacao`.
  static const String sgInputTextElevacao = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputText(
        id: 'sg-input-text-elevation-none',
        labelText: context.tx('Elevação none'),
        elevation: SgInputTextElevation.none,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputText(
        id: 'sg-input-text-elevation-sm',
        labelText: context.tx('Elevação sm'),
        elevation: SgInputTextElevation.sm,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputText(
        id: 'sg-input-text-elevation-md',
        labelText: context.tx('Elevação md'),
        elevation: SgInputTextElevation.md,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputText(
        id: 'sg-input-text-elevation-lg',
        labelText: context.tx('Elevação lg'),
        elevation: SgInputTextElevation.lg,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-erro-externo`.
  static const String sgInputTextErroExterno = r'''
SizedBox(
  width: 320,
  child: SgInputText(
    id: 'demo-error',
    labelText: context.tx('Com erro externo'),
    error: context.tx('Este email já está cadastrado.'),
  ),
)
''';

  /// Region `sg-input-text-estados`.
  static const String sgInputTextEstados = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-disabled',
        labelText: context.tx('Desabilitado'),
        initialValue: context.tx('Não editável'),
        enabled: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-readonly',
        labelText: context.tx('Somente leitura'),
        initialValue: context.tx('Apenas leitura'),
        readOnly: true,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-eventos`.
  static const String sgInputTextEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputText(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        required: true,
        onChange: (v) => _log('onChange: "$v"'),
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
          hint: context.tx('Interaja com o input...'),
          height: 160,
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-icone`.
  static const String sgInputTextIcone = r'''
SizedBox(
  width: 320,
  child: SgInputText(
    id: 'demo-prefix',
    labelText: context.tx('Buscar'),
    prefixIcon: const Icon(Icons.search, size: 16),
  ),
)
''';

  /// Region `sg-input-text-largura`.
  static const String sgInputTextLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputText(
      id: 'demo-w200',
      labelText: context.tx('200px'),
      width: 200,
    ),
    SgInputText(
      id: 'demo-w300',
      labelText: context.tx('300px arredondado'),
      width: 300,
      borderRadius: 20,
    ),
  ],
)
''';

  /// Region `sg-input-text-obrigatorio`.
  static const String sgInputTextObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-required',
        labelText: context.tx('Campo obrigatório'),
        required: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        required: true,
        requiredMessage: context.tx('Preencha este campo!'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-palavras`.
  static const String sgInputTextPalavras = r'''
SizedBox(
  width: 320,
  child: SgInputText(
    id: 'demo-words',
    labelText: context.tx('Mínimo 3 palavras'),
    minNumberOfWords: 3,
    minNumberOfWordsMessage: context.tx(
      'Digite pelo menos 3 palavras.',
    ),
  ),
)
''';

  /// Region `sg-input-text-rotulo`.
  static const String sgInputTextRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputText(
        id: 'sg-input-text-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputTextLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputText(
        id: 'sg-input-text-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputTextLabelPosition.top,
        elevation: SgInputTextElevation.md,
        withBorder: false,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputText(
        id: 'sg-input-text-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputTextLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputTextLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-text-sem-limpar`.
  static const String sgInputTextSemLimpar = r'''
SizedBox(
  width: 320,
  child: SgInputText(
    id: 'demo-noclear',
    labelText: context.tx('Sem limpar'),
    clearButton: false,
  ),
)
''';

  /// Region `sg-input-text-standalone`.
  static const String sgInputTextStandalone = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputText(
        id: 'standalone-nome',
        labelText: context.tx('Nome'),
        onChange: (v) => _standalone['nome'] = v,
      ),
      const SizedBox(height: 12),
      SgInputText(
        id: 'standalone-email',
        labelText: context.tx('E-mail'),
        onChange: (v) => _standalone['email'] = v,
      ),
      const SizedBox(height: 12),
      SgInputText(
        id: 'standalone-cpf',
        labelText: context.tx('CPF'),
        onChange: (v) => _standalone['cpf'] = v,
      ),
      const SizedBox(height: 12),
      SgButton(
        label: Text(context.tx('Salvar')),
        onClick: () => _log(
          '[${context.tx('salvar')}] ${{'nome': _standalone['nome'] ?? '', 'email': _standalone['email'] ?? '', 'cpf': _standalone['cpf'] ?? ''}}',
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-tamanho-minimo`.
  static const String sgInputTextTamanhoMinimo = r'''
SizedBox(
  width: 320,
  child: SgInputText(
    id: 'demo-minlength',
    labelText: context.tx('Mínimo 5 caracteres'),
    minLength: 5,
    showCharCounter: true,
  ),
)
''';

  /// Region `sg-input-text-validacao`.
  static const String sgInputTextValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputText(
        id: 'demo-validation',
        labelText: context.tx('Apenas letras'),
        validation: (v) =>
            RegExp(r'[^\p{L}\s]', unicode: true).hasMatch(v)
            ? context.tx('Apenas letras são permitidas.')
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

  /// Region `sg-input-text-variacoes`.
  static const String sgInputTextVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputText(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        filled: true,
      ),
    ),
  ],
)
''';
}
