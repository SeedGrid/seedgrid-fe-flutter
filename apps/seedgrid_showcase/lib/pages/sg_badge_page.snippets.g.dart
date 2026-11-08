// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_badge_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgBadgePageSnippets {
  /// Region `sg-badge-acoes`.
  static const String sgBadgeAcoes = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgBadge(
      value: Text(context.tx('Remover auto')),
      removable: true,
      autoRemove: true,
      onRemove: () => _ultimo.value = context.tx('removida (auto)'),
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _manualVisivel,
      builder: (context, visivel, _) => visivel
          ? SgBadge(
              value: Text(context.tx('Remover manual')),
              removable: true,
              autoRemove: false,
              onRemove: () {
                _manualVisivel.value = false;
                _ultimo.value = context.tx('removida (manual)');
              },
            )
          : const SizedBox.shrink(),
    ),
    ValueListenableBuilder<String?>(
      valueListenable: _ultimo,
      builder: (context, ultimo, _) => Text(
        context.txf('Último evento: {evento}', {
          'evento': ultimo ?? context.tx('nada ainda'),
        }),
      ),
    ),
  ],
)
''';

  /// Region `sg-badge-basico`.
  static const String sgBadgeBasico = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgBadge(value: Text(context.tx('Admin'))),
    SgBadge(
      value: Text(context.tx('Pendente')),
      severity: SgBadgeSeverity.warning,
      badgeStyle: SgBadgeBadgeStyle.soft,
    ),
    SgBadge(
      value: Text(context.tx('Pago')),
      severity: SgBadgeSeverity.success,
      badgeStyle: SgBadgeBadgeStyle.solid,
    ),
  ],
)
''';

  /// Region `sg-badge-contador`.
  static const String sgBadgeContador = r'''
const Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgBadge(count: 3, severity: SgBadgeSeverity.danger),
    SgBadge(count: 120, max: 99, severity: SgBadgeSeverity.danger),
    SgBadge(dot: true, severity: SgBadgeSeverity.success),
    SgBadge(
      dot: true,
      severity: SgBadgeSeverity.success,
      pulse: true,
    ),
  ],
)
''';

  /// Region `sg-badge-cores`.
  static const String sgBadgeCores = r'''
SgBadge(
  value: Text(context.tx('Roxo')),
  customColors: SgBadgeCustomColors(
    bg: Color(0xFF7C3AED),
    fg: Colors.white,
    border: Color(0xFF6D28D9),
  ),
)
''';

  /// Region `sg-badge-forma`.
  static const String sgBadgeForma = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgBadge(value: Text(context.tx('quadrado')), rounded: false),
    SgBadge(
      value: Text(context.tx('favorito')),
      leftIcon: Icon(Icons.star),
    ),
    SgBadge(
      value: Text(context.tx('próximo')),
      rightIcon: Icon(Icons.arrow_forward),
    ),
  ],
)
''';

  /// Region `sg-badge-interativo`.
  static const String sgBadgeInterativo = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgBadge(
      value: Text(context.tx('Clique')),
      badgeStyle: SgBadgeBadgeStyle.outline,
      onClick: () => _ultimo.value = context.tx('clique'),
    ),
    SgBadge(
      value: Text(context.tx('Desabilitado')),
      badgeStyle: SgBadgeBadgeStyle.outline,
      enabled: false,
      onClick: () {},
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _tagVisivel,
      builder: (context, visivel, _) => visivel
          ? SgBadge(
              value: Text(context.tx('tag')),
              badgeStyle: SgBadgeBadgeStyle.soft,
              removable: true,
              autoRemove: true,
              onRemove: () {
                _tagVisivel.value = false;
                _ultimo.value = context.tx('removida');
              },
            )
          : const SizedBox.shrink(),
    ),
    ValueListenableBuilder<String?>(
      valueListenable: _ultimo,
      builder: (context, ultimo, _) => Text(
        context.txf('Último evento: {evento}', {
          'evento': ultimo ?? context.tx('nada ainda'),
        }),
      ),
    ),
  ],
)
''';

  /// Region `sg-badge-severidades`.
  static const String sgBadgeSeveridades = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final s in SgBadgeSeverity.values)
      SgBadge(value: Text(s.value), severity: s),
    for (final st in SgBadgeBadgeStyle.values)
      SgBadge(
        value: Text(st.value),
        badgeStyle: st,
        severity: SgBadgeSeverity.danger,
      ),
  ],
)
''';

  /// Region `sg-badge-tamanhos`.
  static const String sgBadgeTamanhos = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgBadge(value: Text(context.tx('XS')), size: SgBadgeSize.xs),
    SgBadge(value: Text(context.tx('SM')), size: SgBadgeSize.sm),
    SgBadge(value: Text(context.tx('MD')), size: SgBadgeSize.md),
    SgBadge(value: Text(context.tx('LG')), size: SgBadgeSize.lg),
  ],
)
''';

  /// Region `sg-badge-variantes`.
  static const String sgBadgeVariantes = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgBadge(
      value: Text(context.tx('Solid')),
      badgeStyle: SgBadgeBadgeStyle.solid,
    ),
    SgBadge(
      value: Text(context.tx('Soft')),
      badgeStyle: SgBadgeBadgeStyle.soft,
      severity: SgBadgeSeverity.secondary,
    ),
    SgBadge(
      value: Text(context.tx('Outline')),
      badgeStyle: SgBadgeBadgeStyle.outline,
      severity: SgBadgeSeverity.info,
    ),
    SgBadge(
      value: Text(context.tx('Ghost')),
      badgeStyle: SgBadgeBadgeStyle.ghost,
      severity: SgBadgeSeverity.neutral,
    ),
  ],
)
''';
}
