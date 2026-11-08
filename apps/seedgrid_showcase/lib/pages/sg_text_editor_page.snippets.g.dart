// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_text_editor_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgTextEditorPageSnippets {
  /// Region `sg-text-editor-arquivo`.
  static const String sgTextEditorArquivo = r'''
SgStack(
  gap: 8,
  align: SgStackAlign.start,
  children: [
    ValueListenableBuilder<String>(
      valueListenable: _cssArquivo,
      builder: (context, css, _) => SgTextEditor(
        id: 'sg-text-editor-file',
        height: 200,
        fileName: 'nota.html',
        showCssEditor: true,
        cssEditorLabel: 'CSS do documento',
        cssText: css,
        onCssTextChange: (v) => _cssArquivo.value = v,
        onSave: (file, meta) => _arquivo.value =
            '${file.name}: ${file.bytes.length} bytes, ${meta.cssText.length} caracteres de CSS',
        onLoad: (meta) => _arquivo.value =
            'Carregado: ${meta.contentHtml.length} caracteres',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _arquivo,
      builder: (context, v, _) =>
          v.isEmpty ? const SizedBox.shrink() : Text(v),
    ),
  ],
)
''';

  /// Region `sg-text-editor-basico`.
  static const String sgTextEditorBasico = r'''
SgStack(
  gap: 8,
  align: SgStackAlign.start,
  children: [
    ListenableBuilder(
      listenable: Listenable.merge([_html, _css]),
      builder: (context, _) => SgTextEditor(
        id: 'sg-text-editor',
        height: 220,
        valueHtml: _html.value,
        onChangeHtml: (html) => _html.value = html,
        cssText: _css.value,
        onCssTextChange: (css) => _css.value = css,
        showCssEditor: true,
        onSave: (file, meta) =>
            _baixado.value = '${file.name}: ${file.bytes.length} bytes',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _baixado,
      builder: (context, v, _) =>
          v.isEmpty ? const SizedBox.shrink() : Text(v),
    ),
  ],
)
''';

  /// Region `sg-text-editor-controlado`.
  static const String sgTextEditorControlado = r'''
SgStack(
  gap: 8,
  align: SgStackAlign.start,
  children: [
    ValueListenableBuilder<String>(
      valueListenable: _valor,
      builder: (context, v, _) => SgTextEditor(
        id: 'sg-text-editor-controlled',
        height: 180,
        valueHtml: v,
        onChangeHtml: (html) => _valor.value = html,
      ),
    ),
    SgButton(
      label: Text(context.tx('Trocar o conteúdo')),
      appearance: SgAppearance.outline,
      onClick: () => _valor.value =
          '<h2>Título</h2><ul><li><p>Item</p></li></ul>',
    ),
  ],
)
''';

  /// Region `sg-text-editor-desabilitado`.
  static const String sgTextEditorDesabilitado = r'''
SgStack(
  gap: 16,
  children: [
    const SgTextEditor(
      id: 'sg-text-editor-disabled',
      height: 120,
      defaultValueHtml: '<p><strong>Conteúdo bloqueado</strong></p>',
      enabled: false,
      showCssEditor: false,
    ),
    SgTextEditor(
      id: 'sg-text-editor-error',
      height: 120,
      error: context.tx('Conteúdo obrigatório'),
    ),
  ],
)
''';

  /// Region `sg-text-editor-formulario`.
  static const String sgTextEditorFormulario = r'''
SgStack(
  gap: 12,
  align: SgStackAlign.start,
  children: [
    SgTextEditor(
      id: 'sg-text-editor-form',
      name: 'descricao',
      control: _form,
      height: 180,
    ),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = '${values['descricao']}',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, v, _) => v.isEmpty
          ? const SizedBox.shrink()
          : Text('${context.tx('Enviado')}: $v'),
    ),
  ],
)
''';

  /// Region `sg-text-editor-placeholder`.
  static const String sgTextEditorPlaceholder = r'''
SgTextEditor(
  id: 'sg-text-editor-placeholder',
  height: 160,
  placeholder: context.tx('Escreva aqui'),
  showCssEditor: false,
)
''';

  /// Region `sg-text-editor-raio`.
  static const String sgTextEditorRaio = r'''
const SgTextEditor(
  id: 'sg-text-editor-radius',
  defaultValueHtml: '<p>Editor com raio de borda personalizado</p>',
  showCssEditor: true,
  borderRadius: 20,
)
''';

  /// Region `sg-text-editor-sem-css`.
  static const String sgTextEditorSemCss = r'''
const SgTextEditor(
  id: 'sg-text-editor-no-css',
  defaultValueHtml: '<p>Editor sem CSS</p>',
  showCssEditor: false,
)
''';
}
