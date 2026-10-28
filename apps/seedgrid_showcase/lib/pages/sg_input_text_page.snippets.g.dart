// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_text_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputTextPageSnippets {
  /// Region `sg-input-text-afixos`.
  static const String sgInputTextAfixos = r'''
const SgInputText(
  id: 'valor',
  labelText: 'Valor',
  prefixText: r'R$ ',
  suffixText: ' /mês',
  maxLength: 12,
  showCharCounter: true,
)
''';

  /// Region `sg-input-text-basico`.
  static const String sgInputTextBasico = r'''
SgInputText(
  id: 'nome',
  labelText: 'Nome',
  placeholder: context.tx('Digite seu nome'),
)
''';

  /// Region `sg-input-text-botoes`.
  static const String sgInputTextBotoes = r'''
SgInputText(
  id: 'botoes',
  labelText: 'Endereço',
  iconButtons: [
    SgButton(
      iconOnly: true,
      size: SgSize.sm,
      appearance: SgAppearance.outline,
      leftIcon: const Icon(Icons.place_outlined),
      onClick: () => setState(() => _evento = 'localizar'),
    ),
    SgButton(
      iconOnly: true,
      size: SgSize.sm,
      appearance: SgAppearance.outline,
      leftIcon: const Icon(Icons.copy),
      onClick: () => setState(() => _evento = 'copiar'),
    ),
  ],
)
''';

  /// Region `sg-input-text-elevacao`.
  static const String sgInputTextElevacao = r'''
const Column(
  children: [
    SgInputText(
      id: 'sm',
      labelText: 'Sombra pequena',
      elevation: SgInputTextElevation.sm,
    ),
    SizedBox(height: 12),
    SgInputText(
      id: 'lg',
      labelText: 'Sombra grande',
      elevation: SgInputTextElevation.lg,
    ),
  ],
)
''';

  /// Region `sg-input-text-erro-externo`.
  static const String sgInputTextErroExterno = r'''
const SgInputText(
  id: 'erro',
  labelText: 'Usuário',
  initialValue: 'admin',
  error: 'Usuário já existe',
)
''';

  /// Region `sg-input-text-estados`.
  static const String sgInputTextEstados = r'''
const Column(
  children: [
    SgInputText(
      id: 'desabilitado',
      labelText: 'Desabilitado',
      initialValue: 'não edita',
      disabled: true,
    ),
    SizedBox(height: 12),
    SgInputText(
      id: 'leitura',
      labelText: 'Somente leitura',
      initialValue: 'só leitura',
      readOnly: true,
    ),
  ],
)
''';

  /// Region `sg-input-text-eventos`.
  static const String sgInputTextEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputText(
      id: 'eventos',
      labelText: 'Digite aqui',
      onChange: (v) => setState(() => _evento = 'onChange: $v'),
      onEnter: () => setState(() => _evento = 'onEnter'),
      onExit: () => setState(() => _evento = 'onExit'),
      onClear: () => setState(() => _evento = 'onClear'),
    ),
    const SizedBox(height: 8),
    Text('Último evento: $_evento'),
  ],
)
''';

  /// Region `sg-input-text-formulario`.
  static const String sgInputTextFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputText(
      id: 'email',
      name: 'email',
      control: _form,
      labelText: 'E-mail',
      rules: SgRules(
        required: 'Informe o e-mail',
        pattern: SgRuleValue(
          RegExp(r'.+@.+\..+'),
          'E-mail inválido',
        ),
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['email']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-input-text-icone`.
  static const String sgInputTextIcone = r'''
const SgInputText(
  id: 'icone',
  labelText: 'Buscar',
  prefixIcon: Icon(Icons.search, size: 18),
)
''';

  /// Region `sg-input-text-largura`.
  static const String sgInputTextLargura = r'''
const SgInputText(
  id: 'largura',
  labelText: 'Arredondado',
  width: 240,
  borderRadius: 20,
)
''';

  /// Region `sg-input-text-palavras`.
  static const String sgInputTextPalavras = r'''
const SgInputText(
  id: 'palavras',
  labelText: 'Nome completo',
  minNumberOfWords: 2,
  minNumberOfWordsMessage: 'Informe nome e sobrenome',
)
''';

  /// Region `sg-input-text-rotulo`.
  static const String sgInputTextRotulo = r'''
const Column(
  children: [
    SgInputText(
      id: 'topo',
      labelText: 'Rótulo no topo',
      labelPosition: SgInputTextLabelPosition.top,
    ),
    SizedBox(height: 12),
    SgInputText(
      id: 'esquerda',
      labelText: 'À esquerda',
      labelPosition: SgInputTextLabelPosition.left,
      labelWidth: 110,
    ),
  ],
)
''';

  /// Region `sg-input-text-sem-limpar`.
  static const String sgInputTextSemLimpar = r'''
const SgInputText(
  id: 'semlimpar',
  labelText: 'Sem limpar',
  initialValue: 'texto fixo',
  clearButton: false,
)
''';

  /// Region `sg-input-text-validacao`.
  static const String sgInputTextValidacao = r'''
Column(
  children: [
    const SgInputText(
      id: 'obrigatorio',
      labelText: 'Obrigatório',
      required: true,
    ),
    const SizedBox(height: 12),
    const SgInputText(
      id: 'minimo',
      labelText: 'Mínimo de 5 letras',
      minLength: 5,
    ),
    const SizedBox(height: 12),
    SgInputText(
      id: 'proprio',
      labelText: 'Só aceita "ok"',
      validation: (v) => v == 'ok' ? null : 'Digite ok',
    ),
  ],
)
''';

  /// Region `sg-input-text-variacoes`.
  static const String sgInputTextVariacoes = r'''
const Column(
  children: [
    SgInputText(
      id: 'preenchido',
      labelText: 'Preenchido',
      filled: true,
    ),
    SizedBox(height: 12),
    SgInputText(
      id: 'vazado',
      labelText: 'Sem preenchimento',
      filled: false,
    ),
    SizedBox(height: 12),
    SgInputText(
      id: 'semborda',
      labelText: 'Sem borda',
      withBorder: false,
    ),
  ],
)
''';
}
