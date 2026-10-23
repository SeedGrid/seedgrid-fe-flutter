// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_group_box_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgGroupBoxPageSnippets {
  /// Region `sg-group-box-campos`.
  static const String sgGroupBoxCampos = r'''
const SgGroupBox(
  title: 'Dados do cliente',
  child: SgStack(
    gap: 12,
    children: [
      SgInputText(id: 'gb-nome', labelText: 'Nome'),
      SgInputText(id: 'gb-email', labelText: 'E-mail'),
    ],
  ),
)
''';

  /// Region `sg-group-box-lado`.
  static const String sgGroupBoxLado = r'''
const SgGrid(
  minItemWidth: 200,
  gap: 12,
  children: [
    SgGroupBox(
      title: 'Entrega',
      child: Text('Rua das Flores, 100'),
    ),
    SgGroupBox(title: 'Cobrança', child: Text('Mesmo endereço')),
  ],
)
''';

  /// Region `sg-group-box-largura`.
  static const String sgGroupBoxLargura = r'''
const SgStack(
  gap: 12,
  children: [
    SgGroupBox(
      title: 'Metade',
      width: '50%',
      child: Text('width: "50%"'),
    ),
    SgGroupBox(
      title: 'Fixa',
      width: 240,
      child: Text('width: 240'),
    ),
  ],
)
''';
}
