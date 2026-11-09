// Showcase do SgTextEditor. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// SgTextEditor ainda nao esta no arquivo raiz do pacote: entra pelo barril proprio do grupo.

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_text_editor_page.snippets.g.dart';

class SgTextEditorPage extends StatefulWidget {
  const SgTextEditorPage({super.key});

  @override
  State<SgTextEditorPage> createState() => _SgTextEditorPageState();
}

class _SgTextEditorPageState extends State<SgTextEditorPage> {
  final SgFormController _form = SgFormController();
  final ValueNotifier<String> _html = ValueNotifier<String>(
    '<p><strong>SeedGrid</strong> editor</p>',
  );
  final ValueNotifier<String> _css = ValueNotifier<String>(
    'body { font-family: Arial; }',
  );
  final ValueNotifier<String> _baixado = ValueNotifier<String>('');
  final ValueNotifier<String> _valor = ValueNotifier<String>(
    '<p>Valor controlado pelo estado da página</p>',
  );
  final ValueNotifier<String> _cssArquivo = ValueNotifier<String>(
    'p { line-height: 1.5; }',
  );
  final ValueNotifier<String> _arquivo = ValueNotifier<String>('');
  final ValueNotifier<String> _enviado = ValueNotifier<String>('');

  @override
  void dispose() {
    _form.dispose();
    for (final n in [_html, _css, _baixado, _valor, _cssArquivo, _arquivo, _enviado]) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Exemplo com CSS embutido e download do HTML.',
        preview:
            // #region sg-text-editor-basico
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
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorBasico,
      ),
      ShowcaseExample(
        title: 'Modo sem CSS',
        description: 'Exemplo com o editor de CSS oculto.',
        preview:
            // #region sg-text-editor-sem-css
            const SgTextEditor(
              id: 'sg-text-editor-no-css',
              defaultValueHtml: '<p>Editor sem CSS</p>',
              showCssEditor: false,
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorSemCss,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'Renderização somente leitura do conteúdo.',
        preview:
            // #region sg-text-editor-desabilitado
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
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorDesabilitado,
      ),
      ShowcaseExample(
        title: 'Raio da borda',
        description: 'Aplica raio de borda ao editor e à área de CSS.',
        preview:
            // #region sg-text-editor-raio
            const SgTextEditor(
              id: 'sg-text-editor-radius',
              defaultValueHtml: '<p>Editor com raio de borda personalizado</p>',
              showCssEditor: true,
              borderRadius: 20,
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorRaio,
      ),
      ShowcaseExample(
        title: 'Valor controlado',
        description:
            'valueHtml troca o conteúdo; mudar o valor por fora não dispara onChangeHtml.',
        preview:
            // #region sg-text-editor-controlado
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
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorControlado,
      ),
      ShowcaseExample(
        title: 'Salvar, carregar HTML e CSS embutido',
        description:
            'Salvar entrega um arquivo HTML completo (onSave); Carregar HTML lê o <style> do arquivo para o editor de CSS.',
        preview:
            // #region sg-text-editor-arquivo
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
                    cssEditorLabel: context.tx('CSS do documento'),
                    cssText: css,
                    onCssTextChange: (v) => _cssArquivo.value = v,
                    onSave: (file, meta) => _arquivo.value =
                        context.txf(
                          '{nome}: {bytes} bytes, {css} caracteres de CSS',
                          {
                            'nome': file.name,
                            'bytes': file.bytes.length,
                            'css': meta.cssText.length,
                          },
                        ),
                    onLoad: (meta) => _arquivo.value =
                        context.txf('Carregado: {chars} caracteres', {
                          'chars': meta.contentHtml.length,
                        }),
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _arquivo,
                  builder: (context, v, _) =>
                      v.isEmpty ? const SizedBox.shrink() : Text(v),
                ),
              ],
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorArquivo,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'name + control: o valor do campo é o HTML do corpo.',
        preview:
            // #region sg-text-editor-formulario
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
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorFormulario,
      ),
      ShowcaseExample(
        title: 'Placeholder',
        description:
            'placeholder mostra uma dica enquanto o editor está vazio.',
        preview:
            // #region sg-text-editor-placeholder
            SgTextEditor(
              id: 'sg-text-editor-placeholder',
              height: 160,
              placeholder: context.tx('Escreva aqui'),
              showCssEditor: false,
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorPlaceholder,
      ),
    ];

    return SgShowcasePage(
      name: 'SgTextEditor',
      description:
          'Editor de texto rico (negrito, listas, cores, alinhamento, link e imagem) que entrega e recebe HTML.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgTextEditor']!,
        const SgPropSpec(
          name: 'htmlFilePicker',
          reactName: '-',
          type: 'Future<SgTextEditorFile?> Function()?',
          tsType: 'input[type=file]',
          required: false,
          description:
              'Extra do Flutter: seletor do botão "Carregar HTML" (padrão: seletor de arquivos do sistema).',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgTextEditor']!
            .where(
              (s) => const {
                'enabled',
                'showCssEditor',
                'placeholder',
                'cssEditorLabel',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgTextEditor(
          id: 'pg',
          height: 200,
          enabled: v['enabled'] as bool?,
          showCssEditor: v['showCssEditor'] as bool?,
          placeholder: v['placeholder'] as String?,
          cssEditorLabel: v['cssEditorLabel'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", 'height: 200'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgTextEditor(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
