// Showcase do SgAvatarGroup. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_avatar_group_page.snippets.g.dart';

class SgAvatarGroupPage extends StatelessWidget {
  const SgAvatarGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Grupo simples',
        description: 'Os avatares se sobrepõem em 8 px (overlap md).',
        preview:
            // #region sg-avatar-group-simples
            SgAvatarGroup(
              children: [
                SgAvatar(label: Text(context.tx('Ana Lima'))),
                SgAvatar(
                  label: Text(context.tx('Bia Souza')),
                  severity: SgAvatarSeverity.success,
                ),
                SgAvatar(
                  label: Text(context.tx('Caio Reis')),
                  severity: SgAvatarSeverity.warning,
                ),
              ],
            ),
        // #endregion
        code: SgAvatarGroupPageSnippets.sgAvatarGroupSimples,
      ),
      ShowcaseExample(
        title: 'Limite com +n',
        description:
            'max esconde o excesso; total soma quem não está na lista.',
        preview:
            // #region sg-avatar-group-max
            SgAvatarGroup(
              max: 3,
              total: 12,
              children: [
                SgAvatar(label: Text(context.tx('Ana Lima'))),
                SgAvatar(
                  label: Text(context.tx('Bia Souza')),
                  severity: SgAvatarSeverity.success,
                ),
                SgAvatar(
                  label: Text(context.tx('Caio Reis')),
                  severity: SgAvatarSeverity.warning,
                ),
                SgAvatar(
                  label: Text(context.tx('Duda Melo')),
                  severity: SgAvatarSeverity.danger,
                ),
              ],
            ),
        // #endregion
        code: SgAvatarGroupPageSnippets.sgAvatarGroupMax,
      ),
      ShowcaseExample(
        title: 'Sobreposição',
        preview:
            // #region sg-avatar-group-overlap
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
            ),
        // #endregion
        code: SgAvatarGroupPageSnippets.sgAvatarGroupOverlap,
      ),
      ShowcaseExample(
        title: 'Rótulo e severidade do excesso',
        preview:
            // #region sg-avatar-group-mais
            SgAvatarGroup(
              max: 2,
              moreSeverity: SgAvatarSeverity.info,
              moreLabel: (restantes) => Text('+$restantes'),
              shape: SgAvatarShape.square,
              children: [
                SgAvatar(
                  label: Text(context.tx('Ana Lima')),
                  shape: SgAvatarShape.square,
                ),
                SgAvatar(
                  label: Text(context.tx('Bia Souza')),
                  shape: SgAvatarShape.square,
                ),
                SgAvatar(
                  label: Text(context.tx('Caio Reis')),
                  shape: SgAvatarShape.square,
                ),
                SgAvatar(
                  label: Text(context.tx('Duda Melo')),
                  shape: SgAvatarShape.square,
                ),
              ],
            ),
        // #endregion
        code: SgAvatarGroupPageSnippets.sgAvatarGroupMais,
      ),
    ];

    return SgShowcasePage(
      name: 'SgAvatarGroup',
      description:
          'Agrupa avatares sobrepostos, com limite de exibição e contador do excesso.',
      examples: examples,
      propSpecs: [
        const SgPropSpec(
          name: 'children',
          reactName: 'children',
          type: 'List<Widget>',
          tsType: 'ReactNode',
          required: true,
          description:
              'Os avatares do grupo (no contrato gerado aparece como child).',
        ),
        ...sgPropSpecs['SgAvatarGroup']!,
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgAvatarGroup']!
            .where(
              (s) => const {
                'overlap',
                'moreSeverity',
                'size',
                'shape',
                'bordered',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) {
          final size =
              SgAvatarSize.fromValue(v['size'] as String?) ?? SgAvatarSize.md;
          final shape =
              SgAvatarShape.fromValue(v['shape'] as String?) ??
              SgAvatarShape.circle;
          final bordered = (v['bordered'] as bool?) ?? true;
          return SgAvatarGroup(
            max: 3,
            total: 8,
            overlap:
                SgAvatarGroupOverlap.fromValue(v['overlap'] as String?) ??
                SgAvatarGroupOverlap.md,
            moreSeverity:
                SgAvatarSeverity.fromValue(v['moreSeverity'] as String?) ??
                SgAvatarSeverity.neutral,
            size: size,
            shape: shape,
            bordered: bordered,
            children: [
              for (final n in const [
                'Ana Lima',
                'Bia Souza',
                'Caio Reis',
                'Duda Melo',
              ])
                SgAvatar(
                  label: Text(n),
                  size: size,
                  shape: shape,
                  bordered: bordered,
                ),
            ],
          );
        },
        codeBuilder: (v) {
          final args = <String>['max: 3', 'total: 8'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'overlap' =>
                'overlap: SgAvatarGroupOverlap.${SgAvatarGroupOverlap.fromValue(e.value as String)!.name}',
              'moreSeverity' =>
                'moreSeverity: SgAvatarSeverity.${SgAvatarSeverity.fromValue(e.value as String)!.name}',
              'size' =>
                'size: SgAvatarSize.${SgAvatarSize.fromValue(e.value as String)!.name}',
              'shape' =>
                'shape: SgAvatarShape.${SgAvatarShape.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgAvatarGroup(\n  ${args.join(',\n  ')},\n  children: [/* SgAvatar... */],\n)';
        },
      ),
    );
  }
}
