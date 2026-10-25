// Teste de familiaridade (T8.2) - tela 2: TABELA COM FILTRO.
// Porte de apps/showcase/src/app/components/sg-datatable/samples/filtros.tsx.sample (React).
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

// type ProductRow = {...}: no Flutter a linha da tabela e Map<String, Object?> (SgDatatableRow).
const List<SgDatatableRow> productRows = [
  {
    'id': 1,
    'code': 'P-1000',
    'name': 'Notebook Pro 14',
    'category': 'Computers',
    'price': 1899,
    'stock': 22,
    'status': 'INSTOCK',
  },
  {
    'id': 2,
    'code': 'P-1001',
    'name': 'Mechanical Keyboard',
    'category': 'Accessories',
    'price': 149,
    'stock': 64,
    'status': 'INSTOCK',
  },
  {
    'id': 3,
    'code': 'P-1002',
    'name': 'Ergonomic Mouse',
    'category': 'Accessories',
    'price': 89,
    'stock': 48,
    'status': 'INSTOCK',
  },
  {
    'id': 4,
    'code': 'P-1003',
    'name': '4K Monitor 27',
    'category': 'Monitors',
    'price': 499,
    'stock': 8,
    'status': 'LOWSTOCK',
  },
  {
    'id': 5,
    'code': 'P-1004',
    'name': 'USB-C Dock',
    'category': 'Accessories',
    'price': 219,
    'stock': 11,
    'status': 'LOWSTOCK',
  },
  {
    'id': 6,
    'code': 'P-1005',
    'name': 'Noise Cancelling Headset',
    'category': 'Audio',
    'price': 329,
    'stock': 31,
    'status': 'INSTOCK',
  },
  {
    'id': 7,
    'code': 'P-1006',
    'name': 'Webcam 4K',
    'category': 'Video',
    'price': 179,
    'stock': 0,
    'status': 'OUTOFSTOCK',
  },
  {
    'id': 8,
    'code': 'P-1007',
    'name': 'Portable SSD 2TB',
    'category': 'Storage',
    'price': 259,
    'stock': 19,
    'status': 'INSTOCK',
  },
  {
    'id': 9,
    'code': 'P-1008',
    'name': 'Wi-Fi Router AX',
    'category': 'Networking',
    'price': 199,
    'stock': 5,
    'status': 'LOWSTOCK',
  },
  {
    'id': 10,
    'code': 'P-1009',
    'name': 'Graphics Tablet',
    'category': 'Creative',
    'price': 399,
    'stock': 13,
    'status': 'INSTOCK',
  },
  {
    'id': 11,
    'code': 'P-1010',
    'name': 'Studio Microphone',
    'category': 'Audio',
    'price': 249,
    'stock': 7,
    'status': 'LOWSTOCK',
  },
  {
    'id': 12,
    'code': 'P-1011',
    'name': 'Smart Light Bar',
    'category': 'Home Office',
    'price': 99,
    'stock': 0,
    'status': 'OUTOFSTOCK',
  },
];

const filterColumns = [
  SgDatatableColumn(
    field: 'code',
    header: 'Code',
    sortable: true,
    filter: true,
    filterPlaceholder: 'Filter code',
  ),
  SgDatatableColumn(
    field: 'name',
    header: 'Name',
    sortable: true,
    filter: true,
    filterPlaceholder: 'Filter name',
  ),
  SgDatatableColumn(
    field: 'category',
    header: 'Category',
    sortable: true,
    filter: true,
    filterPlaceholder: 'Filter category',
  ),
  SgDatatableColumn(
    field: 'status',
    header: 'Status',
    sortable: true,
    filter: true,
    filterPlaceholder: 'Filter status',
  ),
  SgDatatableColumn(
    field: 'price',
    header: 'Price',
    sortable: true,
    align: SgDatatableColumnAlign.right,
  ),
];

class TabelaFiltroScreen extends StatelessWidget {
  const TabelaFiltroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SgDatatable(
        id: 'datatable-filter',
        title: 'Search and filter',
        value: productRows,
        columns: filterColumns,
        dataKey: 'id',
        paginator: true,
        rows: 6,
        showGlobalFilter: true,
        showColumnFilters: true,
        showClearFiltersButton: true,
      ),
    );
  }
}
