// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_toolbar_icon_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgToolbarIconButtonPageSnippets {
  /// Region `sg-toolbar-icon-button-basico`.
  static const String sgToolbarIconButtonBasico = r'''
SgToolbarIconButton(
  icon: const Icon(Icons.add),
  label: context.tx('Novo'),
  hint: context.tx('Criar um registro'),
  onClick: () => setState(() => _cliques++),
)
''';

  /// Region `sg-toolbar-icon-button-estados`.
  static const String sgToolbarIconButtonEstados = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgToolbarIconButton(
      icon: Icon(Icons.lock_outline),
      label: context.tx('Bloqueado'),
      disabled: true,
    ),
    SgToolbarIconButton(
      icon: Icon(Icons.sync),
      label: context.tx('Carregando'),
      loading: true,
    ),
    SgToolbarIconButton(
      icon: const Icon(Icons.cloud_upload_outlined),
      label: context.tx('Enviar'),
      onClick: () =>
          Future<void>.delayed(const Duration(seconds: 2)),
    ),
    SgToolbarIconButton(
      icon: Icon(Icons.search),
      label: context.tx('Buscar'),
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
