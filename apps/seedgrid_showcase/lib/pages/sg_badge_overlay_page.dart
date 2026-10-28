// Showcase do SgBadgeOverlay. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_badge_overlay_page.snippets.g.dart';

class SgBadgeOverlayPage extends StatelessWidget {
  const SgBadgeOverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Contador no canto do avatar',
        description: 'Padrão: top-right.',
        preview:
            // #region sg-badge-overlay-avatar
            SgBadgeOverlay(
              badge: SgBadge(
                count: 3,
                size: SgBadgeSize.sm,
                severity: SgBadgeSeverity.danger,
              ),
              child: SgAvatar(label: Text(context.tx('Ana Lima'))),
            ),
        // #endregion
        code: SgBadgeOverlayPageSnippets.sgBadgeOverlayAvatar,
      ),
      ShowcaseExample(
        title: 'Ponto de status',
        preview:
            // #region sg-badge-overlay-status
            SgBadgeOverlay(
              placement: SgBadgeOverlayPlacement.bottomRight,
              badge: SgBadge(dot: true, severity: SgBadgeSeverity.success),
              child: SgAvatar(
                label: Text(context.tx('Bia Souza')),
                severity: SgAvatarSeverity.info,
              ),
            ),
        // #endregion
        code: SgBadgeOverlayPageSnippets.sgBadgeOverlayStatus,
      ),
      ShowcaseExample(
        title: 'Em um botão',
        preview:
            // #region sg-badge-overlay-botao
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
            ),
        // #endregion
        code: SgBadgeOverlayPageSnippets.sgBadgeOverlayBotao,
      ),
      ShowcaseExample(
        title: 'Todas as posições',
        preview:
            // #region sg-badge-overlay-posicoes
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
            ),
        // #endregion
        code: SgBadgeOverlayPageSnippets.sgBadgeOverlayPosicoes,
      ),
    ];

    return SgShowcasePage(
      name: 'SgBadgeOverlay',
      description:
          'Posiciona um selo (SgBadge) sobre um canto ou borda de outro widget.',
      examples: examples,
      propSpecs: sgPropSpecs['SgBadgeOverlay']!,
      // Texto 5% menor: a lista de "bottom-right" estourava 1,8 px a caixa fixa de 220 px do SgPlayground
      // (so com a fonte larga dos testes). Correcao de verdade: isExpanded no dropdown do SgPlayground.
      playground: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 0.95,
        child: SgPlayground(
          specs: sgPropSpecs['SgBadgeOverlay']!
              .where((s) => s.name == 'placement')
              .toList(),
          builder: (context, v) => Padding(
            padding: const EdgeInsets.all(24),
            child: SgBadgeOverlay(
              placement:
                  SgBadgeOverlayPlacement.fromValue(
                    v['placement'] as String?,
                  ) ??
                  SgBadgeOverlayPlacement.topRight,
              badge: const SgBadge(
                count: 5,
                size: SgBadgeSize.sm,
                severity: SgBadgeSeverity.danger,
              ),
              child: const SgAvatar(label: Text('Ana Lima')),
            ),
          ),
          codeBuilder: (v) {
            final p = v['placement'] as String?;
            return 'SgBadgeOverlay(\n${p == null ? '' : '  placement: SgBadgeOverlayPlacement.${SgBadgeOverlayPlacement.fromValue(p)!.name},\n'}  badge: const SgBadge(count: 5),\n  child: const SgAvatar(label: Text(\'Ana Lima\')),\n)';
          },
        ),
      ),
    );
  }
}
