// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_text_area_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputTextAreaPageSnippets {
  /// Region `sg-input-text-area-basico`.
  static const String sgInputTextAreaBasico = r'''
const SgInputTextArea(id: 'obs', labelText: 'Observações')
''';

  /// Region `sg-input-text-area-elevacao`.
  static const String sgInputTextAreaElevacao = r'''
const Column(
  children: [
    SgInputTextArea(
      id: 'sm',
      labelText: 'Sombra pequena',
      elevation: SgInputTextAreaElevation.sm,
    ),
    SizedBox(height: 12),
    SgInputTextArea(
      id: 'lg',
      labelText: 'Sombra grande',
      elevation: SgInputTextAreaElevation.lg,
    ),
  ],
)
''';

  /// Region `sg-input-text-area-erro-externo`.
  static const String sgInputTextAreaErroExterno = r'''
const SgInputTextArea(
  id: 'erro',
  labelText: 'Observação',
  initialValue: 'texto recusado',
  error: 'Conteúdo não permitido',
)
''';

  /// Region `sg-input-text-area-estados`.
  static const String sgInputTextAreaEstados = r'''
const Column(
  children: [
    SgInputTextArea(
      id: 'desabilitado',
      labelText: 'Desabilitado',
      initialValue: 'não edita',
      disabled: true,
    ),
    SizedBox(height: 12),
    SgInputTextArea(
      id: 'leitura',
      labelText: 'Somente leitura',
      initialValue: 'só leitura',
      readOnly: true,
    ),
  ],
)
''';

  /// Region `sg-input-text-area-eventos`.
  static const String sgInputTextAreaEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputTextArea(
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

  /// Region `sg-input-text-area-formulario`.
  static const String sgInputTextAreaFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputTextArea(
      id: 'f-obs',
      name: 'obs',
      control: _form,
      labelText: 'Observações',
      required: true,
      rules: const SgRules(
        minLength: SgRuleValue(
          10,
          'Escreva pelo menos 10 caracteres',
        ),
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['obs']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-input-text-area-icone`.
  static const String sgInputTextAreaIcone = r'''
const SgInputTextArea(
  id: 'icone',
  labelText: 'Comentário',
  prefixIcon: Icon(Icons.chat_bubble_outline, size: 18),
)
''';

  /// Region `sg-input-text-area-largura`.
  static const String sgInputTextAreaLargura = r'''
const SgInputTextArea(
  id: 'largura',
  labelText: 'Arredondado',
  width: 240,
  borderRadius: 20,
)
''';

  /// Region `sg-input-text-area-limites`.
  static const String sgInputTextAreaLimites = r'''
const Column(
  children: [
    SgInputTextArea(
      id: 'max',
      labelText: 'No máximo 60 caracteres',
      maxLength: 60,
      showCharCounter: true,
    ),
    SizedBox(height: 12),
    SgInputTextArea(
      id: 'palavras',
      labelText: 'Pelo menos 5 palavras',
      minNumberOfWords: 5,
    ),
    SizedBox(height: 12),
    SgInputTextArea(
      id: 'minlinhas',
      labelText: 'Pelo menos 3 linhas',
      minLines: 3,
      maxLines: 4,
    ),
  ],
)
''';

  /// Region `sg-input-text-area-linhas`.
  static const String sgInputTextAreaLinhas = r'''
const Column(
  children: [
    SgInputTextArea(
      id: 'linhas',
      labelText: '5 linhas',
      maxLines: 5,
    ),
    SizedBox(height: 12),
    SgInputTextArea(
      id: 'topo',
      labelText: 'Rótulo no topo, 120 px de altura',
      labelPosition: SgInputTextAreaLabelPosition.top,
      hintText: 'Escreva aqui',
      height: 120,
    ),
    SizedBox(height: 12),
    SgInputTextArea(
      id: 'esquerda',
      labelText: 'À esquerda',
      labelPosition: SgInputTextAreaLabelPosition.left,
      labelWidth: 110,
    ),
  ],
)
''';

  /// Region `sg-input-text-area-linhas-minimas`.
  static const String sgInputTextAreaLinhasMinimas = r'''
const SgInputTextArea(
  id: 'minlinhas',
  labelText: 'Endereço em 2 linhas',
  minLines: 2,
  minLinesMessage: 'Use pelo menos 2 linhas',
)
''';

  /// Region `sg-input-text-area-palavras`.
  static const String sgInputTextAreaPalavras = r'''
const SgInputTextArea(
  id: 'palavras',
  labelText: 'Resumo',
  minNumberOfWords: 5,
  minNumberOfWordsMessage: 'Escreva pelo menos 5 palavras',
)
''';

  /// Region `sg-input-text-area-sem-limpar`.
  static const String sgInputTextAreaSemLimpar = r'''
const SgInputTextArea(
  id: 'semlimpar',
  labelText: 'Sem limpar',
  initialValue: 'texto fixo',
  clearButton: false,
)
''';

  /// Region `sg-input-text-area-validacao`.
  static const String sgInputTextAreaValidacao = r'''
SgInputTextArea(
  id: 'justificativa',
  labelText: 'Justificativa',
  required: true,
  requiredMessage: 'Explique o motivo',
  validation: (v) => v.toLowerCase().contains('urgente')
      ? 'Evite a palavra "urgente"'
      : null,
)
''';

  /// Region `sg-input-text-area-variacoes`.
  static const String sgInputTextAreaVariacoes = r'''
const Column(
  children: [
    SgInputTextArea(
      id: 'preenchido',
      labelText: 'Preenchido',
      filled: true,
    ),
    SizedBox(height: 12),
    SgInputTextArea(
      id: 'vazado',
      labelText: 'Sem preenchimento',
      filled: false,
    ),
    SizedBox(height: 12),
    SgInputTextArea(
      id: 'semborda',
      labelText: 'Sem borda',
      withBorder: false,
    ),
  ],
)
''';
}
