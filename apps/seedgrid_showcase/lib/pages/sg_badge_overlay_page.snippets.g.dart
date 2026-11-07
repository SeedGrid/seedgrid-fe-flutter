// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_badge_overlay_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgBadgeOverlayPageSnippets {
  /// Region `sg-badge-overlay-avatar`.
  static const String sgBadgeOverlayAvatar = r'''
SgBadgeOverlay(
  badge: SgBadge(
    count: 3,
    size: SgBadgeSize.sm,
    severity: SgBadgeSeverity.danger,
  ),
  child: SgAvatar(label: Text(context.tx('Ana Lima'))),
)
''';

  /// Region `sg-badge-overlay-basico`.
  static const String sgBadgeOverlayBasico = r'''
Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    SgBadgeOverlay(
      badge: const SgBadge(
        count: 7,
        size: SgBadgeSize.xs,
        severity: SgBadgeSeverity.danger,
      ),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x66808080)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Bell'),
      ),
    ),
    SgBadgeOverlay(
      badge: const SgBadge(
        dot: true,
        severity: SgBadgeSeverity.success,
      ),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x66808080)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Check'),
      ),
    ),
  ],
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
    label: Text(context.tx('Mensagens')),
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
SgBadgeOverlay(
  placement: SgBadgeOverlayPlacement.bottomRight,
  badge: SgBadge(dot: true, severity: SgBadgeSeverity.success),
  child: SgAvatar(
    label: Text(context.tx('Bia Souza')),
    severity: SgAvatarSeverity.info,
  ),
)
''';
}
