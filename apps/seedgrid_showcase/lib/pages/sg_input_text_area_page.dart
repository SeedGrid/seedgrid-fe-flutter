// Showcase do SgInputTextArea. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_input_text_area_page.snippets.g.dart';

class SgInputTextAreaPage extends StatefulWidget {
  const SgInputTextAreaPage({super.key});

  @override
  State<SgInputTextAreaPage> createState() => _SgInputTextAreaPageState();
}

class _SgInputTextAreaPageState extends State<SgInputTextAreaPage> {
  final SgFormController _form = SgFormController();
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
        description: 'Rótulo flutuante, 2 linhas por padrão e botão de limpar.',
        preview:
            // #region sg-input-text-area-basico
            const SgInputTextArea(id: 'obs', labelText: 'Observações'),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaBasico,
      ),
      ShowcaseExample(
        title: 'Linhas, altura e posição do rótulo',
        description:
            'maxLines define as linhas visíveis; height fixa a altura e o texto rola dentro.',
        preview:
            // #region sg-input-text-area-linhas
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
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaLinhas,
      ),
      ShowcaseExample(
        title: 'Limites e contador',
        description:
            'maxLength limita a digitação; a validação roda a cada tecla.',
        preview:
            // #region sg-input-text-area-limites
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
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaLimites,
      ),
      ShowcaseExample(
        title: 'Obrigatório e validação própria',
        preview:
            // #region sg-input-text-area-validacao
            SgInputTextArea(
              id: 'justificativa',
              labelText: 'Justificativa',
              required: true,
              requiredMessage: 'Explique o motivo',
              validation: (v) => v.toLowerCase().contains('urgente')
                  ? 'Evite a palavra "urgente"'
                  : null,
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaValidacao,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        preview:
            // #region sg-input-text-area-formulario
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
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputTextArea',
      description:
          'Área de texto com rótulo, limites de caracteres, palavras e linhas, contador e ligação a formulário.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputTextArea']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'textareaProps.defaultValue',
          type: 'String?',
          tsType: 'string',
          required: false,
          description:
              'Valor inicial quando não há control (no React vai em textareaProps).',
        ),
        const SgPropSpec(
          name: 'readOnly',
          reactName: 'textareaProps.readOnly',
          type: 'bool?',
          tsType: 'boolean',
          required: false,
          description: 'Somente leitura (no React vai em textareaProps).',
        ),
        const SgPropSpec(
          name: 'autofocus',
          reactName: 'textareaProps.autoFocus',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'Foca o campo ao montar.',
        ),
        const SgPropSpec(
          name: 'inputFormatters',
          reactName: 'textareaProps',
          type: 'List<TextInputFormatter>?',
          tsType: 'TextareaHTMLAttributes',
          required: false,
          description:
              'Lista fechada que substitui textareaProps (ADR 50): formatadores de entrada.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'focusNode',
          reactName: 'textareaProps.ref',
          type: 'FocusNode?',
          tsType: 'Ref<HTMLTextAreaElement>',
          required: false,
          description: 'Foco externo.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputTextArea']!
            .where(
              (s) => const {
                'labelPosition',
                'filled',
                'disabled',
                'clearButton',
                'showCharCounter',
                'withBorder',
                'elevation',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputTextArea(
          id: 'pg',
          labelText: 'Observações',
          labelPosition: SgInputTextAreaLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          elevation: SgInputTextAreaElevation.fromValue(
            v['elevation'] as String?,
          ),
          filled: v['filled'] as bool?,
          disabled: v['disabled'] as bool?,
          clearButton: v['clearButton'] as bool?,
          showCharCounter: v['showCharCounter'] as bool?,
          withBorder: v['withBorder'] as bool?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Observações'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputTextAreaLabelPosition.${SgInputTextAreaLabelPosition.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgInputTextAreaElevation.${SgInputTextAreaElevation.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputTextArea(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
