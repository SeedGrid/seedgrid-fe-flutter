// Showcase do SgDatatable. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// Enquanto o barril `datatable_inputs.dart` nao estiver ligado no arquivo raiz do pacote.

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_datatable_page.snippets.g.dart';

const List<String> _nomes = [
  'Ana',
  'Bruno',
  'Carla',
  'Daniel',
  'Elisa',
  'Fábio',
  'Gabriela',
  'Hugo',
  'Íris',
  'João',
  'Karina',
  'Leandro',
  'Marina',
  'Nuno',
  'Olívia',
  'Paulo',
  'Quitéria',
  'Rafael',
  'Sofia',
  'Tiago',
  'Úrsula',
  'Vítor',
  'Wanda',
  'Xavier',
  'Yara',
  'Zeca',
];
const List<String> _cidades = [
  'São Paulo',
  'Recife',
  'Curitiba',
  'Salvador',
  'Porto Alegre',
];

final List<SgDatatableRow> _pessoas = [
  for (var i = 0; i < _nomes.length; i++)
    {
      'id': i + 1,
      'nome': _nomes[i],
      'cidade': _cidades[i % _cidades.length],
      'idade': 18 + (i * 7) % 40,
      'salario': 2500.0 + (i * 913) % 7000,
    },
];

const List<SgDatatableColumn> _colunas = [
  SgDatatableColumn(
    field: 'id',
    header: 'Id',
    sortable: true,
    align: SgDatatableColumnAlign.right,
    width: 80,
  ),
  SgDatatableColumn(
    field: 'nome',
    header: 'Nome',
    sortable: true,
    filter: true,
  ),
  SgDatatableColumn(
    field: 'cidade',
    header: 'Cidade',
    sortable: true,
    filter: true,
  ),
  SgDatatableColumn(
    field: 'idade',
    header: 'Idade',
    sortable: true,
    align: SgDatatableColumnAlign.right,
  ),
];

class SgDatatablePage extends StatefulWidget {
  const SgDatatablePage({super.key});

  @override
  State<SgDatatablePage> createState() => _SgDatatablePageState();
}

class _SgDatatablePageState extends State<SgDatatablePage> {
  final ValueNotifier<String> _evento = ValueNotifier('nenhum evento ainda');
  final ValueNotifier<String> _pagina = ValueNotifier('nenhum evento ainda');
  final ValueNotifier<Object?> _selecionadas = ValueNotifier(null);
  final ValueNotifier<SgDatatableMobileMode> _modoCartoes = ValueNotifier(
    SgDatatableMobileMode.cards,
  );
  final ValueNotifier<bool> _rolagemInfinita = ValueNotifier(true);
  final SgDatatableController _controller = SgDatatableController();
  final ValueNotifier<int> _first = ValueNotifier(0);

