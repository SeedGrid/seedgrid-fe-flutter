// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_badge_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgBadgePageSnippets {
  /// Region `sg-badge-contador`.
  static const String sgBadgeContador = r'''
const Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgBadge(count: 5, severity: SgBadgeSeverity.danger),
    SgBadge(count: 150, max: 99, severity: SgBadgeSeverity.danger),
    SgBadge(count: 0),
    SgBadge(count: 0, showZero: false),
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

  /// Region `sg-badge-dot`.
  static const String sgBadgeDot = r'''
Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    SgBadge(
      dot: true,
      severity: SgBadgeSeverity.success,
      hint: context.tx('Online'),
    ),
    SgBadge(
      dot: true,
      severity: SgBadgeSeverity.danger,
      pulse: true,
      hint: context.tx('Ao vivo'),
    ),
    SgBadge(
      dot: true,
      severity: SgBadgeSeverity.neutral,
      hint: context.tx('Ausente'),
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
      onClick: () => setState(() => _ultimo = 'clique'),
    ),
    SgBadge(
      value: Text(context.tx('Desabilitado')),
      badgeStyle: SgBadgeBadgeStyle.outline,
      disabled: true,
      onClick: () {},
    ),
    if (_tagVisivel)
      SgBadge(
        value: Text(context.tx('tag')),
        badgeStyle: SgBadgeBadgeStyle.soft,
        removable: true,
        autoRemove: true,
        onRemove: () => setState(() {
          _tagVisivel = false;
          _ultimo = 'removida';
        }),
      ),
    Text('Último evento: $_ultimo'),
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
    SgBadge(value: Text(context.tx('xs')), size: SgBadgeSize.xs),
    SgBadge(value: Text(context.tx('sm')), size: SgBadgeSize.sm),
    SgBadge(value: Text(context.tx('md'))),
    SgBadge(value: Text(context.tx('lg')), size: SgBadgeSize.lg),
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
}
