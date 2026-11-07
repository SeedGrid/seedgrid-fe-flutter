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
        title: 'Básico',
        description: 'Uso básico com label, ícone e imagem.',
        preview:
            // #region sg-avatar-basico
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
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarBasico,
      ),
      ShowcaseExample(
        title: 'Forma e tamanho',
        description: 'Combinações de shape e size.',
        preview:
            // #region sg-avatar-tamanhos
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
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarTamanhos,
      ),
      ShowcaseExample(
        title: 'Severidade e cores personalizadas',
        description: 'Preset por severity e override de cores.',
        preview:
            // #region sg-avatar-cores
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
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarCores,
      ),
      ShowcaseExample(
        title: 'Grupo de avatares',
        description: 'Agrupamento com sobreposição e contador automático.',
        preview:
            // #region sg-avatar-grupo
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
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarGrupo,
      ),
      // Exemplos só do Flutter (depois dos que espelham o React).
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
                  enabled: false,
                  onClick: () {},
                ),
                Text('Cliques: $_cliques'),
              ],
            ),
        // #endregion
        code: SgAvatarPageSnippets.sgAvatarInterativo,
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
                'enabled',
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
          enabled: (v['enabled'] as bool?) ?? true,
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
