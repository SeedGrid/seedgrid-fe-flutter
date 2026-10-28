// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_avatar_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgAvatarPageSnippets {
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
SgAvatar(
  label: Text(context.tx('Roxo Real')),
  customColors: SgAvatarCustomColors(
    bg: Color(0xFF7C3AED),
    fg: Colors.white,
    border: Color(0xFF6D28D9),
  ),
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

  /// Region `sg-avatar-severidades`.
  static const String sgAvatarSeveridades = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    for (final s in SgAvatarSeverity.values)
      SgAvatar(label: Text(s.value), severity: s),
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
    SgAvatar(label: Text(context.tx('XS')), size: SgAvatarSize.xs),
    SgAvatar(label: Text(context.tx('SM')), size: SgAvatarSize.sm),
    SgAvatar(label: Text(context.tx('MD'))),
    SgAvatar(label: Text(context.tx('LG')), size: SgAvatarSize.lg),
    SgAvatar(label: Text(context.tx('XL')), size: SgAvatarSize.xl),
    SgAvatar(
      label: Text(context.tx('Quadrado')),
      shape: SgAvatarShape.square,
      size: SgAvatarSize.lg,
    ),
    SgAvatar(label: Text(context.tx('Sem borda')), bordered: false),
  ],
)
''';
}
