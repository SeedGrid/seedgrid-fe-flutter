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
  final ValueNotifier<List<Object>> _vazio = ValueNotifier(const []);
  final ValueNotifier<List<Object>> _preselecionadas = ValueNotifier(const [
    'e1',
    'e2',
    'e4',
  ]);
  final ValueNotifier<List<Object>> _pesquisavel = ValueNotifier(const ['e1']);
  final ValueNotifier<List<Object>> _limitadas = ValueNotifier(const []);
  final ValueNotifier<List<Object>> _filiais = ValueNotifier(const [1, 3]);
  final ValueNotifier<List<Object>> _controlado = ValueNotifier(const ['sp']);
  final ValueNotifier<List<Object>> _resumo = ValueNotifier(const [
    'e1',
    'e2',
    'e4',
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
    _resumo.dispose();
    _form.dispose();
    _enviado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (fechado / aberto, com e sem seleção)',
        description:
            'Clique no campo para abrir. Marque várias opções; a lista continua aberta.',
        preview:
            // #region sg-multi-select-basico
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
                        SgMultiSelect(
                          id: 'ms-empty',
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
                        SgMultiSelect(
                          id: 'ms-preselected',
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
        code: SgMultiSelectPageSnippets.sgMultiSelectBasico,
      ),
      ShowcaseExample(
        title: 'Com busca',
        description:
            'searchable habilita um campo de busca no topo do dropdown.',
        preview:
            // #region sg-multi-select-busca
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _pesquisavel,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelect(
                      id: 'ms-searchable',
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
        code: SgMultiSelectPageSnippets.sgMultiSelectBusca,
      ),
      ShowcaseExample(
        title: 'Limpável e com limite',
        description:
            'clearable adiciona o botão de limpar; maxSelected restringe o número de itens.',
        preview:
            // #region sg-multi-select-limite
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _limitadas,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelect(
                      id: 'ms-capped',
                      labelText: context.tx('Empresas (máx. 2)'),
                      placeholder: context.tx('Selecione até 2 empresas'),
                      clearable: true,
                      maxSelected: 2,
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
        code: SgMultiSelectPageSnippets.sgMultiSelectLimite,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'Com enabled=false o campo não abre nem altera a seleção.',
        preview:
            // #region sg-multi-select-desabilitado
            SgMultiSelect(
              id: 'ms-disabled',
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
        code: SgMultiSelectPageSnippets.sgMultiSelectDesabilitado,
      ),
      ShowcaseExample(
        title: 'Rótulo curto (chipLabel)',
        description:
            'Cada opção pode ter chipLabel: o campo fechado resume a seleção com o texto curto (ex.: "1, 3") e a lista continua com o label completo.',
        preview:
            // #region sg-multi-select-chip-label
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _filiais,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelect(
                      id: 'ms-chip-label',
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
        code: SgMultiSelectPageSnippets.sgMultiSelectChipLabel,
      ),
      ShowcaseExample(
        title: 'Valor controlado',
        description:
            'Com value, o pai manda: o campo só muda quando o value muda.',
        preview:
            // #region sg-multi-select-controlado
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _controlado,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelect(
                      id: 'ms-controlled',
                      labelText: context.tx('Cidades'),
                      options: [
                        SgMultiSelectOption(label: 'São Paulo', value: 'sp'),
                        SgMultiSelectOption(label: 'Campinas', value: 'cps'),
                        SgMultiSelectOption(label: 'Santos', value: 'sts'),
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
                          onClick: () =>
                              _controlado.value = ['sp', 'cps', 'sts'],
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
        code: SgMultiSelectPageSnippets.sgMultiSelectControlado,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control: o valor do campo no formulário é a lista de valores marcados.',
        preview:
            // #region sg-multi-select-formulario
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgMultiSelect(
                    id: 'ms-form',
                    name: 'tags',
                    control: _form,
                    labelText: context.tx('Tags'),
                    options: [
                      SgMultiSelectOption(label: 'Urgente', value: 'urgente'),
                      SgMultiSelectOption(label: 'Financeiro', value: 'fin'),
                      SgMultiSelectOption(label: 'Suporte', value: 'sup'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SgButton(
                    label: Text(context.tx('Enviar')),
                    onClick: () => _form.handleSubmit(
                      (values) => _enviado.value =
                          ((values['tags'] as List?) ?? const []).join(', '),
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
        code: SgMultiSelectPageSnippets.sgMultiSelectFormulario,
      ),
      ShowcaseExample(
        title: 'Limite do resumo (summaryThreshold)',
        description:
            'Por padrão o campo lista até 2 rótulos e depois mostra só a quantidade; summaryThreshold aumenta esse limite.',
        preview:
            // #region sg-multi-select-resumo
            SizedBox(
              width: 384,
              child: ListenableBuilder(
                listenable: _resumo,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgMultiSelect(
                      id: 'ms-summary',
                      labelText: context.tx('Empresas'),
                      placeholder: context.tx('Selecione as empresas'),
                      summaryThreshold: 4,
                      options: [
                        SgMultiSelectOption(label: 'Empresa 1', value: 'e1'),
                        SgMultiSelectOption(label: 'Empresa 2', value: 'e2'),
                        SgMultiSelectOption(label: 'Empresa 3', value: 'e3'),
                        SgMultiSelectOption(label: 'Empresa 4', value: 'e4'),
                        SgMultiSelectOption(label: 'Empresa 5', value: 'e5'),
                        SgMultiSelectOption(label: 'Empresa 6', value: 'e6'),
                      ],
                      value: _resumo.value,
                      onChange: (v) => _resumo.value = v,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.tx('Selecionadas')}: ${_resumo.value.isEmpty ? context.tx('(nenhuma)') : _resumo.value.join(', ')}',
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgMultiSelectPageSnippets.sgMultiSelectResumo,
      ),
      ShowcaseExample(
        title: 'Opção desabilitada e texto da busca',
        description:
            'Uma opção com enabled false aparece desabilitada e não pode ser marcada; searchPlaceholder troca o texto do campo de busca.',
        preview:
            // #region sg-multi-select-opcao-desabilitada
            SizedBox(
              width: 384,
              child: SgMultiSelect(
                id: 'ms-disabled-option',
                labelText: context.tx('Empresas'),
                placeholder: context.tx('Selecione as empresas'),
                searchable: true,
                searchPlaceholder: context.tx('Buscar empresa...'),
                options: [
                  SgMultiSelectOption(label: 'Empresa 1', value: 'e1'),
                  SgMultiSelectOption(label: 'Empresa 2', value: 'e2'),
                  SgMultiSelectOption(label: 'Empresa 3', value: 'e3'),
                  SgMultiSelectOption(label: 'Empresa 4', value: 'e4'),
                  SgMultiSelectOption(label: 'Empresa 5', value: 'e5'),
                  SgMultiSelectOption(
                    label: 'Empresa 6',
                    value: 'e6',
                    enabled: false,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgMultiSelectPageSnippets.sgMultiSelectOpcaoDesabilitada,
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
                'enabled',
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
          enabled: v['enabled'] as bool?,
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
