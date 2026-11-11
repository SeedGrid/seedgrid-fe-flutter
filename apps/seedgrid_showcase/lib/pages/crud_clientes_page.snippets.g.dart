// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de crud_clientes_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class CrudClientesPageSnippets {
  /// Region `crud-clientes`.
  static const String crudClientes = r'''
class ClientesCrud extends StatefulWidget {
  const ClientesCrud({super.key});

  @override
  State<ClientesCrud> createState() => _ClientesCrudState();
}

class _ClientesCrudState extends State<ClientesCrud> {
  final ValueNotifier<List<SgDatatableRow>?> _clientes = ValueNotifier(null);
  final ValueNotifier<bool> _editando = ValueNotifier(false);
  final ValueNotifier<String?> _publicId = ValueNotifier(null);

  bool _pedido = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pedido) return;
    _pedido = true;
    _carregar(DefaultAssetBundle.of(context));
  }

  @override
  void dispose() {
    _clientes.dispose();
    _editando.dispose();
    _publicId.dispose();
    super.dispose();
  }

  Future<void> _carregar(AssetBundle bundle) async {
    final texto = await bundle.loadString('assets/data/clientes.json');
    if (!mounted) return;
    _clientes.value = [
      for (final c in jsonDecode(texto) as List)
        Map<String, Object?>.from(c as Map),
    ];
  }

  void _abrir([String? publicId]) {
    _publicId.value = publicId;
    _editando.value = true;
  }

  void _salvar(Map<String, Object?> dados) {
    final lista = [..._clientes.value!];
    final i = lista.indexWhere((c) => c['publicId'] == _publicId.value);
    if (i >= 0) {
      lista[i] = {...lista[i], ...dados};
    } else {
      lista.add({
        'publicId': 'cli-${DateTime.now().microsecondsSinceEpoch}',
        ...dados,
      });
    }
    _clientes.value = lista;
    _editando.value = false;
    toast.success(
      i >= 0
          ? context.tx('Cliente atualizado.')
          : context.tx('Cliente criado.'),
    );
  }

  void _excluir(String publicId) {
    _clientes.value = [
      for (final c in _clientes.value!)
        if (c['publicId'] != publicId) c,
    ];
    toast.success(context.tx('Cliente excluído.'));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_clientes, _editando, _publicId]),
      builder: (context, _) {
        final clientes = _clientes.value;
        if (clientes == null) {
          return SgDatatable(value: const [], columns: const [], loading: true);
        }
        if (_editando.value) {
          return ClienteForm(
            key: ValueKey(_publicId.value),
            cliente: clientes.cast<SgDatatableRow?>().firstWhere(
              (c) => c!['publicId'] == _publicId.value,
              orElse: () => null,
            ),
            onSalvar: _salvar,
            onCancelar: () => _editando.value = false,
          );
        }
        return ClientesLista(
          clientes: clientes,
          onNovo: _abrir,
          onEditar: _abrir,
          onExcluir: _excluir,
        );
      },
    );
  }
}

class ClientesLista extends StatefulWidget {
  const ClientesLista({
    super.key,
    required this.clientes,
    required this.onNovo,
    required this.onEditar,
    required this.onExcluir,
    this.stripedRows = true,
    this.showGridlines = false,
    this.hoverableRows = true,
  });

  final List<SgDatatableRow> clientes;
  final VoidCallback onNovo;
  final ValueChanged<String> onEditar;
  final ValueChanged<String> onExcluir;
  final bool stripedRows;
  final bool showGridlines;
  final bool hoverableRows;

  @override
  State<ClientesLista> createState() => _ClientesListaState();
}

class _ClientesListaState extends State<ClientesLista> {
  final ValueNotifier<String> _busca = ValueNotifier('');
  final ValueNotifier<bool> _confirmando = ValueNotifier(false);
  String _alvo = '';

  @override
  void dispose() {
    _busca.dispose();
    _confirmando.dispose();
    super.dispose();
  }

  List<SgDatatableRow> _filtrar(String busca) {
    final termo = busca.toLowerCase();
    return [
      for (final c in widget.clientes)
        if (termo.isEmpty ||
            '${c['nome']}'.toLowerCase().contains(termo) ||
            '${c['email']}'.toLowerCase().contains(termo))
          c,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SgStack(
      gap: 12,
      children: [
        SgStack(
          direction: SgStackDirection.row,
          align: SgStackAlign.end,
          gap: 12,
          children: [
            SgStack(
              grow: true,
              children: [
                SgInputTextSearch(
                  id: 'clientes-busca',
                  labelText: context.tx('Buscar por nome ou e-mail'),
                  prefixIcon: const Icon(Icons.search),
                  onSearchChange: (valor) => _busca.value = valor,
                ),
              ],
            ),
            SgButton(
              label: Text(context.tx('Novo')),
              leftIcon: const Icon(Icons.add),
              onClick: widget.onNovo,
            ),
          ],
        ),
        ValueListenableBuilder<String>(
          valueListenable: _busca,
          builder: (context, busca, _) => SgDatatable(
            id: 'clientes-tabela',
            value: _filtrar(busca),
            dataKey: 'publicId',
            showColumnManager: true,
            paginator: true,
            rows: 5,
            stripedRows: widget.stripedRows,
            showGridlines: widget.showGridlines,
            hoverableRows: widget.hoverableRows,
            emptyMessage: context.tx('Nenhum cliente encontrado.'),
            columns: [
              SgDatatableColumn(
                field: 'nome',
                minWidth: 160,
                header: context.tx('Nome'),
                sortable: true,
              ),
              SgDatatableColumn(
                field: 'email',
                minWidth: 220,
                header: context.tx('E-mail'),
              ),
              SgDatatableColumn(
                field: 'cidade',
                minWidth: 130,
                header: context.tx('Cidade'),
                sortable: true,
              ),
              SgDatatableColumn(
                field: 'plano',
                minWidth: 120,
                header: context.tx('Plano'),
                sortable: true,
              ),
              SgDatatableColumn(
                field: 'limite',
                minWidth: 120,
                header: context.tx('Limite'),
                sortable: true,
                align: SgDatatableColumnAlign.right,
                body: (row, meta) => Text(
                  'R\$ ${(row['limite'] as num).toStringAsFixed(2).replaceAll('.', ',')}',
                ),
              ),
              SgDatatableColumn(
                field: 'ativo',
                width: 150,
                header: context.tx('Situação'),
                body: (row, meta) => SgBadge(
                  value: Text(
                    row['ativo'] == true
                        ? context.tx('Ativo')
                        : context.tx('Inativo'),
                  ),
                  severity: row['ativo'] == true
                      ? SgBadgeSeverity.success
                      : SgBadgeSeverity.danger,
                ),
              ),
              SgDatatableColumn(
                header: context.tx('Ações'),
                width: 120,
                align: SgDatatableColumnAlign.right,
                body: (row, meta) => SgStack(
                  direction: SgStackDirection.row,
                  justify: SgStackJustify.end,
                  gap: 4,
                  children: [
                    SgButton(
                      iconOnly: true,
                      size: SgSize.sm,
                      appearance: SgAppearance.ghost,
                      leftIcon: const Icon(Icons.edit),
                      onClick: () => widget.onEditar('${row['publicId']}'),
                    ),
                    SgButton(
                      iconOnly: true,
                      size: SgSize.sm,
                      appearance: SgAppearance.ghost,
                      severity: SgSeverity.danger,
                      leftIcon: const Icon(Icons.delete),
                      onClick: () {
                        _alvo = '${row['publicId']}';
                        _confirmando.value = true;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _confirmando,
          builder: (context, confirmando, _) => SgConfirmationDialog(
            open: confirmando,
            onOpenChange: (aberto) => _confirmando.value = aberto,
            severity: SgDialogSeverity.danger,
            title: Text(context.tx('Excluir cliente?')),
            message: Text(context.tx('Esta ação não pode ser desfeita.')),
            onConfirm: () => widget.onExcluir(_alvo),
          ),
        ),
      ],
    );
  }
}

class ClienteForm extends StatefulWidget {
  const ClienteForm({
    super.key,
    this.cliente,
    required this.onSalvar,
    required this.onCancelar,
  });

  /// Nulo = cliente novo.
  final SgDatatableRow? cliente;
  final ValueChanged<Map<String, Object?>> onSalvar;
  final VoidCallback onCancelar;

  @override
  State<ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  late final SgFormController _form = SgFormController(
    defaultValues: {
      'nome': widget.cliente?['nome'] ?? '',
      'email': widget.cliente?['email'] ?? '',
      'cidade': widget.cliente?['cidade'] ?? '',
      'plano': widget.cliente?['plano'] ?? 'Básico',
      'limite': ((widget.cliente?['limite'] as num?) ?? 0).toStringAsFixed(2),
      'ativo': widget.cliente?['ativo'] ?? true,
    },
  );

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SgForm(
      controller: _form,
      onValid: (dados) => widget.onSalvar({
        ...dados,
        'limite': double.tryParse('${dados['limite']}') ?? 0.0,
      }),
      child: SgStack(
        gap: 16,
        children: [
          SgGroupBox(
            title: widget.cliente == null
                ? context.tx('Novo cliente')
                : context.tx('Editar cliente'),
            child: SgGrid(
              columns: {'base': 1, 'sm': 2},
              gap: 16,
              children: [
                SgInputText(
                  id: 'cliente-nome',
                  name: 'nome',
                  control: _form,
                  label: context.tx('Nome'),
                  required: true,
                ),
                SgInputEmail(
                  id: 'cliente-email',
                  name: 'email',
                  control: _form,
                  label: context.tx('E-mail'),
                  required: true,
                ),
                SgInputText(
                  id: 'cliente-cidade',
                  name: 'cidade',
                  control: _form,
                  label: context.tx('Cidade'),
                ),
                SgCombobox<String>(
                  id: 'cliente-plano',
                  name: 'plano',
                  control: _form,
                  labelText: context.tx('Plano'),
                  source: _planos,
                ),
                SgInputCurrency(
                  id: 'cliente-limite',
                  name: 'limite',
                  control: _form,
                  label: context.tx('Limite de crédito'),
                  currency: 'BRL',
                ),
                SgToggleSwitch(
                  id: 'cliente-ativo',
                  name: 'ativo',
                  control: _form,
                  label: context.tx('Cliente ativo'),
                ),
              ],
            ),
          ),
          SgStack(
            direction: SgStackDirection.row,
            justify: SgStackJustify.end,
            gap: 8,
            children: [
              SgButton(
                label: Text(context.tx('Cancelar')),
                appearance: SgAppearance.outline,
                onClick: widget.onCancelar,
              ),
              SgButton(
                label: Text(context.tx('Salvar')),
                type: SgButtonType.submit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
''';
}
