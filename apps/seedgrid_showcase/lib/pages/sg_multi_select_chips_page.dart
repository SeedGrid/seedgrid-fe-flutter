// Showcase do SgMultiSelectChips. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_multi_select_chips_page.snippets.g.dart';

class SgMultiSelectChipsPage extends StatefulWidget {
  const SgMultiSelectChipsPage({super.key});

  @override
  State<SgMultiSelectChipsPage> createState() => _SgMultiSelectChipsPageState();
}

class _SgMultiSelectChipsPageState extends State<SgMultiSelectChipsPage> {
  final ValueNotifier<List<Object>> _vazio = ValueNotifier(const []);
  final ValueNotifier<List<Object>> _preselecionadas = ValueNotifier(const [
    'e1',
    'e2',
    'e4',
  ]);
  final ValueNotifier<List<Object>> _pesquisavel = ValueNotifier(const ['e1']);
  final ValueNotifier<List<Object>> _limitadas = ValueNotifier(const []);
  final ValueNotifier<List<Object>> _filiais = ValueNotifier(const [1, 3]);
  final ValueNotifier<List<Object>> _controlado = ValueNotifier(const [
    'flutter',
  ]);
  final SgFormController _form = SgFormController();
  final ValueNotifier<String> _enviado = ValueNotifier('');

