// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_text_editor_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgTextEditorPageSnippets {
  /// Region `sg-text-editor-arquivo`.
  static const String sgTextEditorArquivo = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTextEditor(
      id: 'editor-arquivo',
      height: 200,
      fileName: 'nota.html',
      showCssEditor: true,
      cssEditorLabel: 'CSS do documento',
      cssText: _css,
      onCssTextChange: (css) => setState(() => _css = css),
      onSave: (file, meta) => setState(
        () => _arquivo =
            '${file.name}: ${file.bytes.length} bytes, ${meta.cssText.length} caracteres de CSS',
      ),
      onLoad: (meta) => setState(
        () => _arquivo =
            'Carregado: ${meta.contentHtml.length} caracteres',
      ),
    ),
    if (_arquivo.isNotEmpty) Text(_arquivo),
  ],
)
''';

  /// Region `sg-text-editor-basico`.
  static const String sgTextEditorBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTextEditor(
      id: 'editor-basico',
      height: 220,
      placeholder: context.tx('Escreva aqui'),
      defaultValueHtml: '<p>Texto <strong>inicial</strong></p>',
      onChangeHtml: (html) => setState(() => _html = html),
    ),
    const SizedBox(height: 8),
    Text('HTML: $_html'),
  ],
)
''';

  /// Region `sg-text-editor-controlado`.
  static const String sgTextEditorControlado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTextEditor(
      id: 'editor-controlado',
      height: 180,
      valueHtml: _valor,
      onChangeHtml: (html) => setState(() => _valor = html),
    ),
    const SizedBox(height: 8),
    SgButton(
      label: Text(context.tx('Trocar o conteúdo')),
      severity: SgSeverity.secondary,
      onClick: () => setState(
        () =>
            _valor = '<h2>Título</h2><ul><li><p>Item</p></li></ul>',
      ),
    ),
  ],
)
''';

  /// Region `sg-text-editor-estados`.
  static const String sgTextEditorEstados = r'''
const Column(
  children: [
    SgTextEditor(
      id: 'editor-desabilitado',
      height: 120,
      disabled: true,
      defaultValueHtml: '<p>Somente leitura</p>',
    ),
    SizedBox(height: 16),
    SgTextEditor(
      id: 'editor-erro',
      height: 120,
      borderRadius: 20,
      error: 'Conteúdo obrigatório',
    ),
  ],
)
''';

  /// Region `sg-text-editor-formulario`.
  static const String sgTextEditorFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTextEditor(
      id: 'editor-form',
      name: 'descricao',
      control: _form,
      height: 180,
      rules: const SgRules(required: 'Descreva o produto'),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) =>
            setState(() => _enviado = '${values['descricao']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';
}
