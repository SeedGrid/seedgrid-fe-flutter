// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_avatar_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgAvatarPageSnippets {
  /// Region `sg-avatar-basico`.
  static const String sgAvatarBasico = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgAvatar(label: Text(context.tx('P'))),
    SgAvatar(
      icon: Icon(Icons.person),
      severity: SgAvatarSeverity.secondary,
    ),
    SgAvatar(
      src: 'https://i.pravatar.cc/150?img=32',
      label: Text(context.tx('Amy Elsner')),
    ),
  ],
)
''';

  /// Region `sg-avatar-conteudo`.
  static const String sgAvatarConteudo = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgAvatar(label: Text(context.tx('Maria Silva'))),
    SgAvatar(label: Text(context.tx('joao'))),
    SgAvatar(
      icon: Icon(Icons.person),
      severity: SgAvatarSeverity.info,
    ),
    SgAvatar(),
    SgAvatar(
      fallback: Icon(Icons.help_outline),
      severity: SgAvatarSeverity.neutral,
    ),
  ],
)
''';

  /// Region `sg-avatar-cores`.
  static const String sgAvatarCores = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgAvatar(
      label: Text(context.tx('P')),
      severity: SgAvatarSeverity.primary,
    ),
    SgAvatar(
      label: Text(context.tx('S')),
      severity: SgAvatarSeverity.success,
    ),
    SgAvatar(
      label: Text(context.tx('D')),
      severity: SgAvatarSeverity.danger,
    ),
    SgAvatar(
      icon: Icon(Icons.photo_camera),
      severity: SgAvatarSeverity.custom,
      customColors: SgAvatarCustomColors(
        bg: Color(0xFF7C3AED),
        fg: Color(0xFFFFFFFF),
        border: Color(0xFF5B21B6),
        ring: Color(0x597C3AED),
      ),
    ),
  ],
)
''';

  /// Region `sg-avatar-grupo`.
  static const String sgAvatarGrupo = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgAvatarGroup(
      children: [
        SgAvatar(
          src: 'https://i.pravatar.cc/150?img=32',
          label: Text(context.tx('Amy Elsner')),
        ),
        SgAvatar(
          src: 'https://i.pravatar.cc/150?img=47',
          label: Text(context.tx('Asiya Javayant')),
        ),
        SgAvatar(
          src: 'https://i.pravatar.cc/150?img=12',
          label: Text(context.tx('Onyama Limba')),
        ),
        SgAvatar(
          src: 'https://i.pravatar.cc/150?img=56',
          label: Text(context.tx('Ioni Bowcher')),
        ),
      ],
    ),
    const SizedBox(height: 16),
    SgAvatarGroup(
      max: 3,
      total: 6,
      size: SgAvatarSize.sm,
      moreSeverity: SgAvatarSeverity.secondary,
      children: [
        SgAvatar(
          icon: Icon(Icons.group),
          severity: SgAvatarSeverity.info,
          size: SgAvatarSize.sm,
        ),
        SgAvatar(
          label: Text(context.tx('AL')),
          severity: SgAvatarSeverity.success,
          size: SgAvatarSize.sm,
        ),
        SgAvatar(
          label: Text(context.tx('BK')),
          severity: SgAvatarSeverity.warning,
          size: SgAvatarSize.sm,
        ),
        SgAvatar(
          label: Text(context.tx('CM')),
          severity: SgAvatarSeverity.danger,
          size: SgAvatarSize.sm,
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-avatar-imagem`.
  static const String sgAvatarImagem = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgAvatar(
      src: 'https://endereco.invalido.exemplo/foto.png',
      label: Text(context.tx('Carlos Dias')),
    ),
  ],
)
''';

  /// Region `sg-avatar-interativo`.
  static const String sgAvatarInterativo = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgAvatar(
      label: Text(context.tx('Ana Lima')),
      title: context.tx('Abrir perfil'),
      onClick: () => setState(() => _cliques++),
    ),
    SgAvatar(
      label: Text(context.tx('Bia Souza')),
      disabled: true,
      onClick: () {},
    ),
    Text('Cliques: $_cliques'),
  ],
)
''';

  /// Region `sg-avatar-tamanhos`.
  static const String sgAvatarTamanhos = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgAvatar(
      label: Text(context.tx('C')),
      shape: SgAvatarShape.circle,
    ),
    SgAvatar(
      label: Text(context.tx('S')),
      shape: SgAvatarShape.square,
    ),
    SgAvatar(label: Text(context.tx('XS')), size: SgAvatarSize.xs),
    SgAvatar(label: Text(context.tx('LG')), size: SgAvatarSize.lg),
    SgAvatar(
      src: 'https://i.pravatar.cc/150?img=47',
      label: Text(context.tx('Asiya Javayant')),
      shape: SgAvatarShape.square,
    ),
  ],
)
''';
}
