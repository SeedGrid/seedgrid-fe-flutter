// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_cnpj_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCnpjPageSnippets {
  /// Region `sg-input-cnpj-alfanumerico`.
  static const String sgInputCnpjAlfanumerico = r'''
SizedBox(
  width: 320,
  child: SgInputCNPJ(
    id: 'demo-alnum',
    labelText: context.tx('CNPJ alfanumérico'),
    hintText: '00.000.000/E08G-12',
    initialValue: '00.000.000/E08G-12',
  ),
)
''';

  /// Region `sg-input-cnpj-basico`.
  static const String sgInputCnpjBasico = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCNPJ(
        id: 'demo-basic',
        labelText: context.tx('CNPJ'),
        hintText: context.tx('00.000.000/0000-00'),
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

  /// Region `sg-input-cnpj-consulta`.
  static const String sgInputCnpjConsulta = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgInputCNPJ(
        id: 'demo-publica',
        labelText: context.tx('CNPJ'),
        hintText: context.tx('00.000.000/0000-00'),
        validateWithPublicaCnpj: true,
        publicaCnpjErrorMessage: context.tx('CNPJ não encontrado.'),
        onPublicaCnpjResult: (data) {
          _publicaResultado.value = data;
          _publicaErro.value = null;
        },
        onPublicaCnpjError: (_) => _publicaErro.value = context.tx(
          'Falha ao consultar API.',
        ),
      ),
    ),
    ListenableBuilder(
      listenable: Listenable.merge([
        _publicaResultado,
        _publicaErro,
      ]),
      builder: (context, _) {
        final resultado = _publicaResultado.value;
        final erro = _publicaErro.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resultado != null) ...[
              const SizedBox(height: 8),
              Text(context.tx('Resultado Publica CNPJ')),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: SingleChildScrollView(
                  child: SelectableText(
                    const JsonEncoder.withIndent(
                      '  ',
                    ).convert(resultado),
                  ),
                ),
              ),
            ],
            if (erro != null) Text(erro),
          ],
        );
      },
    ),
    const SizedBox(height: 8),
    Text(
      context.tx(
        'Se a API estiver fora do ar, o componente não bloqueia o usuário.',
      ),
    ),
  ],
)
''';

  /// Region `sg-input-cnpj-desabilitado`.
  static const String sgInputCnpjDesabilitado = r'''
SizedBox(
  width: 320,
  child: SgInputCNPJ(
    id: 'demo-disabled',
    labelText: context.tx('Desabilitado'),
    hintText: context.tx('CNPJ'),
    enabled: false,
    initialValue: '00.000.000/0000-00',
  ),
)
''';

  /// Region `sg-input-cnpj-eventos`.
  static const String sgInputCnpjEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCNPJ(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        hintText: context.tx('CNPJ'),
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

  /// Region `sg-input-cnpj-formulario-control`.
  static const String sgInputCnpjFormularioControl = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCNPJ(
        id: 'cnpj-control',
        name: 'cnpj',
        labelText: context.tx('CNPJ'),
        control: _formControl,
      ),
      const SizedBox(height: 8),
      ListenableBuilder(
        listenable: _formControl,
        builder: (context, _) {
          final value = '${_formControl.getValue('cnpj') ?? ''}';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.tx('Valor no formulário')}: "$value"',
              ),
              Text(
                '${context.tx('Só os dígitos')}: "${value.replaceAll(RegExp(r'\D'), '')}"',
              ),
            ],
          );
        },
      ),
    ],
  ),
)
''';

  /// Region `sg-input-cnpj-formulario-register`.
  static const String sgInputCnpjFormularioRegister = r'''
SgForm(
  defaultValues: {'cnpj': '11222333000181'},
  child: Builder(
    builder: (context) {
      final form = SgForm.of(context);
      return SizedBox(
        width: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SgInputCNPJ(
              id: 'cnpj-register',
              name: 'cnpj',
              labelText: context.tx('CNPJ'),
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: form,
              builder: (context, _) {
                final value = '${form.getValue('cnpj') ?? ''}';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.tx('Valor no formulário')}: "$value"',
                    ),
                    Text(
                      '${context.tx('Só os dígitos')}: "${value.replaceAll(RegExp(r'\D'), '')}"',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    },
  ),
)
''';

  /// Region `sg-input-cnpj-invalida`.
  static const String sgInputCnpjInvalida = r'''
SizedBox(
  width: 320,
  child: SgInputCNPJ(
    id: 'demo-invalid',
    labelText: context.tx('CNPJ'),
    hintText: context.tx('00.000.000/0000-00'),
    invalidMessage: context.tx('CNPJ inválido.'),
  ),
)
''';

  /// Region `sg-input-cnpj-largura`.
  static const String sgInputCnpjLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputCNPJ(
      id: 'demo-w200',
      labelText: context.tx('200px'),
      hintText: context.tx('CNPJ'),
      width: 200,
    ),
    SgInputCNPJ(
      id: 'demo-w300',
      labelText: context.tx('300px arredondado'),
      hintText: context.tx('CNPJ'),
      width: 300,
      borderRadius: 20,
    ),
  ],
)
''';

  /// Region `sg-input-cnpj-lista-alfanumerica`.
  static const String sgInputCnpjListaAlfanumerica = r'''
