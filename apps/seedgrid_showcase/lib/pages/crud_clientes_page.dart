// Showcase de um CRUD completo (clientes) so com componentes SeedGrid: lista com busca e tabela,
// tela de novo/editar com formulario e exclusao com confirmacao. Os dados vem de um JSON local
// (assets/data/clientes.json); nao ha back-end, as alteracoes ficam na memoria.
// O codigo exibido em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo:
// as proprias classes que a pagina renderiza.
// Padrao de comportamento (tela de lista e tela de edicao separadas, `publicId`, busca com minimo de
// 3 caracteres, confirmacao antes de excluir, aviso ao salvar) da skill sg-crud-front do React.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'crud_clientes_page.snippets.g.dart';

const List<String> _planos = ['Básico', 'Pro', 'Enterprise'];

const List<SgDatatableRow> _amostra = [
  {
    'publicId': 'cli-0001',
    'nome': 'Ana Lima',
    'email': 'ana.lima@exemplo.com',
    'cidade': 'São Paulo',
    'plano': 'Básico',
    'limite': 1000.0,
    'ativo': true,
  },
  {
    'publicId': 'cli-0002',
    'nome': 'Bruno Souza',
    'email': 'bruno.souza@exemplo.com',
    'cidade': 'Recife',
    'plano': 'Pro',
    'limite': 1750.0,
    'ativo': true,
  },
  {
    'publicId': 'cli-0003',
    'nome': 'Carla Dias',
    'email': 'carla.dias@exemplo.com',
    'cidade': 'Curitiba',
    'plano': 'Enterprise',
    'limite': 2500.0,
    'ativo': false,
  },
  {
    'publicId': 'cli-0004',
    'nome': 'Daniel Rocha',
    'email': 'daniel.rocha@exemplo.com',
    'cidade': 'Salvador',
    'plano': 'Básico',
    'limite': 3250.0,
    'ativo': true,
  },
];

// #region crud-clientes-lista
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
  String _busca = '';
  bool _confirmando = false;
  String _alvo = '';

  List<SgDatatableRow> get _filtradas {
    final termo = _busca.toLowerCase();
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
                  onSearchChange: (valor) => setState(() => _busca = valor),
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
        SgDatatable(
          value: _filtradas,
          dataKey: 'publicId',
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
                    onClick: () => setState(() {
                      _alvo = '${row['publicId']}';
                      _confirmando = true;
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        SgConfirmationDialog(
          open: _confirmando,
          onOpenChange: (aberto) => setState(() => _confirmando = aberto),
          severity: SgDialogSeverity.danger,
          title: Text(context.tx('Excluir cliente?')),
          message: Text(context.tx('Esta ação não pode ser desfeita.')),
          onConfirm: () => widget.onExcluir(_alvo),
        ),
      ],
    );
  }
}
// #endregion

// #region crud-clientes-form
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
// #endregion

// #region crud-clientes-completo
class ClientesCrud extends StatefulWidget {
  const ClientesCrud({super.key});

  @override
  State<ClientesCrud> createState() => _ClientesCrudState();
}

class _ClientesCrudState extends State<ClientesCrud> {
  List<SgDatatableRow>? _clientes;
  bool _editando = false;
  String? _publicId;

  bool _pedido = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pedido) return;
    _pedido = true;
    _carregar(DefaultAssetBundle.of(context));
  }

  Future<void> _carregar(AssetBundle bundle) async {
    final texto = await bundle.loadString('assets/data/clientes.json');
    if (!mounted) return;
    setState(() {
      _clientes = [
        for (final c in jsonDecode(texto) as List)
          Map<String, Object?>.from(c as Map),
      ];
    });
  }

  void _abrir([String? publicId]) => setState(() {
    _publicId = publicId;
    _editando = true;
  });

  void _salvar(Map<String, Object?> dados) {
    final i = _clientes!.indexWhere((c) => c['publicId'] == _publicId);
    setState(() {
      if (i >= 0) {
        _clientes![i] = {..._clientes![i], ...dados};
      } else {
        _clientes!.add({
          'publicId': 'cli-${DateTime.now().microsecondsSinceEpoch}',
          ...dados,
        });
      }
      _editando = false;
    });
    toast.success(
      i >= 0
          ? context.tx('Cliente atualizado.')
          : context.tx('Cliente criado.'),
    );
  }

  void _excluir(String publicId) {
    setState(() => _clientes!.removeWhere((c) => c['publicId'] == publicId));
    toast.success(context.tx('Cliente excluído.'));
  }

  @override
  Widget build(BuildContext context) {
    final clientes = _clientes;
    if (clientes == null) {
      return SgDatatable(value: const [], columns: const [], loading: true);
    }
    if (_editando) {
      return ClienteForm(
        key: ValueKey(_publicId),
        cliente: clientes.cast<SgDatatableRow?>().firstWhere(
          (c) => c!['publicId'] == _publicId,
          orElse: () => null,
        ),
        onSalvar: _salvar,
        onCancelar: () => setState(() => _editando = false),
      );
    }
    return ClientesLista(
      clientes: clientes,
      onNovo: _abrir,
      onEditar: _abrir,
      onExcluir: _excluir,
    );
  }
}
// #endregion

class CrudClientesPage extends StatefulWidget {
  const CrudClientesPage({super.key});

  @override
  State<CrudClientesPage> createState() => _CrudClientesPageState();
}

