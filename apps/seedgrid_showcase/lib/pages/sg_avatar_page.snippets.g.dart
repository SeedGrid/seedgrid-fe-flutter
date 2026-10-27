// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_avatar_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgAvatarPageSnippets {
  /// Region `sg-avatar-conteudo`.
  static const String sgAvatarConteudo = r'''
const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgAvatar(label: Text('Maria Silva')),
    SgAvatar(label: Text('joao')),
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
const SgAvatar(
  label: Text('Roxo Real'),
  customColors: SgAvatarCustomColors(
    bg: Color(0xFF7C3AED),
    fg: Colors.white,
    border: Color(0xFF6D28D9),
  ),
)
''';

  /// Region `sg-avatar-imagem`.
  static const String sgAvatarImagem = r'''
const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgAvatar(
      src: 'https://endereco.invalido.exemplo/foto.png',
      label: Text('Carlos Dias'),
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
      label: const Text('Ana Lima'),
      title: 'Abrir perfil',
      onClick: () => setState(() => _cliques++),
    ),
    SgAvatar(
      label: const Text('Bia Souza'),
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
const Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgAvatar(label: Text('XS'), size: SgAvatarSize.xs),
    SgAvatar(label: Text('SM'), size: SgAvatarSize.sm),
    SgAvatar(label: Text('MD')),
    SgAvatar(label: Text('LG'), size: SgAvatarSize.lg),
    SgAvatar(label: Text('XL'), size: SgAvatarSize.xl),
    SgAvatar(
      label: Text('Quadrado'),
      shape: SgAvatarShape.square,
      size: SgAvatarSize.lg,
    ),
    SgAvatar(label: Text('Sem borda'), bordered: false),
  ],
)
''';
}
