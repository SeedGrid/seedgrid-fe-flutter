// Showcase do SgRadioGroup. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_radio_group_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgRadioGroupPage extends StatefulWidget {
  const SgRadioGroupPage({super.key});

  @override
  State<SgRadioGroupPage> createState() => _SgRadioGroupPageState();
}

class _SgRadioGroupPageState extends State<SgRadioGroupPage> {
  Object? _tamanho;
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
        description:
            'Escolha única; as setas do teclado movem a seleção e pulam opções desabilitadas.',
        preview:
            // #region sg-radio-group-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRadioGroup(
                  id: 'tamanho',
                  title: 'Tamanho',
                  source: const [
                    SgRadioGroupOption(label: 'Pequeno', value: 'p'),
                    SgRadioGroupOption(label: 'Médio', value: 'm'),
                    SgRadioGroupOption(
                      label: 'Grande',
                      value: 'g',
                      disabled: true,
                    ),
                  ],
                  onChange: (v) => setState(() => _tamanho = v),
                ),
                Text('Escolhido: ${_tamanho ?? '-'}'),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupBasico,
      ),
      ShowcaseExample(
        title: 'Horizontal e highlight',
        preview:
            // #region sg-radio-group-estilos
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRadioGroup(
                  id: 'horizontal',
                  title: 'Horizontal',
                  orientation: SgRadioGroupOrientation.horizontal,
                  value: 'b',
                  source: [
                    SgRadioGroupOption(label: 'A', value: 'a'),
                    SgRadioGroupOption(label: 'B', value: 'b'),
                    SgRadioGroupOption(label: 'C', value: 'c'),
                  ],
                ),
                SizedBox(height: 16),
                SgRadioGroup(
                  id: 'highlight',
                  title: 'Highlight',
                  selectionStyle: SgRadioGroupSelectionStyle.highlight,
                  value: 'lista',
                  source: [
                    SgRadioGroupOption(
                      label: 'Lista',
                      value: 'lista',
                      icon: Icon(Icons.list, size: 16),
                    ),
                    SgRadioGroupOption(
                      label: 'Grade',
                      value: 'grade',
                      icon: Icon(Icons.grid_view, size: 16),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupEstilos,
      ),
      ShowcaseExample(
        title: 'Só ícones, somente leitura e desabilitado',
        preview:
            // #region sg-radio-group-estados
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRadioGroup(
                  id: 'icones',
                  title: 'iconOnly',
                  iconOnly: true,
                  orientation: SgRadioGroupOrientation.horizontal,
                  selectionStyle: SgRadioGroupSelectionStyle.highlight,
                  value: 'a',
                  source: [
                    SgRadioGroupOption(
                      label: 'Estrela',
                      value: 'a',
                      icon: Icon(Icons.star),
                    ),
                    SgRadioGroupOption(
                      label: 'Coração',
                      value: 'b',
                      icon: Icon(Icons.favorite),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SgRadioGroup(
                  id: 'leitura',
                  title: 'readOnly',
                  readOnly: true,
                  value: 'x',
                  source: [
                    SgRadioGroupOption(label: 'X', value: 'x'),
                    SgRadioGroupOption(label: 'Y', value: 'y'),
                  ],
                ),
                SizedBox(height: 16),
                SgRadioGroup(
                  id: 'off',
                  title: 'disabled',
                  disabled: true,
                  value: 'x',
                  source: [
                    SgRadioGroupOption(label: 'X', value: 'x'),
                    SgRadioGroupOption(label: 'Y', value: 'y'),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupEstados,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'required mostra a mensagem do i18n ao enviar sem escolha.',
        preview:
            // #region sg-radio-group-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRadioGroup(
                  id: 'plano',
                  name: 'plano',
                  control: _form,
                  title: 'Plano',
                  required: true,
                  source: const [
                    SgRadioGroupOption(label: 'Grátis', value: 'free'),
                    SgRadioGroupOption(label: 'Pro', value: 'pro'),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['plano']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgRadioGroup',
      description:
          'Grupo de escolha única com título, orientação, estilo highlight, navegação por setas e ligação a formulário.',
      examples: examples,
      propSpecs: sgPropSpecs['SgRadioGroup']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgRadioGroup']!
            .where(
              (s) => const {
                'orientation',
                'selectionStyle',
                'iconOnly',
                'disabled',
                'readOnly',
                'required',
                'title',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgRadioGroup(
          id: 'pg',
          title: (v['title'] as String?) ?? 'Grupo',
          orientation:
              SgRadioGroupOrientation.fromValue(v['orientation'] as String?) ??
              SgRadioGroupOrientation.vertical,
          selectionStyle:
              SgRadioGroupSelectionStyle.fromValue(
                v['selectionStyle'] as String?,
              ) ??
              SgRadioGroupSelectionStyle.radio,
          iconOnly: (v['iconOnly'] as bool?) ?? false,
          disabled: (v['disabled'] as bool?) ?? false,
          readOnly: (v['readOnly'] as bool?) ?? false,
          required: (v['required'] as bool?) ?? false,
          source: const [
            SgRadioGroupOption(
              label: 'Um',
              value: 1,
              icon: Icon(Icons.star, size: 16),
            ),
            SgRadioGroupOption(
              label: 'Dois',
              value: 2,
              icon: Icon(Icons.favorite, size: 16),
            ),
            SgRadioGroupOption(label: 'Três', value: 3),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "title: '${v['title'] ?? 'Grupo'}'",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false || e.key == 'title') {
              continue;
            }
            args.add(switch (e.key) {
              'orientation' =>
                'orientation: SgRadioGroupOrientation.${SgRadioGroupOrientation.fromValue(e.value as String)!.name}',
              'selectionStyle' =>
                'selectionStyle: SgRadioGroupSelectionStyle.${SgRadioGroupSelectionStyle.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgRadioGroup(\n  ${args.join(',\n  ')},\n  source: [...],\n)';
        },
      ),
    );
  }
}
