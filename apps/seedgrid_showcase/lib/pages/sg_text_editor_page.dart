// Showcase do SgTextEditor. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// SgTextEditor ainda nao esta no arquivo raiz do pacote: entra pelo barril proprio do grupo.

import '../src/sg_showcase_page.dart';
import 'sg_text_editor_page.snippets.g.dart';

class SgTextEditorPage extends StatefulWidget {
  const SgTextEditorPage({super.key});

  @override
  State<SgTextEditorPage> createState() => _SgTextEditorPageState();
}

class _SgTextEditorPageState extends State<SgTextEditorPage> {
  final SgFormController _form = SgFormController();
  String _html = '<p>Texto <strong>inicial</strong></p>';
  String _valor = '<p>Valor controlado pelo estado da página</p>';
  String _css = 'p { line-height: 1.5; }';
  String _arquivo = '';
  String _enviado = '';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Barra de ferramentas completa; onChangeHtml recebe o HTML do corpo a cada edição.',
        preview:
            // #region sg-text-editor-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgTextEditor(
                  id: 'editor-basico',
                  height: 220,
                  placeholder: 'Escreva aqui',
                  defaultValueHtml: '<p>Texto <strong>inicial</strong></p>',
                  onChangeHtml: (html) => setState(() => _html = html),
                ),
                const SizedBox(height: 8),
                Text('HTML: $_html'),
              ],
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorBasico,
      ),
      ShowcaseExample(
        title: 'Valor controlado',
        description:
            'valueHtml troca o conteúdo; mudar o valor por fora não dispara onChangeHtml.',
        preview:
            // #region sg-text-editor-controlado
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
                  label: const Text('Trocar o conteúdo'),
                  severity: SgSeverity.secondary,
                  onClick: () => setState(
                    () =>
                        _valor = '<h2>Título</h2><ul><li><p>Item</p></li></ul>',
                  ),
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
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorArquivo,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control + rules, como no React. O valor do campo é o HTML do corpo.',
        preview:
            // #region sg-text-editor-formulario
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
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) =>
                        setState(() => _enviado = '${values['descricao']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorFormulario,
      ),
      ShowcaseExample(
        title: 'Desabilitado, erro e cantos',
        preview:
            // #region sg-text-editor-estados
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
            ),
        // #endregion
        code: SgTextEditorPageSnippets.sgTextEditorEstados,
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
                'disabled',
                'showCssEditor',
                'placeholder',
                'cssEditorLabel',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgTextEditor(
          id: 'pg',
          height: 200,
          disabled: v['disabled'] as bool?,
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
