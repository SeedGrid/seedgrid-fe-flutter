// Showcase do SgBadge. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_badge_page.snippets.g.dart';

class SgBadgePage extends StatefulWidget {
  const SgBadgePage({super.key});

  @override
  State<SgBadgePage> createState() => _SgBadgePageState();
}

class _SgBadgePageState extends State<SgBadgePage> {
  String _ultimo = 'nada ainda';
  bool _tagVisivel = true;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Severidades e estilos',
        description:
            'Quatro estilos (solid, soft, outline, ghost) para cada severidade.',
        preview:
            // #region sg-badge-severidades
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
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeSeveridades,
      ),
      ShowcaseExample(
        title: 'Tamanhos, forma e ícones',
        preview:
            // #region sg-badge-tamanhos
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgBadge(value: Text('xs'), size: SgBadgeSize.xs),
                SgBadge(value: Text('sm'), size: SgBadgeSize.sm),
                SgBadge(value: Text('md')),
                SgBadge(value: Text('lg'), size: SgBadgeSize.lg),
                SgBadge(value: Text('quadrado'), rounded: false),
                SgBadge(value: Text('favorito'), leftIcon: Icon(Icons.star)),
                SgBadge(
                  value: Text('próximo'),
                  rightIcon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeTamanhos,
      ),
      ShowcaseExample(
        title: 'Contador com limite',
        description: 'count aplica max ("99+") e showZero.',
        preview:
            // #region sg-badge-contador
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgBadge(count: 5, severity: SgBadgeSeverity.danger),
                SgBadge(count: 150, max: 99, severity: SgBadgeSeverity.danger),
                SgBadge(count: 0),
                SgBadge(count: 0, showZero: false),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeContador,
      ),
      ShowcaseExample(
        title: 'Ponto de status',
        preview:
            // #region sg-badge-dot
            const Wrap(
              spacing: 16,
              children: [
                SgBadge(
                  dot: true,
                  severity: SgBadgeSeverity.success,
                  hint: 'Online',
                ),
                SgBadge(
                  dot: true,
                  severity: SgBadgeSeverity.danger,
                  pulse: true,
                  hint: 'Ao vivo',
                ),
                SgBadge(
                  dot: true,
                  severity: SgBadgeSeverity.neutral,
                  hint: 'Ausente',
                ),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeDot,
      ),
      ShowcaseExample(
        title: 'Clicável e removível',
        description:
            'Com onClick o selo vira botão; removable mostra o x e autoRemove o esconde.',
        preview:
            // #region sg-badge-interativo
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgBadge(
                  value: const Text('Clique'),
                  badgeStyle: SgBadgeBadgeStyle.outline,
                  onClick: () => setState(() => _ultimo = 'clique'),
                ),
                SgBadge(
                  value: const Text('Desabilitado'),
                  badgeStyle: SgBadgeBadgeStyle.outline,
                  disabled: true,
                  onClick: () {},
                ),
                if (_tagVisivel)
                  SgBadge(
                    value: const Text('tag'),
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
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeInterativo,
      ),
      ShowcaseExample(
        title: 'Cores customizadas',
        preview:
            // #region sg-badge-cores
            const SgBadge(
              value: Text('Roxo'),
              customColors: SgBadgeCustomColors(
                bg: Color(0xFF7C3AED),
                fg: Colors.white,
                border: Color(0xFF6D28D9),
              ),
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeCores,
      ),
    ];

    return SgShowcasePage(
      name: 'SgBadge',
      description:
          'Selo compacto para status, contagens e rótulos curtos, com estilos, tamanhos, ícones e remoção.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgBadge']!,
        const SgPropSpec(
          name: 'count',
          reactName: 'value (número)',
          type: 'num?',
          tsType: 'number',
          required: false,
          description:
              'Forma numérica de value: aplica max e showZero. value tem precedência.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgBadge']!
            .where(
              (s) => const {
                'severity',
                'badgeStyle',
                'size',
                'rounded',
                'dot',
                'pulse',
                'removable',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgBadge(
          value: const Text('Badge'),
          severity:
              SgBadgeSeverity.fromValue(v['severity'] as String?) ??
              SgBadgeSeverity.primary,
          badgeStyle:
              SgBadgeBadgeStyle.fromValue(v['badgeStyle'] as String?) ??
              SgBadgeBadgeStyle.solid,
          size: SgBadgeSize.fromValue(v['size'] as String?) ?? SgBadgeSize.md,
          rounded: (v['rounded'] as bool?) ?? true,
          dot: (v['dot'] as bool?) ?? false,
          pulse: (v['pulse'] as bool?) ?? false,
          removable: (v['removable'] as bool?) ?? false,
        ),
        codeBuilder: (v) {
          final args = <String>["value: const Text('Badge')"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'severity' =>
                'severity: SgBadgeSeverity.${SgBadgeSeverity.fromValue(e.value as String)!.name}',
              'badgeStyle' =>
                'badgeStyle: SgBadgeBadgeStyle.${SgBadgeBadgeStyle.fromValue(e.value as String)!.name}',
              'size' =>
                'size: SgBadgeSize.${SgBadgeSize.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgBadge(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
