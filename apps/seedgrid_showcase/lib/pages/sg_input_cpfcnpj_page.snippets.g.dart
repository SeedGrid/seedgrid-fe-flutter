// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_cpfcnpj_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputCpfcnpjPageSnippets {
  /// Region `sg-input-cpf-cnpj-alfanumerico`.
  static const String sgInputCpfCnpjAlfanumerico = r'''
SizedBox(
  width: 320,
  child: SgInputCPFCNPJ(
    id: 'demo-alnum',
    labelText: context.tx('CNPJ alfanumérico'),
    hintText: '00.000.000/E08G-12',
    initialValue: '00.000.000/E08G-12',
  ),
)
''';

  /// Region `sg-input-cpf-cnpj-basico`.
  static const String sgInputCpfCnpjBasico = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCPFCNPJ(
        id: 'demo-basic',
        labelText: context.tx('Documento'),
        hintText: context.tx('CPF ou CNPJ'),
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

  /// Region `sg-input-cpf-cnpj-consulta`.
  static const String sgInputCpfCnpjConsulta = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgInputCPFCNPJ(
        id: 'demo-publica',
        labelText: context.tx('Documento'),
        hintText: context.tx('CPF ou CNPJ'),
        validateWithPublicaCnpj: true,
        publicaCnpjErrorMessage: context.tx('CNPJ não encontrado.'),
        onPublicaCnpjResult: (data) {
          _publicaResultado.value = data;
          _publicaErro.value = null;
        },
        onPublicaCnpjError: (_) => _publicaErro.value = context.tx(
          'Falha ao consultar a API.',
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
              Text(context.tx('Resultado da consulta')),
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
  ],
)
''';

  /// Region `sg-input-cpf-cnpj-desabilitado`.
  static const String sgInputCpfCnpjDesabilitado = r'''
SizedBox(
  width: 320,
  child: SgInputCPFCNPJ(
    id: 'demo-disabled',
    labelText: context.tx('Desabilitado'),
    hintText: context.tx('Documento'),
    enabled: false,
    initialValue: '00.000.000/0000-00',
  ),
)
''';

  /// Region `sg-input-cpf-cnpj-eventos`.
  static const String sgInputCpfCnpjEventos = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCPFCNPJ(
        id: 'demo-events',
        labelText: context.tx('Digite e observe o log'),
        hintText: context.tx('Documento'),
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

  /// Region `sg-input-cpf-cnpj-formulario-control`.
  static const String sgInputCpfCnpjFormularioControl = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCPFCNPJ(
        id: 'documento-control',
        name: 'documento',
        labelText: context.tx('Documento'),
        control: _formControl,
      ),
      const SizedBox(height: 8),
      ListenableBuilder(
        listenable: _formControl,
        builder: (context, _) {
          final value =
              '${_formControl.getValue('documento') ?? ''}';
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

  /// Region `sg-input-cpf-cnpj-formulario-register`.
  static const String sgInputCpfCnpjFormularioRegister = r'''
SgForm(
  defaultValues: {'documento': '52998224725'},
  child: Builder(
    builder: (context) {
      final form = SgForm.of(context);
      return SizedBox(
        width: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SgInputCPFCNPJ(
              id: 'documento-register',
              name: 'documento',
              labelText: context.tx('Documento'),
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: form,
              builder: (context, _) {
                final value = '${form.getValue('documento') ?? ''}';
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

  /// Region `sg-input-cpf-cnpj-invalida`.
  static const String sgInputCpfCnpjInvalida = r'''
SizedBox(
  width: 320,
  child: SgInputCPFCNPJ(
    id: 'demo-invalid',
    labelText: context.tx('Documento'),
    hintText: context.tx('CPF ou CNPJ'),
    invalidMessage: context.tx('Documento inválido.'),
  ),
)
''';

  /// Region `sg-input-cpf-cnpj-largura`.
  static const String sgInputCpfCnpjLargura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SgInputCPFCNPJ(
      id: 'demo-w200',
      labelText: context.tx('200px'),
      hintText: context.tx('Documento'),
      width: 200,
    ),
    SgInputCPFCNPJ(
      id: 'demo-w300',
      labelText: context.tx('300px arredondado'),
      hintText: context.tx('Documento'),
      width: 300,
      borderRadius: 20,
    ),
  ],
)
''';

  /// Region `sg-input-cpf-cnpj-lista-alfanumerica`.
  static const String sgInputCpfCnpjListaAlfanumerica = r'''
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

  /// Region `sg-input-cpf-cnpj-obrigatorio`.
  static const String sgInputCpfCnpjObrigatorio = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputCPFCNPJ(
        id: 'demo-required',
        labelText: context.tx('Documento obrigatório'),
        hintText: context.tx('Obrigatório'),
        required: true,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputCPFCNPJ(
        id: 'demo-required-custom',
        labelText: context.tx('Mensagem customizada'),
        hintText: context.tx('Obrigatório'),
        required: true,
        requiredMessage: context.tx('Informe o CPF/CNPJ.'),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-cpf-cnpj-rotulo`.
  static const String sgInputCpfCnpjRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputCPFCNPJ(
        id: 'sg-input-cpf-cnpj-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputCPFCNPJLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputCPFCNPJ(
        id: 'sg-input-cpf-cnpj-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputCPFCNPJLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputCPFCNPJ(
        id: 'sg-input-cpf-cnpj-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputCPFCNPJLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputCPFCNPJLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-cpf-cnpj-sem-limpar`.
  static const String sgInputCpfCnpjSemLimpar = r'''
SizedBox(
  width: 320,
  child: SgInputCPFCNPJ(
    id: 'demo-noclear',
    labelText: context.tx('Sem limpar'),
    hintText: context.tx('Documento'),
    clearButton: false,
  ),
)
''';

  /// Region `sg-input-cpf-cnpj-validacao`.
  static const String sgInputCpfCnpjValidacao = r'''
SizedBox(
  width: 320,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputCPFCNPJ(
        id: 'demo-validation',
        labelText: context.tx('Documento'),
        hintText: context.tx('CPF ou CNPJ'),
        validation: (v) => v.startsWith('00')
            ? context.tx('Documento não pode iniciar com 00.')
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

  /// Region `sg-input-cpf-cnpj-variacoes`.
  static const String sgInputCpfCnpjVariacoes = r'''
Column(
  children: [
    SizedBox(
      width: 320,
      child: SgInputCPFCNPJ(
        id: 'demo-noborder',
        labelText: context.tx('Sem borda'),
        hintText: context.tx('Documento'),
        withBorder: false,
      ),
    ),
    const SizedBox(height: 12),
    SizedBox(
      width: 320,
      child: SgInputCPFCNPJ(
        id: 'demo-filled',
        labelText: context.tx('Preenchido'),
        hintText: context.tx('Documento'),
        filled: true,
      ),
    ),
  ],
)
''';
}
