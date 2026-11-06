// Showcase do SgFloatActionButton. Mesmos exemplos, na mesma ordem, do showcase React (a fonte da verdade).
// O codigo exibido em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo.
// Nos exemplos o botao usa `absolute: true` dentro de uma area de 260 px, para ficar no proprio
// exemplo; sem `absolute` ele flutua sobre a janela inteira (como `position: fixed`).
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_float_action_button_page.snippets.g.dart';

class SgFloatActionButtonPage extends StatelessWidget {
  const SgFloatActionButtonPage({super.key});

  Widget _area(Widget child) => SizedBox(
    height: 260,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Posições',
        description:
            'O FAB pode ser posicionado em 8 pontos da área usando a prop position.',
        preview:
            // #region sg-fab-posicoes
            SizedBox(
              height: 288,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.leftTop,
                      size: SgFloatActionButtonSize.sm,
                      icon: const Icon(Icons.edit),
                      onClick: () {},
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.centerTop,
                      severity: SgFloatActionButtonSeverity.secondary,
                      size: SgFloatActionButtonSize.sm,
                      icon: const Icon(Icons.edit),
                      onClick: () {},
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.rightTop,
                      severity: SgFloatActionButtonSeverity.success,
                      size: SgFloatActionButtonSize.sm,
                      icon: const Icon(Icons.edit),
                      onClick: () {},
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.leftCenter,
                      severity: SgFloatActionButtonSeverity.warning,
                      size: SgFloatActionButtonSize.sm,
                      icon: const Icon(Icons.edit),
                      onClick: () {},
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.rightCenter,
                      severity: SgFloatActionButtonSeverity.danger,
                      size: SgFloatActionButtonSize.sm,
                      icon: const Icon(Icons.edit),
                      onClick: () {},
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.leftBottom,
                      size: SgFloatActionButtonSize.sm,
                      icon: const Icon(Icons.edit),
                      onClick: () {},
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.centerBottom,
                      severity: SgFloatActionButtonSeverity.secondary,
                      size: SgFloatActionButtonSize.sm,
                      icon: const Icon(Icons.edit),
                      onClick: () {},
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.rightBottom,
                      severity: SgFloatActionButtonSeverity.success,
                      size: SgFloatActionButtonSize.sm,
                      icon: const Icon(Icons.edit),
                      onClick: () {},
                    ),
                    Center(
                      child: Text(
                        context.tx('8 positions'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabPosicoes,
      ),
      ShowcaseExample(
        title: 'Severidades',
        description:
            'Cores do tema: primary, secondary, success, info, warning, help, danger e plain.',
        preview:
            // #region sg-fab-severidades
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                for (final severity in const [
                  SgFloatActionButtonSeverity.primary,
                  SgFloatActionButtonSeverity.secondary,
                  SgFloatActionButtonSeverity.success,
                  SgFloatActionButtonSeverity.info,
                  SgFloatActionButtonSeverity.warning,
                  SgFloatActionButtonSeverity.help,
                  SgFloatActionButtonSeverity.danger,
                  SgFloatActionButtonSeverity.plain,
                ])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 104,
                        child: SgFloatActionButton(
                          absolute: true,
                          severity: severity,
                          onClick: () {},
                        ),
                      ),
                      Text(severity.value, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
              ],
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabSeveridades,
      ),
      ShowcaseExample(
        title: 'Formas e Tamanhos',
        description:
            'Combine shape (circle, rounded, square) com size (sm, md, lg).',
        preview:
            // #region sg-fab-formas-tamanhos
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                for (final shape in const [
                  SgFloatActionButtonShape.circle,
                  SgFloatActionButtonShape.rounded,
                  SgFloatActionButtonShape.square,
                ])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(shape.value, style: Theme.of(context).textTheme.labelMedium),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final (size, lado) in const [
                            (SgFloatActionButtonSize.sm, 88.0),
                            (SgFloatActionButtonSize.md, 104.0),
                            (SgFloatActionButtonSize.lg, 112.0),
                          ])
                            SizedBox.square(
                              dimension: lado,
                              child: SgFloatActionButton(
                                absolute: true,
                                shape: shape,
                                size: size,
                                onClick: () {},
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabFormasTamanhos,
      ),
      ShowcaseExample(
        title: 'Elevação',
        description:
            'Controle a sombra com elevation: none, sm, md ou lg.',
        preview:
            // #region sg-fab-elevacao
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                for (final elevation in const [
                  SgFloatActionButtonElevation.none,
                  SgFloatActionButtonElevation.sm,
                  SgFloatActionButtonElevation.md,
                  SgFloatActionButtonElevation.lg,
                ])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 104,
                        child: SgFloatActionButton(
                          absolute: true,
                          elevation: elevation,
                          onClick: () {},
                        ),
                      ),
                      Text(elevation.value, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
              ],
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabElevacao,
      ),
      ShowcaseExample(
        title: 'Dica (Tooltip)',
        description:
            'Exibe um tooltip ao passar o mouse (ou manter pressionado) sobre o FAB.',
        preview:
            // #region sg-fab-dica
            Wrap(
              spacing: 32,
              runSpacing: 32,
              children: [
                for (final hintPosition in const [
                  SgFloatActionButtonHintPosition.top,
                  SgFloatActionButtonHintPosition.right,
                  SgFloatActionButtonHintPosition.bottom,
                  SgFloatActionButtonHintPosition.left,
                ])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 104,
                        child: SgFloatActionButton(
                          absolute: true,
                          hint: context.tx('Adicionar novo'),
                          hintPosition: hintPosition,
                          hintDelay: 0,
                          onClick: () {},
                        ),
                      ),
                      Text(
                        'hintPosition="${hintPosition.value}"',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabDica,
      ),
      ShowcaseExample(
        title: 'Ações (Speed Dial)',
        description:
            'Clique no FAB para expandir botões de ação em diferentes direções.',
        preview:
            // #region sg-fab-speed-dial
            Builder(
              builder: (context) {
                final acoes = [
                  SgFABAction(
                    icon: const Icon(Icons.person_add),
                    label: context.tx('Novo usuário'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.note_add),
                    label: context.tx('Novo arquivo'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.create_new_folder),
                    label: context.tx('Nova pasta'),
                    onClick: () {},
                  ),
                ];
                final acoesSemRotulo = [
                  for (final a in acoes) SgFABAction(icon: a.icon, onClick: a.onClick),
                ];
                Widget caixa(double altura, String legenda, Widget fab) => SizedBox(
                  height: altura,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12,
                          top: 8,
                          child: Text(legenda, style: Theme.of(context).textTheme.bodySmall),
                        ),
                        fab,
                      ],
                    ),
                  ),
                );
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: caixa(
                          288,
                          'type="linear" direction="up"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.centerBottom,
                            actions: acoes,
                            type: SgFloatActionButtonType.linear,
                            direction: SgFloatActionButtonDirection.up,
                          ),
                        )),
                        const SizedBox(width: 32),
                        Expanded(child: caixa(
                          288,
                          'type="linear" direction="down"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.centerTop,
                            actions: acoes,
                            type: SgFloatActionButtonType.linear,
                            direction: SgFloatActionButtonDirection.down,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: caixa(
                          96,
                          'type="linear" direction="left"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.rightCenter,
                            actions: acoesSemRotulo,
                            type: SgFloatActionButtonType.linear,
                            direction: SgFloatActionButtonDirection.left,
                          ),
                        )),
                        const SizedBox(width: 32),
                        Expanded(child: caixa(
                          96,
                          'type="linear" direction="right"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.leftCenter,
                            actions: acoesSemRotulo,
                            type: SgFloatActionButtonType.linear,
                            direction: SgFloatActionButtonDirection.right,
                          ),
                        )),
                      ],
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabSpeedDial,
      ),
      ShowcaseExample(
        title: 'Circle Layout',
        description:
            'Actions arranged in a full circle around the button',
        preview:
            // #region sg-fab-circle
            Builder(
              builder: (context) {
                final acoes = [
                  SgFABAction(
                    icon: const Icon(Icons.person_add),
                    label: context.tx('Novo usuário'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.note_add),
                    label: context.tx('Novo arquivo'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.create_new_folder),
                    label: context.tx('Nova pasta'),
                    onClick: () {},
                  ),
                ];
                Widget caixa(double altura, String legenda, Widget fab) => SizedBox(
                  height: altura,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12,
                          top: 8,
                          child: Text(legenda, style: Theme.of(context).textTheme.bodySmall),
                        ),
                        fab,
                      ],
                    ),
                  ),
                );
                return caixa(
                  384,
                  'type="circle"',
                  SgFloatActionButton(
                    absolute: true,
                    position: SgFloatActionButtonPosition.centerTop,
                    offset: const SgFABOffset(y: 100),
                    actions: [
                      ...acoes,
                      ...acoes,
                      SgFABAction(
                        icon: const Icon(Icons.edit),
                        label: context.tx('Edit'),
                        onClick: () {},
                      ),
                    ],
                    type: SgFloatActionButtonType.circle,
                    radius: 120,
                    severity: SgFloatActionButtonSeverity.secondary,
                  ),
                );
              },
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabCircle,
      ),
      ShowcaseExample(
        title: 'Semi-Circle Layout',
        description:
            'Actions arranged in a semi-circle (180°) in different directions',
        preview:
            // #region sg-fab-semi-circle
            Builder(
              builder: (context) {
                final acoes = [
                  SgFABAction(
                    icon: const Icon(Icons.person_add),
                    label: context.tx('Novo usuário'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.note_add),
                    label: context.tx('Novo arquivo'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.create_new_folder),
                    label: context.tx('Nova pasta'),
                    onClick: () {},
                  ),
                ];
                final acoesExtras = [
                  ...acoes,
                  SgFABAction(
                    icon: const Icon(Icons.edit),
                    label: context.tx('Edit'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.star),
                    label: context.tx('Star'),
                    onClick: () {},
                  ),
                ];
                final acoesSemRotulo = [
                  for (final a in acoes) SgFABAction(icon: a.icon, onClick: a.onClick),
                ];
                Widget caixa(double altura, String legenda, Widget fab) => SizedBox(
                  height: altura,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12,
                          top: 8,
                          child: Text(legenda, style: Theme.of(context).textTheme.bodySmall),
                        ),
                        fab,
                      ],
                    ),
                  ),
                );
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: caixa(
                          288,
                          'type="semi-circle" direction="up"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.centerBottom,
                            actions: acoesExtras,
                            type: SgFloatActionButtonType.semiCircle,
                            direction: SgFloatActionButtonDirection.up,
                            severity: SgFloatActionButtonSeverity.success,
                          ),
                        )),
                        const SizedBox(width: 32),
                        Expanded(child: caixa(
                          288,
                          'type="semi-circle" direction="down"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.centerTop,
                            actions: acoesExtras,
                            type: SgFloatActionButtonType.semiCircle,
                            direction: SgFloatActionButtonDirection.down,
                            severity: SgFloatActionButtonSeverity.warning,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: caixa(
                          192,
                          'type="semi-circle" direction="left"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.rightCenter,
                            actions: acoesSemRotulo,
                            type: SgFloatActionButtonType.semiCircle,
                            direction: SgFloatActionButtonDirection.left,
                            severity: SgFloatActionButtonSeverity.danger,
                          ),
                        )),
                        const SizedBox(width: 32),
                        Expanded(child: caixa(
                          192,
                          'type="semi-circle" direction="right"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.leftCenter,
                            actions: acoesSemRotulo,
                            type: SgFloatActionButtonType.semiCircle,
                            direction: SgFloatActionButtonDirection.right,
                          ),
                        )),
                      ],
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabSemiCircle,
      ),
      ShowcaseExample(
        title: 'Quarter-Circle Layout',
        description:
            'Actions arranged in a quarter circle (90°) in different directions',
        preview:
            // #region sg-fab-quarter-circle
            Builder(
              builder: (context) {
                final acoes = [
                  SgFABAction(
                    icon: const Icon(Icons.person_add),
                    label: context.tx('Novo usuário'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.note_add),
                    label: context.tx('Novo arquivo'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.create_new_folder),
                    label: context.tx('Nova pasta'),
                    onClick: () {},
                  ),
                ];
                final acoesSemRotulo = [
                  for (final a in acoes) SgFABAction(icon: a.icon, onClick: a.onClick),
                ];
                Widget caixa(double altura, String legenda, Widget fab) => SizedBox(
                  height: altura,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12,
                          top: 8,
                          child: Text(legenda, style: Theme.of(context).textTheme.bodySmall),
                        ),
                        fab,
                      ],
                    ),
                  ),
                );
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: caixa(
                          256,
                          'type="quarter-circle" direction="up"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.centerBottom,
                            actions: acoes,
                            type: SgFloatActionButtonType.quarterCircle,
                            direction: SgFloatActionButtonDirection.up,
                            severity: SgFloatActionButtonSeverity.secondary,
                          ),
                        )),
                        const SizedBox(width: 32),
                        Expanded(child: caixa(
                          256,
                          'type="quarter-circle" direction="down"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.centerTop,
                            actions: acoes,
                            type: SgFloatActionButtonType.quarterCircle,
                            direction: SgFloatActionButtonDirection.down,
                            severity: SgFloatActionButtonSeverity.success,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: caixa(
                          192,
                          'type="quarter-circle" direction="left"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.rightCenter,
                            actions: acoesSemRotulo,
                            type: SgFloatActionButtonType.quarterCircle,
                            direction: SgFloatActionButtonDirection.left,
                            severity: SgFloatActionButtonSeverity.warning,
                          ),
                        )),
                        const SizedBox(width: 32),
                        Expanded(child: caixa(
                          192,
                          'type="quarter-circle" direction="right"',
                          SgFloatActionButton(
                            absolute: true,
                            position: SgFloatActionButtonPosition.leftCenter,
                            actions: acoesSemRotulo,
                            type: SgFloatActionButtonType.quarterCircle,
                            direction: SgFloatActionButtonDirection.right,
                            severity: SgFloatActionButtonSeverity.danger,
                          ),
                        )),
                      ],
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabQuarterCircle,
      ),
      ShowcaseExample(
        title: 'Active Icon',
        description:
            'Show a different icon when the menu is open',
        preview:
            // #region sg-fab-active-icon
            Builder(
              builder: (context) {
                final acoes = [
                  SgFABAction(
                    icon: const Icon(Icons.person_add),
                    label: context.tx('Novo usuário'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.note_add),
                    label: context.tx('Novo arquivo'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.create_new_folder),
                    label: context.tx('Nova pasta'),
                    onClick: () {},
                  ),
                ];
                Widget caixa(double altura, String legenda, Widget fab) => SizedBox(
                  height: altura,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12,
                          top: 8,
                          child: Text(legenda, style: Theme.of(context).textTheme.bodySmall),
                        ),
                        fab,
                      ],
                    ),
                  ),
                );
                return caixa(
                  288,
                  'activeIcon changes when open',
                  SgFloatActionButton(
                    absolute: true,
                    position: SgFloatActionButtonPosition.centerBottom,
                    actions: acoes,
                    type: SgFloatActionButtonType.semiCircle,
                    direction: SgFloatActionButtonDirection.up,
                    activeIcon: const Icon(Icons.settings),
                    severity: SgFloatActionButtonSeverity.secondary,
                  ),
                );
              },
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabActiveIcon,
      ),
      ShowcaseExample(
        title: 'Animações',
        description:
            'Diferentes tipos de animação: scale, fade, rotate, slide, pulse e none (disparadas ao passar o mouse).',
        preview:
            // #region sg-fab-animacoes
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                for (final animation in const [
                  SgFloatActionButtonAnimation.scale,
                  SgFloatActionButtonAnimation.fade,
                  SgFloatActionButtonAnimation.rotate,
                  SgFloatActionButtonAnimation.slide,
                  SgFloatActionButtonAnimation.pulse,
                  SgFloatActionButtonAnimation.none,
                ])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 88,
                        child: SgFloatActionButton(
                          absolute: true,
                          animation: animation,
                          animationOn: SgFloatActionButtonAnimationOn.hover,
                          icon: const Icon(Icons.favorite),
                          severity: SgFloatActionButtonSeverity.danger,
                          size: SgFloatActionButtonSize.sm,
                          onClick: () {},
                        ),
                      ),
                      Text(animation.value, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
              ],
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabAnimacoes,
      ),
      ShowcaseExample(
        title: 'Cor Customizada',
        description:
            'Use a prop color para definir uma cor personalizada (hex, rgb, hsl ou variável CSS).',
        preview:
            // #region sg-fab-cor
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                for (final (cor, icone) in const [
                  ('#8b5cf6', Icons.star),
                  ('#ec4899', Icons.favorite),
                  ('#f97316', Icons.settings),
                ])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 104,
                        child: SgFloatActionButton(
                          absolute: true,
                          color: cor,
                          icon: Icon(icone),
                          onClick: () {},
                        ),
                      ),
                      Text(cor, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
              ],
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabCor,
      ),
      ShowcaseExample(
        title: 'Loading e Desabilitado',
        description:
            'Estados loading e disabled.',
        preview:
            // #region sg-fab-loading-disabled
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 104,
                      child: SgFloatActionButton(
                        absolute: true,
                        enabled: false,
                        onClick: () {},
                      ),
                    ),
                    Text('disabled', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 104,
                      child: SgFloatActionButton(
                        absolute: true,
                        loading: true,
                        onClick: () {},
                      ),
                    ),
                    Text('loading', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabLoadingDisabled,
      ),
      ShowcaseExample(
        title: 'Arrastar e soltar',
        description:
            'Arraste o FAB para reposicionar. A posição fica salva no armazenamento local (dragId).',
        preview:
            // #region sg-fab-arrastar
            Builder(
              builder: (context) {
                final acoes = [
                  SgFABAction(
                    icon: const Icon(Icons.person_add),
                    label: context.tx('Novo usuário'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.note_add),
                    label: context.tx('Novo arquivo'),
                    onClick: () {},
                  ),
                  SgFABAction(
                    icon: const Icon(Icons.create_new_folder),
                    label: context.tx('Nova pasta'),
                    onClick: () {},
                  ),
                ];
                Widget caixa(double altura, String legenda, Widget fab) => SizedBox(
                  height: altura,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12,
                          top: 8,
                          child: Text(legenda, style: Theme.of(context).textTheme.bodySmall),
                        ),
                        fab,
                      ],
                    ),
                  ),
                );
                return caixa(
                  256,
                  '',
                  SgFloatActionButton(
                    absolute: true,
                    enableDragDrop: true,
                    dragId: 'showcase-fab-drag',
                    actions: acoes,
                    type: SgFloatActionButtonType.linear,
                    direction: SgFloatActionButtonDirection.up,
                    severity: SgFloatActionButtonSeverity.info,
                    position: SgFloatActionButtonPosition.rightBottom,
                  ),
                );
              },
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabArrastar,
      ),
    ];

    const playgroundProps = {
      'position',
      'severity',
      'size',
      'shape',
      'elevation',
      'animation',
      'animationOn',
      'loading',
      'enabled',
    };
    return SgShowcasePage(
      name: 'SgFloatActionButton',
      description:
          'Botão de ação flutuante para a tarefa de maior destaque, com hint, posição, arrastar e speed-dial de ações secundárias.',
      examples: examples,
      propSpecs: sgPropSpecs['SgFloatActionButton']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgFloatActionButton']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => _area(
          Stack(
            children: [
              SgFloatActionButton(
                key: ValueKey(
                  '${v['position']}|${v['animation']}|${v['animationOn']}',
                ),
                absolute: true,
                position:
                    SgFloatActionButtonPosition.fromValue(
                      v['position'] as String?,
                    ) ??
                    SgFloatActionButtonPosition.rightBottom,
                severity:
                    SgFloatActionButtonSeverity.fromValue(
                      v['severity'] as String?,
                    ) ??
                    SgFloatActionButtonSeverity.primary,
                size:
                    SgFloatActionButtonSize.fromValue(v['size'] as String?) ??
                    SgFloatActionButtonSize.md,
                shape:
                    SgFloatActionButtonShape.fromValue(v['shape'] as String?) ??
                    SgFloatActionButtonShape.circle,
                elevation:
                    SgFloatActionButtonElevation.fromValue(
                      v['elevation'] as String?,
                    ) ??
                    SgFloatActionButtonElevation.md,
                animation:
                    SgFloatActionButtonAnimation.fromValue(
                      v['animation'] as String?,
                    ) ??
                    SgFloatActionButtonAnimation.scale,
                animationOn:
                    SgFloatActionButtonAnimationOn.fromValue(
                      v['animationOn'] as String?,
                    ) ??
                    SgFloatActionButtonAnimationOn.mount,
                loading: (v['loading'] as bool?) ?? false,
                enabled: (v['enabled'] as bool?) ?? true,
              ),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>['absolute: true'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'position' =>
                'position: SgFloatActionButtonPosition.${SgFloatActionButtonPosition.fromValue(e.value as String)!.name}',
              'severity' =>
                'severity: SgFloatActionButtonSeverity.${SgFloatActionButtonSeverity.fromValue(e.value as String)!.name}',
              'size' =>
                'size: SgFloatActionButtonSize.${SgFloatActionButtonSize.fromValue(e.value as String)!.name}',
              'shape' =>
                'shape: SgFloatActionButtonShape.${SgFloatActionButtonShape.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgFloatActionButtonElevation.${SgFloatActionButtonElevation.fromValue(e.value as String)!.name}',
              'animation' =>
                'animation: SgFloatActionButtonAnimation.${SgFloatActionButtonAnimation.fromValue(e.value as String)!.name}',
              'animationOn' =>
                'animationOn: SgFloatActionButtonAnimationOn.${SgFloatActionButtonAnimationOn.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgFloatActionButton(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
