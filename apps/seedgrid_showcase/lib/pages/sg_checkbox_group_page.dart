// Showcase do SgCheckboxGroup. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_checkbox_group_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgCheckboxGroupPage extends StatefulWidget {
  const SgCheckboxGroupPage({super.key});

  @override
  State<SgCheckboxGroupPage> createState() => _SgCheckboxGroupPageState();
}

class _SgCheckboxGroupPageState extends State<SgCheckboxGroupPage> {
  List<Object> _escolhidas = const [];
  final SgCheckboxGroupController _controller = SgCheckboxGroupController();
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
            'Seleção múltipla; opções com checked começam marcadas e onChange entrega a lista.',
        preview:
            // #region sg-checkbox-group-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'frutas',
                  title: context.tx('Frutas'),
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Maçã'),
                      value: 'maca',
                      checked: true,
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Banana'),
                      value: 'banana',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Cereja'),
                      value: 'cereja',
                      disabled: true,
                    ),
                  ],
                  onChange: (v) => setState(() => _escolhidas = v),
                ),
                Text('Escolhidas: ${_escolhidas.join(', ')}'),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupBasico,
      ),
      ShowcaseExample(
        title: 'Horizontal e highlight',
        description:
            'orientation horizontal quebra a linha; selectionStyle highlight troca a caixa por um cartão.',
        preview:
            // #region sg-checkbox-group-estilos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'horizontal',
                  title: context.tx('Horizontal'),
                  orientation: SgCheckboxGroupOrientation.horizontal,
                  source: [
                    SgCheckboxGroupOption(label: context.tx('Um'), value: 1),
                    SgCheckboxGroupOption(
                      label: context.tx('Dois'),
                      value: 2,
                      checked: true,
                    ),
                    SgCheckboxGroupOption(label: context.tx('Três'), value: 3),
                  ],
                ),
                SizedBox(height: 16),
                SgCheckboxGroup(
                  id: 'highlight',
                  title: context.tx('Highlight'),
                  selectionStyle: SgCheckboxGroupSelectionStyle.highlight,
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Lista'),
                      value: 'lista',
                      checked: true,
                      icon: Icon(Icons.list, size: 16),
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Grade'),
                      value: 'grade',
                      icon: Icon(Icons.grid_view, size: 16),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupEstilos,
      ),
      ShowcaseExample(
        title: 'Selecionar todos',
        description:
            'showCheckAll marca só as opções habilitadas e mostra o estado indeterminado.',
        preview:
            // #region sg-checkbox-group-todos
            SgCheckboxGroup(
              id: 'todos',
              title: context.tx('Permissões'),
              showCheckAll: true,
              source: [
                SgCheckboxGroupOption(
                  label: context.tx('Ler'),
                  value: 'r',
                  checked: true,
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Escrever'),
                  value: 'w',
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Apagar'),
                  value: 'd',
                  disabled: true,
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupTodos,
      ),
      ShowcaseExample(
        title: 'Controle por código',
        description:
            'O SgCheckboxGroupController substitui o ref do React (getChecked, setChecked, checkAll, clearAll).',
        preview:
            // #region sg-checkbox-group-controller
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'ctrl',
                  controller: _controller,
                  source: const [
                    SgCheckboxGroupOption(label: 'A', value: 'a'),
                    SgCheckboxGroupOption(label: 'B', value: 'b'),
                    SgCheckboxGroupOption(label: 'C', value: 'c'),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Marcar todos')),
                      size: SgSize.sm,
                      onClick: _controller.checkAll,
                    ),
                    SgButton(
                      label: Text(context.tx('Limpar')),
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      onClick: _controller.clearAll,
                    ),
                    SgButton(
                      label: Text(context.tx('Só B')),
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      onClick: () => _controller.setChecked(['b']),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupController,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control; required usa a mensagem do i18n e revalida a cada mudança depois do envio.',
        preview:
            // #region sg-checkbox-group-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'interesses',
                  name: 'interesses',
                  control: _form,
                  title: context.tx('Interesses'),
                  required: true,
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Esportes'),
                      value: 'esportes',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Música'),
                      value: 'musica',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Leitura'),
                      value: 'leitura',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) =>
                        setState(() => _enviado = '${values['interesses']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgCheckboxGroup',
      description:
          'Grupo de caixas de seleção múltipla com título, orientação, estilo highlight, "selecionar todos" e ligação a formulário.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgCheckboxGroup']!,
        const SgPropSpec(
          name: 'controller',
          reactName: 'ref',
          type: 'SgCheckboxGroupController?',
          tsType: 'Ref<SgCheckboxGroupRef>',
          required: false,
          description:
              'Controle imperativo (getChecked, setChecked, checkAll, clearAll); substitui o ref do React.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgCheckboxGroup']!
            .where(
              (s) => const {
                'orientation',
                'selectionStyle',
                'iconOnly',
                'disabled',
                'readOnly',
                'required',
                'showCheckAll',
                'title',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgCheckboxGroup(
          id: 'pg',
          title: (v['title'] as String?) ?? 'Grupo',
          orientation:
              SgCheckboxGroupOrientation.fromValue(
                v['orientation'] as String?,
              ) ??
              SgCheckboxGroupOrientation.vertical,
          selectionStyle:
              SgCheckboxGroupSelectionStyle.fromValue(
                v['selectionStyle'] as String?,
              ) ??
              SgCheckboxGroupSelectionStyle.checkbox,
          iconOnly: (v['iconOnly'] as bool?) ?? false,
          disabled: (v['disabled'] as bool?) ?? false,
          readOnly: (v['readOnly'] as bool?) ?? false,
          required: (v['required'] as bool?) ?? false,
          showCheckAll: (v['showCheckAll'] as bool?) ?? false,
          source: const [
            SgCheckboxGroupOption(
              label: 'Um',
              value: 1,
              checked: true,
              icon: Icon(Icons.star, size: 16),
            ),
            SgCheckboxGroupOption(
              label: 'Dois',
              value: 2,
              icon: Icon(Icons.favorite, size: 16),
            ),
            SgCheckboxGroupOption(label: 'Três', value: 3),
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
                'orientation: SgCheckboxGroupOrientation.${SgCheckboxGroupOrientation.fromValue(e.value as String)!.name}',
              'selectionStyle' =>
                'selectionStyle: SgCheckboxGroupSelectionStyle.${SgCheckboxGroupSelectionStyle.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgCheckboxGroup(\n  ${args.join(',\n  ')},\n  source: [...],\n)';
        },
      ),
    );
  }
}
