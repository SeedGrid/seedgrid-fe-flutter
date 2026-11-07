// Showcase do SgBadge. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_badge_page.snippets.g.dart';

class SgBadgePage extends StatefulWidget {
  const SgBadgePage({super.key});

  @override
  State<SgBadgePage> createState() => _SgBadgePageState();
}

class _SgBadgePageState extends State<SgBadgePage> {
  String? _ultimo;
  bool _tagVisivel = true;
  bool _manualVisivel = true;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Exemplos simples de uso.',
        preview:
            // #region sg-badge-basico
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgBadge(value: Text(context.tx('Admin'))),
                SgBadge(
                  value: Text(context.tx('Pendente')),
                  severity: SgBadgeSeverity.warning,
                  badgeStyle: SgBadgeBadgeStyle.soft,
                ),
                SgBadge(
                  value: Text(context.tx('Pago')),
                  severity: SgBadgeSeverity.success,
                  badgeStyle: SgBadgeBadgeStyle.solid,
                ),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeBasico,
      ),
      ShowcaseExample(
        title: 'Variantes',
        description: 'Solid, soft, outline e ghost.',
        preview:
            // #region sg-badge-variantes
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgBadge(
                  value: Text(context.tx('Solid')),
                  badgeStyle: SgBadgeBadgeStyle.solid,
                ),
                SgBadge(
                  value: Text(context.tx('Soft')),
                  badgeStyle: SgBadgeBadgeStyle.soft,
                  severity: SgBadgeSeverity.secondary,
                ),
                SgBadge(
                  value: Text(context.tx('Outline')),
                  badgeStyle: SgBadgeBadgeStyle.outline,
                  severity: SgBadgeSeverity.info,
                ),
                SgBadge(
                  value: Text(context.tx('Ghost')),
                  badgeStyle: SgBadgeBadgeStyle.ghost,
                  severity: SgBadgeSeverity.neutral,
                ),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeVariantes,
      ),
      ShowcaseExample(
        title: 'Tamanhos',
        description: 'XS, SM, MD e LG.',
        preview:
            // #region sg-badge-tamanhos
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgBadge(value: Text(context.tx('XS')), size: SgBadgeSize.xs),
                SgBadge(value: Text(context.tx('SM')), size: SgBadgeSize.sm),
                SgBadge(value: Text(context.tx('MD')), size: SgBadgeSize.md),
                SgBadge(value: Text(context.tx('LG')), size: SgBadgeSize.lg),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeTamanhos,
      ),
      ShowcaseExample(
        title: 'Contador e dot',
        description: 'Badge numérico, max e indicador.',
        preview:
            // #region sg-badge-contador
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgBadge(count: 3, severity: SgBadgeSeverity.danger),
                SgBadge(count: 120, max: 99, severity: SgBadgeSeverity.danger),
                SgBadge(dot: true, severity: SgBadgeSeverity.success),
                SgBadge(
                  dot: true,
                  severity: SgBadgeSeverity.success,
                  pulse: true,
                ),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeContador,
      ),
      ShowcaseExample(
        title: 'Ações',
        description: 'Removível e clicável.',
        preview:
            // #region sg-badge-acoes
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgBadge(
                  value: Text(context.tx('Remover auto')),
                  removable: true,
                  autoRemove: true,
                  onRemove: () => setState(() => _ultimo = context.tx('removida (auto)')),
                ),
                if (_manualVisivel)
                  SgBadge(
                    value: Text(context.tx('Remover manual')),
                    removable: true,
                    autoRemove: false,
                    onRemove: () => setState(() {
                      _manualVisivel = false;
                      _ultimo = context.tx('removida (manual)');
                    }),
                  ),
                Text(
                  context.txf('Último evento: {evento}', {
                    'evento': _ultimo ?? context.tx('nada ainda'),
                  }),
                ),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeAcoes,
      ),
      ShowcaseExample(
        title: 'Severidades',
        description:
            'Cada severidade e cada estilo (solid, soft, outline, ghost).',
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
        title: 'Forma e ícones',
        description: 'rounded: false, leftIcon e rightIcon.',
        preview:
            // #region sg-badge-forma
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgBadge(value: Text(context.tx('quadrado')), rounded: false),
                SgBadge(
                  value: Text(context.tx('favorito')),
                  leftIcon: Icon(Icons.star),
                ),
                SgBadge(
                  value: Text(context.tx('próximo')),
                  rightIcon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeForma,
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
                  value: Text(context.tx('Clique')),
                  badgeStyle: SgBadgeBadgeStyle.outline,
                  onClick: () => setState(() => _ultimo = context.tx('clique')),
                ),
                SgBadge(
                  value: Text(context.tx('Desabilitado')),
                  badgeStyle: SgBadgeBadgeStyle.outline,
                  enabled: false,
                  onClick: () {},
                ),
                if (_tagVisivel)
                  SgBadge(
                    value: Text(context.tx('tag')),
                    badgeStyle: SgBadgeBadgeStyle.soft,
                    removable: true,
                    autoRemove: true,
                    onRemove: () => setState(() {
                      _tagVisivel = false;
                      _ultimo = context.tx('removida');
                    }),
                  ),
                Text(
                  context.txf('Último evento: {evento}', {
                    'evento': _ultimo ?? context.tx('nada ainda'),
                  }),
                ),
              ],
            ),
        // #endregion
        code: SgBadgePageSnippets.sgBadgeInterativo,
      ),
      ShowcaseExample(
        title: 'Cores personalizadas',
        description: 'customColors define fundo, texto e borda do selo.',
        preview:
            // #region sg-badge-cores
            SgBadge(
              value: Text(context.tx('Roxo')),
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
