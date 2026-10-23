// Showcase do SgMultiSelectChips. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_multi_select_chips_page.snippets.g.dart';

class SgMultiSelectChipsPage extends StatefulWidget {
  const SgMultiSelectChipsPage({super.key});

  @override
  State<SgMultiSelectChipsPage> createState() => _SgMultiSelectChipsPageState();
}

class _SgMultiSelectChipsPageState extends State<SgMultiSelectChipsPage> {
  List<Object> _escolhidas = const ['flutter'];
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
            'Os valores marcados viram chips removíveis. Toque no campo para abrir '
            'a lista; em tela estreita (menos de 600 px) ela abre como bottom sheet.',
        preview:
            // #region sg-multi-select-chips-basico
            const SgMultiSelectChips(
              id: 'linguagens',
              labelText: 'Linguagens',
              options: [
                SgMultiSelectOption(label: 'Dart', value: 'dart'),
                SgMultiSelectOption(label: 'Java', value: 'java'),
                SgMultiSelectOption(label: 'Rust', value: 'rust'),
                SgMultiSelectOption(label: 'TypeScript', value: 'ts'),
              ],
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsBasico,
      ),
      ShowcaseExample(
        title: 'Busca, limpar e limite',
        description:
            'searchable, clearable e maxSelected. O X do chip remove só aquele valor.',
        preview:
            // #region sg-multi-select-chips-busca
            const SgMultiSelectChips(
              id: 'paises',
              labelText: 'Até 3 países',
              searchable: true,
              clearable: true,
              maxSelected: 3,
              searchPlaceholder: 'Buscar país...',
              options: [
                SgMultiSelectOption(label: 'Brasil', value: 'br'),
                SgMultiSelectOption(label: 'Portugal', value: 'pt'),
                SgMultiSelectOption(label: 'Argentina', value: 'ar'),
                SgMultiSelectOption(label: 'Uruguai', value: 'uy'),
                SgMultiSelectOption(label: 'Paraguai', value: 'py'),
              ],
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsBusca,
      ),
      ShowcaseExample(
        title: 'chipLabel (texto curto no chip)',
        description:
            'O chip mostra o chipLabel; o nome completo aparece como dica ao '
            'segurar o chip.',
        preview:
            // #region sg-multi-select-chips-chiplabel
            const SgMultiSelectChips(
              id: 'filiais',
              labelText: 'Filiais',
              value: [1, 3],
              options: [
                SgMultiSelectOption(
                  label: '1 - Matriz São Paulo',
                  value: 1,
                  chipLabel: '1',
                ),
                SgMultiSelectOption(
                  label: '2 - Filial Centro',
                  value: 2,
                  chipLabel: '2',
                ),
                SgMultiSelectOption(
                  label: '3 - Filial Norte',
                  value: 3,
                  chipLabel: '3',
                ),
              ],
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsChiplabel,
      ),
      ShowcaseExample(
        title: 'Valor controlado',
        description:
            'Com value, o pai manda; o campo só muda quando o value muda.',
        preview:
            // #region sg-multi-select-chips-controlado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgMultiSelectChips(
                  id: 'controlado',
                  labelText: 'Frameworks',
                  value: _escolhidas,
                  onChange: (v) => setState(() => _escolhidas = v),
                  options: const [
                    SgMultiSelectOption(label: 'Flutter', value: 'flutter'),
                    SgMultiSelectOption(label: 'React', value: 'react'),
                    SgMultiSelectOption(label: 'Quarkus', value: 'quarkus'),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Escolhidos: ${_escolhidas.join(', ')}'),
              ],
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsControlado,
      ),
      ShowcaseExample(
        title: 'Erro e formulário',
        description:
            'required só acrescenta o asterisco ao rótulo; a validação vem de '
            'rules (name + control), e a mensagem aparece abaixo do campo.',
        preview:
            // #region sg-multi-select-chips-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgMultiSelectChips(
                  id: 'areas',
                  name: 'areas',
                  control: _form,
                  labelText: 'Áreas',
                  required: true,
                  rules: const SgRules(required: 'Escolha ao menos uma área'),
                  options: const [
                    SgMultiSelectOption(label: 'Vendas', value: 'vendas'),
                    SgMultiSelectOption(label: 'Compras', value: 'compras'),
                    SgMultiSelectOption(label: 'Estoque', value: 'estoque'),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['areas']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsFormulario,
      ),
    ];

    const playgroundOptions = [
      SgMultiSelectOption(label: 'Alpha', value: 'a'),
      SgMultiSelectOption(label: 'Beta', value: 'b'),
      SgMultiSelectOption(label: 'Gamma', value: 'c'),
    ];

    return SgShowcasePage(
      name: 'SgMultiSelectChips',
      description:
          'Seleção múltipla com os valores marcados como chips removíveis dentro do campo; a lista abre ancorada ou, em tela estreita, como bottom sheet.',
      examples: examples,
      propSpecs: sgPropSpecs['SgMultiSelectChips']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgMultiSelectChips']!
            .where(
              (s) => const {
                'searchable',
                'clearable',
                'disabled',
                'required',
                'placeholder',
                'labelText',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgMultiSelectChips(
          // Remonta ao mudar um controle.
          key: ValueKey(v.entries.map((e) => '${e.key}=${e.value}').join(',')),
          id: 'pg',
          options: playgroundOptions,
          value: const ['a', 'b'],
          searchable: (v['searchable'] as bool?) ?? false,
          clearable: (v['clearable'] as bool?) ?? false,
          disabled: v['disabled'] as bool?,
          required: v['required'] as bool?,
          placeholder: v['placeholder'] as String?,
          labelText: (v['labelText'] as String?) ?? 'Rótulo',
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            'options: [...]',
            "value: ['a', 'b']",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgMultiSelectChips(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
