// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_avatar_group_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgAvatarGroupPageSnippets {
  /// Region `sg-avatar-group-mais`.
  static const String sgAvatarGroupMais = r'''
SgAvatarGroup(
  max: 2,
  moreSeverity: SgAvatarSeverity.info,
  moreLabel: (restantes) => Text('+$restantes'),
  shape: SgAvatarShape.square,
  children: const [
    SgAvatar(label: Text('Ana Lima'), shape: SgAvatarShape.square),
    SgAvatar(label: Text('Bia Souza'), shape: SgAvatarShape.square),
    SgAvatar(label: Text('Caio Reis'), shape: SgAvatarShape.square),
    SgAvatar(label: Text('Duda Melo'), shape: SgAvatarShape.square),
  ],
)
''';

  /// Region `sg-avatar-group-max`.
  static const String sgAvatarGroupMax = r'''
const SgAvatarGroup(
  max: 3,
  total: 12,
  children: [
    SgAvatar(label: Text('Ana Lima')),
    SgAvatar(
      label: Text('Bia Souza'),
      severity: SgAvatarSeverity.success,
    ),
    SgAvatar(
      label: Text('Caio Reis'),
      severity: SgAvatarSeverity.warning,
    ),
    SgAvatar(
      label: Text('Duda Melo'),
      severity: SgAvatarSeverity.danger,
    ),
  ],
)
''';

  /// Region `sg-avatar-group-overlap`.
  static const String sgAvatarGroupOverlap = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (final o in SgAvatarGroupOverlap.values)
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SgAvatarGroup(
          overlap: o,
          size: SgAvatarSize.sm,
          children: const [
            SgAvatar(label: Text('A B'), size: SgAvatarSize.sm),
            SgAvatar(label: Text('C D'), size: SgAvatarSize.sm),
            SgAvatar(label: Text('E F'), size: SgAvatarSize.sm),
          ],
        ),
      ),
  ],
)
''';

  /// Region `sg-avatar-group-simples`.
  static const String sgAvatarGroupSimples = r'''
const SgAvatarGroup(
  children: [
    SgAvatar(label: Text('Ana Lima')),
    SgAvatar(
      label: Text('Bia Souza'),
      severity: SgAvatarSeverity.success,
    ),
    SgAvatar(
      label: Text('Caio Reis'),
      severity: SgAvatarSeverity.warning,
    ),
  ],
)
''';
}