const SelectableText(
  '// Exemplos válidos\n'
  '00.000.000/E08G-12  (raw: 00000000E08G12)\n'
  'GK.IPC.PIK/0001-52  (raw: GKIPCPIK000152)\n'
  'AB.12C.345/D6E7-99  (raw: AB12C345D6E799)\n'
  '12.ABC.345/DE67-34  (raw: 12ABC345DE6734)\n'
  'A1.B2C.3D4/E5F6-68  (raw: A1B2C3D4E5F668)\n'
  'ZX.CVB.NM1/2345-84  (raw: ZXCVBNM1234584)',
  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
)
''';

  /// Region `sg-input-cnpj-obrigatorio`.
  static const String sgInputCnpjObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputCNPJ(
        id: 'demo-required',
        labelText: context.tx('CNPJ obrigatório'),
        hintText: context.tx('Obrigatório'),
        required: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputCNPJ(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        hintText: context.tx('Obrigatório'),
        required: true,
        requiredMessage: context.tx('Informe o CNPJ.'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-cnpj-rotulo`.
  static const String sgInputCnpjRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputCNPJ(
        id: 'sg-input-cnpj-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputCNPJLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputCNPJ(
        id: 'sg-input-cnpj-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputCNPJLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputCNPJ(
        id: 'sg-input-cnpj-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputCNPJLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputCNPJLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-cnpj-sem-limpar`.
  static const String sgInputCnpjSemLimpar = r'''
SizedBox(
  width: 320,
  child: SgInputCNPJ(
    id: 'demo-noclear',
    labelText: context.tx('Sem limpar'),
    hintText: context.tx('CNPJ'),
    clearButton: false,
  ),
)
''';

  /// Region `sg-input-cnpj-tamanho`.
  static const String sgInputCnpjTamanho = r'''
SizedBox(
  width: 320,
  child: SgInputCNPJ(
    id: 'demo-length',
    labelText: context.tx('CNPJ'),
    hintText: context.tx('00.000.000/0000-00'),
    lengthMessage: context.tx('CNPJ deve ter 14 dígitos.'),
  ),
)
''';

  /// Region `sg-input-cnpj-validacao`.
  static const String sgInputCnpjValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCNPJ(
        id: 'demo-validation',
        labelText: context.tx('CNPJ'),
        hintText: context.tx('00.000.000/0000-00'),
        validation: (v) => v.startsWith('00')
            ? context.tx('CNPJ não pode iniciar com 00.')
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

  /// Region `sg-input-cnpj-variacoes`.
  static const String sgInputCnpjVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputCNPJ(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        hintText: context.tx('CNPJ'),
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputCNPJ(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        hintText: context.tx('CNPJ'),
        filled: true,
      ),
    ),
  ],
)
''';
}
