// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_toolbar_icon_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgToolbarIconButtonPageSnippets {
  /// Region `sg-toolbar-icon-button-basico`.
  static const String sgToolbarIconButtonBasico = r'''
SgToolbarIconButton(
  icon: const Icon(Icons.add),
  label: 'Novo',
  hint: 'Criar um registro',
  onClick: () => setState(() => _cliques++),
)
''';

  /// Region `sg-toolbar-icon-button-estados`.
  static const String sgToolbarIconButtonEstados = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    const SgToolbarIconButton(
      icon: Icon(Icons.lock_outline),
      label: 'Bloqueado',
      disabled: true,
    ),
    const SgToolbarIconButton(
      icon: Icon(Icons.sync),
      label: 'Carregando',
      loading: true,
    ),
    SgToolbarIconButton(
      icon: const Icon(Icons.cloud_upload_outlined),
      label: 'Enviar',
      onClick: () =>
          Future<void>.delayed(const Duration(seconds: 2)),
    ),
    const SgToolbarIconButton(
      icon: Icon(Icons.search),
      label: 'Buscar',
      hideLabel: true,
    ),
  ],
)
''';

  /// Region `sg-toolbar-icon-button-severidades`.
  static const String sgToolbarIconButtonSeveridades = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final s in SgToolbarIconButtonSeverity.values)
      SgToolbarIconButton(
        icon: const Icon(Icons.circle_outlined),
        label: s.value,
        severity: s,
      ),
  ],
)
''';
}