class _CrudClientesPageState extends State<CrudClientesPage> {
  String _acao = 'nenhuma ação ainda';
  String _salvo = 'nada salvo ainda';

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Lista com busca e ações',
        description:
            'SgInputTextSearch filtra por nome ou e-mail (3 ou mais caracteres); SgDatatable ordena e pagina; editar e excluir ficam em cada linha, e excluir pede confirmação.',
        preview: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClientesLista(
              clientes: _amostra,
              onNovo: () => setState(() => _acao = 'Novo'),
              onEditar: (id) => setState(() => _acao = 'Editar $id'),
              onExcluir: (id) => setState(() => _acao = 'Excluir $id'),
            ),
            const SizedBox(height: 8),
            Text('Última ação: $_acao'),
          ],
        ),
        code: CrudClientesPageSnippets.crudClientesLista,
      ),
      ShowcaseExample(
        title: 'Novo e editar',
        description:
            'Tela própria de edição: SgForm com campos de cada tipo (texto, e-mail, combobox, moeda e interruptor); Salvar valida, Cancelar volta.',
        preview: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClienteForm(
              cliente: _amostra.first,
              onSalvar: (dados) => setState(() => _salvo = jsonEncode(dados)),
              onCancelar: () => setState(() => _salvo = 'cancelado'),
            ),
            const SizedBox(height: 8),
            Text('Resultado: $_salvo'),
          ],
        ),
        code: CrudClientesPageSnippets.crudClientesForm,
      ),
      ShowcaseExample(
        title: 'CRUD completo, lendo de JSON',
        description:
            'Carrega assets/data/clientes.json e liga as duas telas: Novo e Editar abrem o formulário, salvar volta à lista com um aviso, excluir confirma antes.',
        preview: const ClientesCrud(),
        code: CrudClientesPageSnippets.crudClientesCompleto,
      ),
    ];

    return SgShowcasePage(
      name: 'CrudClientes',
      description:
          'Exemplo de CRUD completo só com componentes SeedGrid: lista com busca e tabela, tela de novo/editar com formulário, exclusão com confirmação e dados lidos de um JSON local.',
      examples: examples,
      propSpecs: const [
        SgPropSpec(
          name: 'clientes',
          reactName: 'clientes',
          type: 'List<SgDatatableRow>',
          tsType: 'Row[]',
          required: true,
          description:
              'ClientesLista: linhas exibidas na tabela (cada uma com publicId).',
        ),
        SgPropSpec(
          name: 'onNovo',
          reactName: 'onNovo',
          type: 'VoidCallback',
          tsType: '() => void',
          required: true,
          description: 'ClientesLista: chamado ao tocar em Novo.',
        ),
        SgPropSpec(
          name: 'onEditar',
          reactName: 'onEditar',
          type: 'ValueChanged<String>',
          tsType: '(publicId: string) => void',
          required: true,
          description:
              'ClientesLista: chamado com o publicId da linha ao tocar em editar.',
        ),
        SgPropSpec(
          name: 'onExcluir',
          reactName: 'onExcluir',
          type: 'ValueChanged<String>',
          tsType: '(publicId: string) => void',
          required: true,
          description:
              'ClientesLista: chamado com o publicId da linha depois de confirmar a exclusão.',
        ),
        SgPropSpec(
          name: 'stripedRows',
          reactName: 'stripedRows',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'true',
          description: 'ClientesLista: linhas alternadas na tabela.',
        ),
        SgPropSpec(
          name: 'showGridlines',
          reactName: 'showGridlines',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'ClientesLista: linhas de grade na tabela.',
        ),
        SgPropSpec(
          name: 'hoverableRows',
          reactName: 'hoverableRows',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'true',
          description: 'ClientesLista: destaca a linha sob o ponteiro.',
        ),
        SgPropSpec(
          name: 'cliente',
          reactName: 'cliente',
          type: 'SgDatatableRow?',
          tsType: 'Row | undefined',
          required: false,
          description:
              'ClienteForm: cliente a editar; nulo abre um cliente novo.',
        ),
        SgPropSpec(
          name: 'onSalvar',
          reactName: 'onSalvar',
          type: 'ValueChanged<Map<String, Object?>>',
          tsType: '(dados: Record<string, unknown>) => void',
          required: true,
          description:
              'ClienteForm: chamado com os valores do formulário depois de validar.',
        ),
        SgPropSpec(
          name: 'onCancelar',
          reactName: 'onCancelar',
          type: 'VoidCallback',
          tsType: '() => void',
          required: true,
          description: 'ClienteForm: chamado ao tocar em Cancelar.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgDatatable']!
            .where(
              (s) => const {
                'stripedRows',
                'showGridlines',
                'hoverableRows',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => ClientesLista(
          clientes: _amostra,
          onNovo: () {},
          onEditar: (_) {},
          onExcluir: (_) {},
          stripedRows: v['stripedRows'] != false,
          showGridlines: v['showGridlines'] == true,
          hoverableRows: v['hoverableRows'] != false,
        ),
        codeBuilder: (v) =>
            'ClientesLista(\n  clientes: clientes,\n  stripedRows: ${v['stripedRows'] != false},\n  showGridlines: ${v['showGridlines'] == true},\n  hoverableRows: ${v['hoverableRows'] != false},\n)',
      ),
    );
  }
}
