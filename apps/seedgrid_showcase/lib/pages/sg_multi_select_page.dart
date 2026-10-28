// Showcase do SgMultiSelect. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_multi_select_page.snippets.g.dart';

class SgMultiSelectPage extends StatefulWidget {
  const SgMultiSelectPage({super.key});

  @override
  State<SgMultiSelectPage> createState() => _SgMultiSelectPageState();
}

class _SgMultiSelectPageState extends State<SgMultiSelectPage> {
  List<Object> _escolhidas = const ['sp'];
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
            'Toque no campo para abrir a lista e marque quantas opções quiser. '
            'Em tela estreita (menos de 600 px) a lista abre como bottom sheet.',
        preview:
            // #region sg-multi-select-basico
            SgMultiSelect(
              id: 'estados',
              labelText: 'Estados',
              options: [
                SgMultiSelectOption(
                  label: context.tx('São Paulo'),
                  value: 'sp',
                ),
                SgMultiSelectOption(
                  label: context.tx('Rio de Janeiro'),
                  value: 'rj',
                ),
                SgMultiSelectOption(
                  label: context.tx('Minas Gerais'),
                  value: 'mg',
                ),
                SgMultiSelectOption(label: context.tx('Bahia'), value: 'ba'),
              ],
            ),
        // #endregion
        code: SgMultiSelectPageSnippets.sgMultiSelectBasico,
      ),
      ShowcaseExample(
        title: 'Busca, limpar e limite',
        description:
            'searchable abre um campo de busca; clearable mostra o botão de limpar; '
            'maxSelected impede marcar mais itens.',
        preview:
            // #region sg-multi-select-busca
            SgMultiSelect(
              id: 'cores',
              labelText: 'Até 3 cores',
              searchable: true,
              clearable: true,
              maxSelected: 3,
              searchPlaceholder: 'Buscar cor...',
              options: [
                SgMultiSelectOption(label: context.tx('Azul'), value: 'azul'),
                SgMultiSelectOption(label: context.tx('Verde'), value: 'verde'),
                SgMultiSelectOption(
                  label: context.tx('Vermelho'),
                  value: 'vermelho',
                ),
                SgMultiSelectOption(
                  label: context.tx('Amarelo'),
                  value: 'amarelo',
                ),
                SgMultiSelectOption(label: context.tx('Roxo'), value: 'roxo'),
                SgMultiSelectOption(
                  label: context.tx('Cinza (indisponível)'),
                  value: 'cinza',
                  disabled: true,
                ),
              ],
            ),
        // #endregion
        code: SgMultiSelectPageSnippets.sgMultiSelectBusca,
      ),
      ShowcaseExample(
        title: 'Resumo com chipLabel',
        description:
            'chipLabel é o texto curto do item já selecionado. Até summaryThreshold '
            'itens o campo lista os rótulos; acima disso mostra "N selecionadas".',
        preview:
            // #region sg-multi-select-resumo
            SgMultiSelect(
              id: 'filiais',
              labelText: 'Filiais',
              summaryThreshold: 3,
              options: [
                SgMultiSelectOption(
                  label: context.tx('1 - Matriz'),
                  value: 1,
                  chipLabel: '1',
                ),
                SgMultiSelectOption(
                  label: context.tx('2 - Filial Centro'),
                  value: 2,
                  chipLabel: '2',
                ),
                SgMultiSelectOption(
                  label: context.tx('3 - Filial Norte'),
                  value: 3,
                  chipLabel: '3',
                ),
                SgMultiSelectOption(
                  label: context.tx('4 - Filial Sul'),
                  value: 4,
                  chipLabel: '4',
                ),
              ],
            ),
        // #endregion
        code: SgMultiSelectPageSnippets.sgMultiSelectResumo,
      ),
      ShowcaseExample(
        title: 'Valor controlado',
        description:
            'Com value, o pai manda: o campo só muda quando o value muda.',
        preview:
            // #region sg-multi-select-controlado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgMultiSelect(
                  id: 'controlado',
                  labelText: 'Cidades',
                  value: _escolhidas,
                  onChange: (v) => setState(() => _escolhidas = v),
                  options: [
                    SgMultiSelectOption(
                      label: context.tx('São Paulo'),
                      value: 'sp',
                    ),
                    SgMultiSelectOption(
                      label: context.tx('Campinas'),
                      value: 'cps',
                    ),
                    SgMultiSelectOption(
                      label: context.tx('Santos'),
                      value: 'sts',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Selecionadas: ${_escolhidas.join(', ')}'),
              ],
            ),
        // #endregion
        code: SgMultiSelectPageSnippets.sgMultiSelectControlado,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control + rules, como no react-hook-form. O valor do campo '
            'no formulário é a lista de valores marcados.',
        preview:
            // #region sg-multi-select-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgMultiSelect(
                  id: 'tags',
                  name: 'tags',
                  control: _form,
                  labelText: 'Tags',
                  rules: const SgRules(required: 'Escolha ao menos uma tag'),
                  options: [
                    SgMultiSelectOption(
                      label: context.tx('Urgente'),
                      value: 'urgente',
                    ),
                    SgMultiSelectOption(
                      label: context.tx('Financeiro'),
                      value: 'fin',
                    ),
                    SgMultiSelectOption(
                      label: context.tx('Suporte'),
                      value: 'sup',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['tags']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgMultiSelectPageSnippets.sgMultiSelectFormulario,
      ),
    ];

    const playgroundOptions = [
      SgMultiSelectOption(label: 'Alpha', value: 'a'),
      SgMultiSelectOption(label: 'Beta', value: 'b'),
      SgMultiSelectOption(label: 'Gamma', value: 'c'),
    ];

    return SgShowcasePage(
      name: 'SgMultiSelect',
      description:
          'Campo de seleção múltipla: o resumo dos itens marcados aparece no campo e a lista (com busca opcional) abre ancorada ou, em tela estreita, como bottom sheet.',
      examples: examples,
      propSpecs: sgPropSpecs['SgMultiSelect']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgMultiSelect']!
            .where(
              (s) => const {
                'searchable',
                'clearable',
                'disabled',
                'required',
                'filled',
                'placeholder',
                'labelPosition',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgMultiSelect(
          // Remonta ao mudar um controle: required e labelPosition valem desde a montagem.
          key: ValueKey(v.entries.map((e) => '${e.key}=${e.value}').join(',')),
          id: 'pg',
          labelText: 'Rótulo',
          options: playgroundOptions,
          searchable: (v['searchable'] as bool?) ?? false,
          clearable: (v['clearable'] as bool?) ?? false,
          disabled: v['disabled'] as bool?,
          required: v['required'] as bool?,
          filled: v['filled'] as bool?,
          placeholder: v['placeholder'] as String?,
          labelPosition: SgMultiSelectLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "labelText: 'Rótulo'",
            'options: [...]',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgMultiSelectLabelPosition.${SgMultiSelectLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgMultiSelect(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
