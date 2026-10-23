// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_text_area_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputTextAreaPageSnippets {
  /// Region `sg-input-text-area-basico`.
  static const String sgInputTextAreaBasico = r'''
const SgInputTextArea(id: 'obs', labelText: 'Observações')
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
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['obs']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
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
}
