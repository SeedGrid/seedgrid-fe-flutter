// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_badge_overlay_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgBadgeOverlayPageSnippets {
  /// Region `sg-badge-overlay-avatar`.
  static const String sgBadgeOverlayAvatar = r'''
const SgBadgeOverlay(
  badge: SgBadge(
    count: 3,
    size: SgBadgeSize.sm,
    severity: SgBadgeSeverity.danger,
  ),
  child: SgAvatar(label: Text('Ana Lima')),
)
''';

  /// Region `sg-badge-overlay-botao`.
  static const String sgBadgeOverlayBotao = r'''
SgBadgeOverlay(
  badge: const SgBadge(
    count: 12,
    max: 9,
    size: SgBadgeSize.xs,
    severity: SgBadgeSeverity.danger,
  ),
  child: SgButton(
    label: const Text('Mensagens'),
    appearance: SgAppearance.outline,
    onClick: () {},
  ),
)
''';

  /// Region `sg-badge-overlay-posicoes`.
  static const String sgBadgeOverlayPosicoes = r'''
Wrap(
  spacing: 28,
  runSpacing: 28,
  children: [
    for (final p in SgBadgeOverlayPlacement.values)
      SgBadgeOverlay(
        placement: p,
        badge: SgBadge(value: Text(p.value), size: SgBadgeSize.xs),
        child: Container(
          width: 64,
          height: 40,
          color: const Color(0x1A808080),
        ),
      ),
  ],
)
''';

  /// Region `sg-badge-overlay-status`.
  static const String sgBadgeOverlayStatus = r'''
const SgBadgeOverlay(
  placement: SgBadgeOverlayPlacement.bottomRight,
  badge: SgBadge(dot: true, severity: SgBadgeSeverity.success),
  child: SgAvatar(
    label: Text('Bia Souza'),
    severity: SgAvatarSeverity.info,
  ),
)
''';
}