  @override
  void dispose() {
    _vazio.dispose();
    _preselecionadas.dispose();
    _pesquisavel.dispose();
    _limitadas.dispose();
    _filiais.dispose();
    _controlado.dispose();
    _form.dispose();
    _enviado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (vazio / com chips)',
        description:
            'Clique no campo para abrir. Cada item selecionado vira um chip com botão de remover.',
        preview:
            // #region sg-multi-select-chips-basico
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 384,
                  child: ListenableBuilder(
                    listenable: _vazio,
                    builder: (context, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SgMultiSelectChips(
                          id: 'msc-empty',
                          labelText: context.tx('Empresas'),
                          placeholder: context.tx('Selecione as empresas'),
                          options: [
                            SgMultiSelectOption(
                              label: 'Empresa 1',
                              value: 'e1',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 2',
                              value: 'e2',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 3',
                              value: 'e3',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 4',
                              value: 'e4',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 5',
                              value: 'e5',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 6',
                              value: 'e6',
                            ),
                          ],
                          value: _vazio.value,
                          onChange: (v) => _vazio.value = v,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${context.tx('Selecionadas')}: ${_vazio.value.isEmpty ? context.tx('(nenhuma)') : _vazio.value.join(', ')}',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 384,
                  child: ListenableBuilder(
                    listenable: _preselecionadas,
                    builder: (context, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SgMultiSelectChips(
                          id: 'msc-preselected',
                          labelText: context.tx('Empresas (com seleção)'),
                          placeholder: context.tx('Selecione as empresas'),
                          options: [
                            SgMultiSelectOption(
                              label: 'Empresa 1',
                              value: 'e1',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 2',
                              value: 'e2',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 3',
                              value: 'e3',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 4',
                              value: 'e4',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 5',
                              value: 'e5',
                            ),
                            SgMultiSelectOption(
                              label: 'Empresa 6',
                              value: 'e6',
                            ),
                          ],
                          value: _preselecionadas.value,
                          onChange: (v) => _preselecionadas.value = v,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${context.tx('Selecionadas')}: ${_preselecionadas.value.isEmpty ? context.tx('(nenhuma)') : _preselecionadas.value.join(', ')}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsBasico,
      ),
      ShowcaseExample(
        title: 'Com busca',
        description:
            'searchable habilita um campo de busca no topo do dropdown.',
        preview:
            // #region sg-multi-select-chips-busca
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _pesquisavel,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelectChips(
                      id: 'msc-searchable',
                      labelText: context.tx('Empresas'),
                      placeholder: context.tx('Selecione as empresas'),
                      searchable: true,
                      options: [
                        SgMultiSelectOption(label: 'Empresa 1', value: 'e1'),
                        SgMultiSelectOption(label: 'Empresa 2', value: 'e2'),
                        SgMultiSelectOption(label: 'Empresa 3', value: 'e3'),
                        SgMultiSelectOption(label: 'Empresa 4', value: 'e4'),
                        SgMultiSelectOption(label: 'Empresa 5', value: 'e5'),
                        SgMultiSelectOption(label: 'Empresa 6', value: 'e6'),
                      ],
                      value: _pesquisavel.value,
                      onChange: (v) => _pesquisavel.value = v,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.tx('Selecionadas')}: ${_pesquisavel.value.isEmpty ? context.tx('(nenhuma)') : _pesquisavel.value.join(', ')}',
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsBusca,
      ),
      ShowcaseExample(
        title: 'Limpável e com limite',
        description:
            'clearable adiciona o botão de limpar; maxSelected restringe o número de itens.',
        preview:
            // #region sg-multi-select-chips-limite
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _limitadas,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelectChips(
                      id: 'msc-capped',
                      labelText: context.tx('Empresas (máx. 3)'),
                      placeholder: context.tx('Selecione até 3 empresas'),
                      clearable: true,
                      maxSelected: 3,
                      options: [
                        SgMultiSelectOption(label: 'Empresa 1', value: 'e1'),
                        SgMultiSelectOption(label: 'Empresa 2', value: 'e2'),
                        SgMultiSelectOption(label: 'Empresa 3', value: 'e3'),
                        SgMultiSelectOption(label: 'Empresa 4', value: 'e4'),
                        SgMultiSelectOption(label: 'Empresa 5', value: 'e5'),
                        SgMultiSelectOption(label: 'Empresa 6', value: 'e6'),
                      ],
                      value: _limitadas.value,
                      onChange: (v) => _limitadas.value = v,
                    ),
                    const SizedBox(height: 8),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Limpar')),
                      onClick: () => _limitadas.value = const [],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.tx('Selecionadas')}: ${_limitadas.value.isEmpty ? context.tx('(nenhuma)') : _limitadas.value.join(', ')}',
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsLimite,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'Com enabled=false o campo não abre, nem remove chips.',
        preview:
            // #region sg-multi-select-chips-desabilitado
            SgMultiSelectChips(
              id: 'msc-disabled',
              labelText: context.tx('Empresas'),
              placeholder: context.tx('Selecione as empresas'),
              options: [
                SgMultiSelectOption(label: 'Empresa 1', value: 'e1'),
                SgMultiSelectOption(label: 'Empresa 2', value: 'e2'),
                SgMultiSelectOption(label: 'Empresa 3', value: 'e3'),
                SgMultiSelectOption(label: 'Empresa 4', value: 'e4'),
                SgMultiSelectOption(label: 'Empresa 5', value: 'e5'),
                SgMultiSelectOption(label: 'Empresa 6', value: 'e6'),
              ],
              value: const ['e1', 'e3'],
              enabled: false,
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsDesabilitado,
      ),
      ShowcaseExample(
        title: 'Rótulo curto (chipLabel)',
        description:
            'Cada opção pode ter chipLabel: o chip mostra o texto curto (ex.: só o código) e a lista continua com o label completo. Passe o mouse no chip para ver o nome.',
        preview:
            // #region sg-multi-select-chips-chip-label
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _filiais,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelectChips(
                      id: 'msc-chip-label',
                      labelText: context.tx('Filiais'),
                      placeholder: context.tx('Selecione as empresas'),
                      searchable: true,
                      options: [
                        SgMultiSelectOption(
                          label: '1 - Matriz São Paulo',
                          value: 1,
                          chipLabel: '1',
                        ),
                        SgMultiSelectOption(
                          label: '2 - Filial Campinas',
                          value: 2,
                          chipLabel: '2',
                        ),
                        SgMultiSelectOption(
                          label: '3 - Filial Centro',
                          value: 3,
                          chipLabel: '3',
                        ),
                        SgMultiSelectOption(
                          label: '4 - Filial Ribeirão Preto',
                          value: 4,
                          chipLabel: '4',
                        ),
                        SgMultiSelectOption(
                          label: '5 - Depósito Jundiaí',
                          value: 5,
                          chipLabel: '5',
                        ),
                      ],
                      value: _filiais.value,
                      onChange: (v) => _filiais.value = v,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.tx('Selecionadas')}: ${_filiais.value.isEmpty ? context.tx('(nenhuma)') : _filiais.value.join(', ')}',
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsChipLabel,
      ),
      ShowcaseExample(
        title: 'Valor controlado',
        description:
            'Com value, o pai manda: o campo só muda quando o value muda.',
        preview:
            // #region sg-multi-select-chips-controlado
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _controlado,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelectChips(
                      id: 'msc-controlled',
                      labelText: context.tx('Frameworks'),
                      options: [
                        SgMultiSelectOption(label: 'Flutter', value: 'flutter'),
                        SgMultiSelectOption(label: 'React', value: 'react'),
                        SgMultiSelectOption(label: 'Quarkus', value: 'quarkus'),
                      ],
                      value: _controlado.value,
                      onChange: (v) => _controlado.value = v,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SgButton(
                          size: SgSize.sm,
                          appearance: SgAppearance.outline,
                          label: Text(context.tx('Selecionar todas')),
                          onClick: () => _controlado.value = [
                            'flutter',
                            'react',
                            'quarkus',
                          ],
                        ),
                        SgButton(
                          size: SgSize.sm,
                          appearance: SgAppearance.outline,
                          label: Text(context.tx('Limpar')),
                          onClick: () => _controlado.value = const [],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.tx('Selecionadas')}: ${_controlado.value.isEmpty ? context.tx('(nenhuma)') : _controlado.value.join(', ')}',
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgMultiSelectChipsPageSnippets.sgMultiSelectChipsControlado,
      ),
      ShowcaseExample(
        title: 'Erro e formulário',
        description:
            'required só acrescenta o asterisco ao rótulo; com name + control o campo guarda a lista de valores marcados.',
        preview:
            // #region sg-multi-select-chips-formulario
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgMultiSelectChips(
                    id: 'msc-form',
                    name: 'areas',
                    control: _form,
                    labelText: context.tx('Áreas'),
                    required: true,
                    options: [
                      SgMultiSelectOption(label: 'Vendas', value: 'vendas'),
                      SgMultiSelectOption(label: 'Compras', value: 'compras'),
                      SgMultiSelectOption(label: 'Estoque', value: 'estoque'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SgButton(
                    label: Text(context.tx('Enviar')),
                    onClick: () => _form.handleSubmit(
                      (values) => _enviado.value =
                          ((values['areas'] as List?) ?? const []).join(', '),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: _enviado,
                    builder: (context, enviado, _) => enviado.isEmpty
                        ? const SizedBox.shrink()
                        : Text('${context.tx('Enviado')}: $enviado'),
                  ),
                ],
              ),
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
                'enabled',
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
          enabled: v['enabled'] as bool?,
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
