// Teste de familiaridade (T8.2) - tela 3: DIALOGO / CONFIRMACAO / TOAST.
// Porte de sg-datatable/samples/acoes.tsx.sample + sg-confirmation-dialog/samples/basico.tsx.sample
// + sg-toaster/samples/base-setup.tsx.sample (React).
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

// type PermissionRow = {...}: no Flutter a linha da tabela e Map<String, Object?> (SgDatatableRow).
const List<SgDatatableRow> permissionRows = [
  {
    'id': 1,
    'name': 'PERMIT_GET_ALL_SECRETS',
    'description': 'Permission to retrieve all secrets.',
  },
  {
    'id': 2,
    'name': 'PERMIT_GET_SECRET_BY_ID',
    'description': 'Permission to retrieve a secret by its ID.',
  },
  {
    'id': 3,
    'name': 'PERMIT_CREATE_NEW_SECRET',
    'description': 'Permission to create a new secret.',
  },
  {
    'id': 4,
    'name': 'PERMIT_DELETE_SECRET',
    'description': 'Permission to delete a secret.',
  },
  {
    'id': 5,
    'name': 'PERMIT_GET_ALL_USERS',
    'description': 'Permission to retrieve all users.',
  },
];

class DialogoToastScreen extends StatefulWidget {
  const DialogoToastScreen({super.key});

  @override
  State<DialogoToastScreen> createState() => _DialogoToastScreenState();
}

class _DialogoToastScreenState extends State<DialogoToastScreen> {
  List<SgDatatableRow> rows = List.of(permissionRows);
  String lastPermissionAction = 'none';
  bool confirmDeleteOpen = false;
  SgDatatableRow? pendingDelete;

  @override
  Widget build(BuildContext context) {
    final permissionColumns = [
      SgDatatableColumn(
        field: 'id',
        header: 'ID',
        sortable: true,
        align: SgDatatableColumnAlign.left,
        width: 80,
      ),
      SgDatatableColumn(field: 'name', header: 'Name', sortable: true),
      SgDatatableColumn(
        field: 'description',
        header: 'Description',
        sortable: true,
      ),
      SgDatatableColumn(
        header: 'Actions',
        align: SgDatatableColumnAlign.center,
        width: 120,
        body: (row, meta) => SgGrid(
          columns: 2,
          gap: 6,
          children: [
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.ghost,
              severity: SgSeverity.secondary,
              iconOnly: true,
              leftIcon: const Icon(Icons.edit),
              onClick: () =>
                  setState(() => lastPermissionAction = 'edit: ${row['name']}'),
            ),
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.ghost,
              severity: SgSeverity.danger,
              iconOnly: true,
              leftIcon: const Icon(Icons.delete),
              onClick: () => setState(() {
                pendingDelete = row;
                confirmDeleteOpen = true;
              }),
            ),
          ],
        ),
      ),
    ];

    // <SgToaster /> e fixo na janela no React; aqui precisa de um Stack com area limitada.
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SgDatatable(
                id: 'datatable-actions',
                title: 'Permissions with row actions',
                value: rows,
                columns: permissionColumns,
                dataKey: 'id',
                paginator: true,
                rows: 4,
                rowsPerPageOptions: [4, 8],
                showGridlines: true,
              ),
              SgConfirmationDialog(
                open: confirmDeleteOpen,
                onOpenChange: (v) => setState(() => confirmDeleteOpen = v),
                closeOnOverlayClick: false,
                severity: SgDialogSeverity.danger,
                title: const Text('Delete permission'),
                message: Text(
                  pendingDelete != null
                      ? 'Confirm delete ${pendingDelete!['name']}?'
                      : 'Confirm delete?',
                ),
                confirmButton: SgConfirmationDialogButtonConfig(
                  label: const Text('Delete'),
                  icon: const Icon(Icons.delete),
                  severity: SgSeverity.danger,
                ),
                onCancel: () => setState(() {
                  confirmDeleteOpen = false;
                  pendingDelete = null;
                }),
                onConfirm: () {
                  if (pendingDelete == null) return;
                  setState(() {
                    rows = rows
                        .where((item) => item['id'] != pendingDelete!['id'])
                        .toList();
                    lastPermissionAction = 'delete: ${pendingDelete!['name']}';
                    confirmDeleteOpen = false;
                    pendingDelete = null;
                  });
                  toast.success('Sucesso!');
                },
              ),
              Text('last action: $lastPermissionAction'),
              Wrap(
                spacing: 8,
                children: [
                  SgButton(
                    onClick: () => toast.message('Mensagem básica'),
                    child: const Text('toast.message'),
                  ),
                  SgButton(
                    severity: SgSeverity.success,
                    onClick: () => toast.success('Sucesso!'),
                    child: const Text('toast.success'),
                  ),
                  SgButton(
                    appearance: SgAppearance.outline,
                    onClick: () => toast.dismiss(),
                    child: const Text('toast.dismiss'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SgToaster(),
      ],
    );
  }
}