  @override
  void dispose() {
    _evento.dispose();
    _pagina.dispose();
    _selecionadas.dispose();
    _modoCartoes.dispose();
    _rolagemInfinita.dispose();
    _first.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico com paginação e sort',
        description:
            'infiniteScroll={false} mantém o paginador também em tela estreita: abaixo de 600 px o padrão viraria cartões com rolagem infinita.',
        preview:
            // #region sg-datatable-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgDatatable(
                  id: 'datatable-basic',
                  title: context.tx('Pessoas'),
                  value: _pessoas,
                  columns: _colunas,
                  dataKey: 'id',
                  paginator: true,
                  infiniteScroll: false,
                  rows: 5,
                  rowsPerPageOptions: const [5, 10],
                  stripedRows: true,
                  showGridlines: true,
                  onPage: (e) => _pagina.value =
                      'página ${e.page} de ${e.pageCount} (first ${e.first})',
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _pagina,
                  builder: (context, evento, _) =>
                      Text('${context.tx('Último onPage')}: $evento'),
                ),
              ],
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableBasico,
      ),
      ShowcaseExample(
        title: 'Filtro global + filtros por coluna',
        description:
            'showGlobalFilter, showColumnFilters, filterMatchMode por coluna e showClearFiltersButton.',
        preview:
            // #region sg-datatable-filtros
            SgDatatable(
              value: _pessoas,
              columns: [
                SgDatatableColumn(
                  field: 'nome',
                  header: context.tx('Nome'),
                  filter: true,
                ),
                SgDatatableColumn(
                  field: 'cidade',
                  header: context.tx('Cidade'),
                  filter: true,
                  filterMatchMode: SgDatatableFilterMatchMode.startsWith,
                ),
                SgDatatableColumn(
                  field: 'salario',
                  header: context.tx('Salário'),
                  excludeGlobalFilter: true,
                ),
              ],
              paginator: true,
              infiniteScroll: false,
              rows: 5,
              showGlobalFilter: true,
              showColumnFilters: true,
              showClearFiltersButton: true,
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableFiltros,
      ),
      ShowcaseExample(
        title: 'Seleção de linhas (single e multiple)',
        description:
            'selectionMode single ou multiple, com dataKey e onSelectionChange; a seleção é entregue ao pai.',
        preview:
            // #region sg-datatable-selecao
            ValueListenableBuilder<Object?>(
              valueListenable: _selecionadas,
              builder: (context, selecionadas, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgDatatable(
                    value: _pessoas.take(8).toList(),
                    columns: _colunas,
                    dataKey: 'id',
                    selectionMode: SgDatatableSelectionMode.multiple,
                    selection: selecionadas,
                    onSelectionChange: (s) => _selecionadas.value = s,
                  ),
                  Text(
                    'Selecionadas: ${((selecionadas as List?) ?? const []).length}',
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableSelecao,
      ),
      ShowcaseExample(
        title: 'Template customizado e footer',
        description:
            'body desenha a célula e footer recebe as linhas processadas.',
        preview:
            // #region sg-datatable-colunas
            SgDatatable(
              id: 'pessoas-colunas',
              value: _pessoas.take(8).toList(),
              columns: [
                SgDatatableColumn(
                  field: 'nome',
                  header: context.tx('Nome'),
                  footer: 'Total',
                ),
                SgDatatableColumn(
                  field: 'salario',
                  header: context.tx('Salário'),
                  sortable: true,
                  align: SgDatatableColumnAlign.right,
                  body: (row, meta) =>
                      Text('R\$ ${(row['salario'] as num).toStringAsFixed(2)}'),
                  footer: (List<SgDatatableRow> rows) =>
                      'R\$ ${rows.fold<num>(0, (a, r) => a + (r['salario'] as num)).toStringAsFixed(2)}',
                ),
                SgDatatableColumn(
                  field: 'cidade',
                  header: context.tx('Cidade'),
                ),
              ],
              showColumnManager: false,
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableColunas,
      ),
      ShowcaseExample(
        title: 'Gerenciador de colunas, visibilidade e estilos',
        description:
            'Mostra o gerenciador de colunas embutido e as props de visibilidade, ordem e estilo por coluna.',
        preview:
            // #region sg-datatable-gerenciador
            SgDatatable(
              id: 'datatable-column-manager',
              title: context.tx('Gerenciador de colunas e linhas estilizadas'),
              value: _pessoas,
              columns: [
                SgDatatableColumn(
                  field: 'nome',
                  header: context.tx('Nome'),
                  sortable: true,
                  filter: true,
                  hideable: false,
                ),
                SgDatatableColumn(
                  field: 'cidade',
                  header: context.tx('Cidade'),
                  sortable: true,
                  filter: true,
                ),
                SgDatatableColumn(
                  field: 'idade',
                  header: context.tx('Idade'),
                  sortable: true,
                  align: SgDatatableColumnAlign.right,
                ),
                SgDatatableColumn(
                  field: 'salario',
                  header: context.tx('Salário'),
                  align: SgDatatableColumnAlign.right,
                  hidden: true,
                ),
              ],
              dataKey: 'id',
              paginator: true,
              infiniteScroll: false,
              rows: 5,
              rowsPerPageOptions: const [5, 10],
              showGlobalFilter: true,
              showColumnFilters: true,
              showClearFiltersButton: true,
              showColumnManager: true,
              columnManagerLabel: context.tx('Gerenciar colunas'),
              stripedRows: true,
              removableSort: false,
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableGerenciador,
      ),
      ShowcaseExample(
        title: 'Coluna de ações com ícones',
        description:
            'body desenha qualquer widget na célula; aqui, botões de ícone que usam a linha da própria célula.',
        preview:
            // #region sg-datatable-acoes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgDatatable(
                  id: 'pessoas-acoes',
                  value: _pessoas.take(5).toList(),
                  columns: [
                    SgDatatableColumn(
                      field: 'nome',
                      header: context.tx('Nome'),
                    ),
                    SgDatatableColumn(
                      field: 'acoes',
                      header: context.tx('Ações'),
                      width: 120,
                      body: (row, meta) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SgButton(
                            iconOnly: true,
                            size: SgSize.sm,
                            appearance: SgAppearance.outline,
                            leftIcon: const Icon(Icons.edit_outlined),
                            onClick: () =>
                                _evento.value = 'editar ${row['nome']}',
                          ),
                          const SizedBox(width: 4),
                          SgButton(
                            iconOnly: true,
                            size: SgSize.sm,
                            severity: SgSeverity.danger,
                            appearance: SgAppearance.outline,
                            leftIcon: const Icon(Icons.delete_outline),
                            onClick: () =>
                                _evento.value = 'excluir ${row['nome']}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: _evento,
                  builder: (context, evento, _) => Text('Última ação: $evento'),
                ),
              ],
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableAcoes,
      ),
      ShowcaseExample(
        title: 'Controle externo de página e ordenação',
        description:
            'A página e a ordenação são controladas por fora do componente, sem depender só da interação do usuário.',
        preview:
            // #region sg-datatable-controller
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 420,
                  child: SingleChildScrollView(
                    child: SgDatatable(
                      value: _pessoas,
                      columns: _colunas,
                      paginator: true,
                      rows: 5,
                      showGlobalFilter: true,
                      controller: _controller,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Ir para a página 3')),
                      onClick: () => _controller.goToPage(3),
                    ),
                    SgButton(
                      label: Text(context.tx('Limpar filtros')),
                      onClick: () => _controller.clearFilters(),
                    ),
                    SgButton(
                      label: Text(context.tx('Remover ordem')),
                      onClick: () => _controller.resetSort(),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableController,
      ),
      ShowcaseExample(
        title: 'Server-side paginator (lazy)',
        description:
            'lazy não filtra nem ordena: você entrega só a página atual em value e o total em totalRecords; onPage pede a próxima.',
        preview:
            // #region sg-datatable-lazy
            ValueListenableBuilder<int>(
              valueListenable: _first,
              builder: (context, first, _) => SgDatatable(
                value: _pessoas.skip(first).take(5).toList(),
                columns: _colunas,
                lazy: true,
                paginator: true,
                rows: 5,
                first: first,
                totalRecords: _pessoas.length,
                onPage: (e) => _first.value = e.first,
              ),
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableLazy,
      ),
      ShowcaseExample(
        title: 'Loading e estado vazio',
        description:
            'loading mostra a mensagem de carga; sem linhas, emptyMessage (ou o texto padrão do idioma).',
        preview:
            // #region sg-datatable-estados
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgDatatable(
                  title: context.tx('Carregando'),
                  value: const [],
                  columns: _colunas,
                  loading: true,
                  showColumnManager: false,
                ),
                const SizedBox(height: 16),
                SgDatatable(
                  title: context.tx('Vazio'),
                  value: const [],
                  columns: _colunas,
                  emptyMessage: 'Nenhuma pessoa cadastrada.',
                  showColumnManager: false,
                ),
              ],
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableEstados,
      ),
      ShowcaseExample(
        title: 'Modo cartões no celular (mobileMode)',
        description:
            'Por padrão (mobileMode omitido) a tabela vira cartões "coluna: valor" quando o container tem menos de 600 px; mobileMode: cards força os cartões e scroll força a tabela, em qualquer largura. cardTitle usa a coluna como título do cartão e cardHidden a deixa de fora. Ordenação vira um seletor, os filtros vão para um painel aberto por botão; seleção, ações, rodapé e paginação continuam.',
        preview:
            // #region sg-datatable-cartoes
            ValueListenableBuilder<SgDatatableMobileMode>(
              valueListenable: _modoCartoes,
              builder: (context, modoCartoes, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgRadioGroup(
                    id: 'modo-cartoes',
                    title: 'mobileMode',
                    orientation: SgRadioGroupOrientation.horizontal,
                    source: const [
                      SgRadioGroupOption(label: 'cards', value: 'cards'),
                      SgRadioGroupOption(label: 'scroll', value: 'scroll'),
                    ],
                    value: modoCartoes.name,
                    onChange: (v) => _modoCartoes.value = v == 'scroll'
                        ? SgDatatableMobileMode.scroll
                        : SgDatatableMobileMode.cards,
                  ),
                  SizedBox(
                    width: 420,
                    height: 360,
                    child: SingleChildScrollView(
                      child: SgDatatable(
                        title: context.tx('Pessoas (cartões)'),
                        value: _pessoas,
                        columns: const [
                          SgDatatableColumn(
                            field: 'id',
                            header: 'Id',
                            cardHidden: true,
                          ),
                          SgDatatableColumn(
                            field: 'nome',
                            header: 'Nome',
                            sortable: true,
                            filter: true,
                            cardTitle: true,
                          ),
                          SgDatatableColumn(
                            field: 'cidade',
                            header: 'Cidade',
                            sortable: true,
                            filter: true,
                          ),
                          SgDatatableColumn(
                            field: 'idade',
                            header: 'Idade',
                            sortable: true,
                          ),
                        ],
                        dataKey: 'id',
                        mobileMode: modoCartoes,
                        selectionMode: SgDatatableSelectionMode.single,
                        showColumnFilters: true,
                        paginator: true,
                        rows: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableCartoes,
      ),
      ShowcaseExample(
        title: 'Rolagem infinita (infiniteScroll)',
        description:
            'Sem paginador: ao rolar até perto do fim (toque, roda do mouse ou barra de rolagem) a tabela avança a página (rows) e acrescenta os próximos registros, com indicador de carregando e de fim da lista. Padrão ligado nos cartões e desligado na tabela; exige paginator. Com lazy, quem usa acrescenta a próxima página em value (first/rows/page em onPage/onLoadMore).',
        preview:
            // #region sg-datatable-rolagem-infinita
            ValueListenableBuilder<bool>(
              valueListenable: _rolagemInfinita,
              builder: (context, rolagemInfinita, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgRadioGroup(
                    id: 'rolagem-infinita',
                    title: 'infiniteScroll',
                    orientation: SgRadioGroupOrientation.horizontal,
                    source: const [
                      SgRadioGroupOption(label: 'true', value: 'true'),
                      SgRadioGroupOption(label: 'false', value: 'false'),
                    ],
                    value: rolagemInfinita.toString(),
                    onChange: (v) => _rolagemInfinita.value = v != 'false',
                  ),
                  SizedBox(
                    width: 420,
                    height: 360,
                    child: SingleChildScrollView(
                      child: SgDatatable(
                        title: context.tx('Pessoas (rolagem infinita)'),
                        value: _pessoas,
                        columns: const [
                          SgDatatableColumn(
                            field: 'id',
                            header: 'Id',
                            cardHidden: true,
                          ),
                          SgDatatableColumn(
                            field: 'nome',
                            header: 'Nome',
                            cardTitle: true,
                          ),
                          SgDatatableColumn(field: 'cidade', header: 'Cidade'),
                          SgDatatableColumn(field: 'idade', header: 'Idade'),
                        ],
                        dataKey: 'id',
                        mobileMode: SgDatatableMobileMode.cards,
                        infiniteScroll: rolagemInfinita,
                        paginator: true,
                        rows: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableRolagemInfinita,
      ),
      ShowcaseExample(
        title: 'Idioma e textos (i18n)',
        description:
            'Os textos internos vêm do dicionário components.datatable.*. Envolva o componente em SgComponentsI18nProvider (ou chame setComponentsI18n) para trocar o idioma e use messages para substituir uma chave. As props de texto (emptyMessage, columnManagerLabel, globalFilterPlaceholder e column.filterPlaceholder) vencem o dicionário; sem elas, vale components.datatable.*.',
        preview:
            // #region sg-datatable-idioma
            const SgComponentsI18nProvider(
              locale: 'fr',
              messages: {
                'components.datatable.empty':
                    'Texto do dicionário (não aparece)',
              },
              child: SgDatatable(
                id: 'datatable-idioma',
                title: 'Produtos',
                value: [],
                columns: [
                  SgDatatableColumn(
                    field: 'code',
                    header: 'Código',
                    filter: true,
                    filterPlaceholder: 'Digite o código',
                  ),
                  SgDatatableColumn(
                    field: 'name',
                    header: 'Nome',
                    filter: true,
                  ),
                ],
                dataKey: 'code',
                showGlobalFilter: true,
                showColumnFilters: true,
                globalFilterPlaceholder: 'Buscar produtos',
                emptyMessage: 'Nenhum produto cadastrado.',
              ),
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableIdioma,
      ),
      ShowcaseExample(
        title: 'Desabilitado (enabled)',
        description:
            'Com enabled: false ordenação, seleção de linhas, filtros e gerenciador de colunas ficam bloqueados; paginação e rolagem continuam funcionando.',
        preview:
            // #region sg-datatable-enabled
            SgDatatable(
              id: 'datatable-enabled',
              title: context.tx('Pessoas'),
              value: [
                {'id': 1, 'name': 'Ana'},
                {'id': 2, 'name': 'Bruno'},
                {'id': 3, 'name': 'Carla'},
              ],
              columns: const [
                SgDatatableColumn(field: 'id', header: 'ID', sortable: true),
                SgDatatableColumn(
                  field: 'name',
                  header: 'Nome',
                  sortable: true,
                  filter: true,
                ),
              ],
              dataKey: 'id',
              selectionMode: SgDatatableSelectionMode.single,
              showGlobalFilter: true,
              showColumnFilters: true,
              enabled: false,
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableEnabled,
      ),
    ];

    return SgShowcasePage(
      name: 'SgDatatable',
      description:
          'Tabela de dados com colunas configuráveis, paginação, ordenação, filtros, seleção, carga sob demanda, layout de colunas persistente e modo cartões para celular (mobileMode).',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgDatatable']!,
        const SgPropSpec(
          name: 'controller',
          reactName: 'ref',
          type: 'SgDatatableController?',
          tsType: 'Ref<SgDatatableRef>',
          required: false,
          description:
              'Controle imperativo (getProcessedRows, getPagedRows, clearFilters, clearSelection, resetSort, resetPage, goToPage); substitui o ref do React.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgDatatable']!
            .where(
              (s) => const {
                'selectionMode',
                'paginator',
                'loading',
                'showGlobalFilter',
                'showColumnFilters',
                'showClearFiltersButton',
                'stripedRows',
                'showGridlines',
                'hoverableRows',
                'removableSort',
                'showColumnManager',
                'title',
                'emptyMessage',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgDatatable(
          title: v['title'] as String?,
          emptyMessage: v['emptyMessage'] as String?,
          value: _pessoas,
          columns: _colunas,
          dataKey: 'id',
          rows: 5,
          selectionMode: SgDatatableSelectionMode.fromValue(
            v['selectionMode'] as String?,
          ),
          paginator: (v['paginator'] as bool?) ?? false,
          loading: (v['loading'] as bool?) ?? false,
          showGlobalFilter: (v['showGlobalFilter'] as bool?) ?? false,
          showColumnFilters: (v['showColumnFilters'] as bool?) ?? false,
          showClearFiltersButton:
              (v['showClearFiltersButton'] as bool?) ?? false,
          stripedRows: (v['stripedRows'] as bool?) ?? false,
          showGridlines: (v['showGridlines'] as bool?) ?? false,
          hoverableRows: !((v['hoverableRows'] as bool?) == false),
          removableSort: !((v['removableSort'] as bool?) == false),
          showColumnManager: !((v['showColumnManager'] as bool?) == false),
        ),
        codeBuilder: (v) {
          final args = <String>[
            'value: pessoas',
            'columns: colunas',
            'rows: 5',
          ];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'selectionMode' =>
                'selectionMode: SgDatatableSelectionMode.${SgDatatableSelectionMode.fromValue(e.value as String)!.name}',
              'title' || 'emptyMessage' => "${e.key}: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgDatatable(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
