// Showcase do SgAvatar. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_avatar_page.snippets.g.dart';

class SgAvatarPage extends StatefulWidget {
  const SgAvatarPage({super.key});

  @override
  State<SgAvatarPage> createState() => _SgAvatarPageState();
}

class _SgAvatarPageState extends State<SgAvatarPage> {
  int _cliques = 0;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Iniciais, ícone e fallback',
        description: 'Do nome saem até 2 iniciais; sem nada, aparece "?".',
        preview:
            // #region sg-avatar-conteudo
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
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarConteudo,
      ),
      ShowcaseExample(
        title: 'Severidades',
        preview:
            // #region sg-avatar-severidades
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final s in SgAvatarSeverity.values)
                  SgAvatar(label: Text(s.value), severity: s),
              ],
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarSeveridades,
      ),
      ShowcaseExample(
        title: 'Tamanhos e formas',
        preview:
            // #region sg-avatar-tamanhos
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
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarTamanhos,
      ),
      ShowcaseExample(
        title: 'Imagem com fallback',
        description:
            'Se a imagem falhar, o avatar cai para as iniciais e chama onImageError.',
        preview:
            // #region sg-avatar-imagem
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SgAvatar(
                  src: 'https://endereco.invalido.exemplo/foto.png',
                  label: Text(context.tx('Carlos Dias')),
                ),
              ],
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarImagem,
      ),
      ShowcaseExample(
        title: 'Clicável e desabilitado',
        preview:
            // #region sg-avatar-interativo
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
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarInterativo,
      ),
      ShowcaseExample(
        title: 'Cores customizadas',
        preview:
            // #region sg-avatar-cores
            SgAvatar(
              label: Text(context.tx('Roxo Real')),
              customColors: SgAvatarCustomColors(
                bg: Color(0xFF7C3AED),
                fg: Colors.white,
                border: Color(0xFF6D28D9),
              ),
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarCores,
      ),
    ];

    return SgShowcasePage(
      name: 'SgAvatar',
      description:
          'Avatar com imagem, iniciais, ícone ou conteúdo próprio; severidades, tamanhos, formas e estado de erro da imagem.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgAvatar']!,
        const SgPropSpec(
          name: 'onClick',
          reactName: 'onClick',
          type: 'VoidCallback?',
          tsType: '() => void',
          required: false,
          description:
              'Torna o avatar interativo (herdado do span HTML no React).',
        ),
        const SgPropSpec(
          name: 'title',
          reactName: 'title',
          type: 'String?',
          tsType: 'string',
          required: false,
          description: 'Dica ao passar o mouse.',
        ),
        const SgPropSpec(
          name: 'semanticLabel',
          reactName: 'aria-label',
          type: 'String?',
          tsType: 'string',
          required: false,
          description:
              'Rótulo de acessibilidade; padrão: o label em texto ou o alt.',
        ),
        const SgPropSpec(
          name: 'imageProvider',
          reactName: '-',
          type: 'ImageProvider?',
          tsType: '-',
          required: false,
          description:
              'Imagem pronta (asset, memória); tem precedência sobre src. Só existe no Flutter.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgAvatar']!
            .where(
              (s) => const {
                'size',
                'shape',
                'severity',
                'bordered',
                'disabled',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgAvatar(
          label: const Text('Ana Lima'),
          size: SgAvatarSize.fromValue(v['size'] as String?) ?? SgAvatarSize.md,
          shape:
              SgAvatarShape.fromValue(v['shape'] as String?) ??
              SgAvatarShape.circle,
          severity:
              SgAvatarSeverity.fromValue(v['severity'] as String?) ??
              SgAvatarSeverity.primary,
          bordered: (v['bordered'] as bool?) ?? true,
          disabled: (v['disabled'] as bool?) ?? false,
        ),
        codeBuilder: (v) {
          final args = <String>["label: const Text('Ana Lima')"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'size' =>
                'size: SgAvatarSize.${SgAvatarSize.fromValue(e.value as String)!.name}',
              'shape' =>
                'shape: SgAvatarShape.${SgAvatarShape.fromValue(e.value as String)!.name}',
              'severity' =>
                'severity: SgAvatarSeverity.${SgAvatarSeverity.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgAvatar(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
