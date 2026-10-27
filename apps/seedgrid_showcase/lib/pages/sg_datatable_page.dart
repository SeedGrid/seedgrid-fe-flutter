// Showcase do SgDatatable. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// Enquanto o barril `datatable_inputs.dart` nao estiver ligado no arquivo raiz do pacote.

import '../src/sg_showcase_page.dart';
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
  String _evento = 'nenhum evento ainda';
  Object? _selecionadas;
  final SgDatatableController _controller = SgDatatableController();
  int _first = 0;
  List<SgDatatableRow> _paginaLazy = _pessoas.take(5).toList();

  void _carregar(SgDatatablePageEvent e) {
    setState(() {
      _first = e.first;
      _paginaLazy = _pessoas.skip(e.first).take(e.rows).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'value (as linhas) e columns (field, header, align, width). Sem paginator, todas as linhas aparecem.',
        preview:
            // #region sg-datatable-basico
            SgDatatable(
              title: 'Pessoas',
              value: _pessoas.take(6).toList(),
              columns: _colunas,
              stripedRows: true,
              showGridlines: true,
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableBasico,
      ),
      ShowcaseExample(
        title: 'Paginação',
        description:
            'paginator, rows, rowsPerPageOptions e onPage (first, rows, page, pageCount, totalRecords).',
        preview:
            // #region sg-datatable-paginacao
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgDatatable(
                  value: _pessoas,
                  columns: _colunas,
                  paginator: true,
                  rows: 5,
                  rowsPerPageOptions: const [5, 10, 25],
                  onPage: (e) => setState(
                    () => _evento =
                        'página ${e.page} de ${e.pageCount} (first ${e.first})',
                  ),
                ),
                Text('Último onPage: $_evento'),
              ],
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatablePaginacao,
      ),
      ShowcaseExample(
        title: 'Ordenação e seleção',
        description:
            'sortable nas colunas (crescente, decrescente, sem ordem); selectionMode multiple com dataKey e onSelectionChange.',
        preview:
            // #region sg-datatable-selecao
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgDatatable(
                  value: _pessoas.take(8).toList(),
                  columns: _colunas,
                  dataKey: 'id',
                  selectionMode: SgDatatableSelectionMode.multiple,
                  selection: _selecionadas,
                  onSelectionChange: (s) => setState(() => _selecionadas = s),
                ),
                Text(
                  'Selecionadas: ${((_selecionadas as List?) ?? const []).length}',
                ),
              ],
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableSelecao,
      ),
      ShowcaseExample(
        title: 'Filtros',
        description:
            'showGlobalFilter, showColumnFilters, filterMatchMode por coluna e showClearFiltersButton.',
        preview:
            // #region sg-datatable-filtros
            SgDatatable(
              value: _pessoas,
              columns: const [
                SgDatatableColumn(field: 'nome', header: 'Nome', filter: true),
                SgDatatableColumn(
                  field: 'cidade',
                  header: 'Cidade',
                  filter: true,
                  filterMatchMode: SgDatatableFilterMatchMode.startsWith,
                ),
                SgDatatableColumn(
                  field: 'salario',
                  header: 'Salário',
                  excludeGlobalFilter: true,
                ),
              ],
              paginator: true,
              rows: 5,
              showGlobalFilter: true,
              showColumnFilters: true,
              showClearFiltersButton: true,
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableFiltros,
      ),
      ShowcaseExample(
        title: 'Colunas personalizadas e rodapé',
        description:
            'body desenha a célula, footer recebe as linhas processadas, hidden/hideable/reorderable e o gerenciador de colunas.',
        preview:
            // #region sg-datatable-colunas
            SgDatatable(
              id: 'pessoas-colunas',
              value: _pessoas.take(8).toList(),
              columns: [
                const SgDatatableColumn(
                  field: 'nome',
                  header: 'Nome',
                  hideable: false,
                  footer: 'Total',
                ),
                SgDatatableColumn(
                  field: 'salario',
                  header: 'Salário',
                  sortable: true,
                  align: SgDatatableColumnAlign.right,
                  body: (row, meta) =>
                      Text('R\$ ${(row['salario'] as num).toStringAsFixed(2)}'),
                  footer: (List<SgDatatableRow> rows) =>
                      'R\$ ${rows.fold<num>(0, (a, r) => a + (r['salario'] as num)).toStringAsFixed(2)}',
                ),
                const SgDatatableColumn(
                  field: 'cidade',
                  header: 'Cidade',
                  hidden: true,
                ),
              ],
              columnManagerLabel: 'Colunas visíveis',
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableColunas,
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
                    const SgDatatableColumn(field: 'nome', header: 'Nome'),
                    SgDatatableColumn(
                      field: 'acoes',
                      header: 'Ações',
                      width: 120,
                      body: (row, meta) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SgButton(
                            iconOnly: true,
                            size: SgSize.sm,
                            appearance: SgAppearance.outline,
                            leftIcon: const Icon(Icons.edit_outlined),
                            onClick: () => setState(
                              () => _evento = 'editar ${row['nome']}',
                            ),
                          ),
                          const SizedBox(width: 4),
                          SgButton(
                            iconOnly: true,
                            size: SgSize.sm,
                            severity: SgSeverity.danger,
                            appearance: SgAppearance.outline,
                            leftIcon: const Icon(Icons.delete_outline),
                            onClick: () => setState(
                              () => _evento = 'excluir ${row['nome']}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Última ação: $_evento'),
              ],
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableAcoes,
      ),
      ShowcaseExample(
        title: 'Aparência da tabela',
        description:
            'stripedRows alterna o fundo das linhas, showGridlines desenha as divisões e hoverableRows (padrão) destaca a linha sob o cursor.',
        preview:
            // #region sg-datatable-aparencia
            SgDatatable(
              id: 'pessoas-aparencia',
              value: _pessoas.take(5).toList(),
              columns: _colunas,
              stripedRows: true,
              showGridlines: true,
              showColumnManager: false,
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableAparencia,
      ),
      ShowcaseExample(
        title: 'Carga sob demanda (lazy)',
        description:
            'lazy não filtra nem ordena: você entrega só a página atual em value e o total em totalRecords; onPage pede a próxima.',
        preview:
            // #region sg-datatable-lazy
            SgDatatable(
              value: _paginaLazy,
              columns: _colunas,
              lazy: true,
              paginator: true,
              rows: 5,
              first: _first,
              totalRecords: _pessoas.length,
              onPage: _carregar,
            ),
        // #endregion
        code: SgDatatablePageSnippets.sgDatatableLazy,
      ),
      ShowcaseExample(
        title: 'Controle por código',
        description:
            'controller (o ref do React): goToPage, resetPage, resetSort, clearFilters, clearSelection, getProcessedRows e getPagedRows.',
        preview:
            // #region sg-datatable-controller
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgDatatable(
                  value: _pessoas,
                  columns: _colunas,
                  paginator: true,
                  rows: 5,
                  showGlobalFilter: true,
                  controller: _controller,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: const Text('Ir para a página 3'),
                      onClick: () => _controller.goToPage(3),
                    ),
                    SgButton(
                      label: const Text('Limpar filtros'),
                      onClick: () => _controller.clearFilters(),
                    ),
                    SgButton(
                      label: const Text('Remover ordem'),
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
        title: 'Carregando e vazio',
        description:
            'loading mostra a mensagem de carga; sem linhas, emptyMessage (ou o texto padrão do idioma).',
        preview:
            // #region sg-datatable-estados
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgDatatable(
                  title: 'Carregando',
                  value: const [],
                  columns: _colunas,
                  loading: true,
                  showColumnManager: false,
                ),
                const SizedBox(height: 16),
                SgDatatable(
                  title: 'Vazio',
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
    ];

    return SgShowcasePage(
      name: 'SgDatatable',
      description:
          'Tabela de dados com colunas configuráveis, paginação, ordenação, filtros, seleção, carga sob demanda e layout de colunas persistente.',
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
