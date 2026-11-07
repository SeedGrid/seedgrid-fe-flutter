// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_float_action_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgFloatActionButtonPageSnippets {
  /// Region `sg-fab-active-icon`.
  static const String sgFabActiveIcon = r'''
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
    Widget caixa(double altura, String legenda, Widget fab) =>
        SizedBox(
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
                  child: Text(
                    legenda,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
)
''';

  /// Region `sg-fab-animacoes`.
  static const String sgFabAnimacoes = r'''
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
          Text(
            animation.value,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
  ],
)
''';

  /// Region `sg-fab-arrastar`.
  static const String sgFabArrastar = r'''
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
    Widget caixa(double altura, String legenda, Widget fab) =>
        SizedBox(
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
                  child: Text(
                    legenda,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
)
''';

  /// Region `sg-fab-circle`.
  static const String sgFabCircle = r'''
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
    Widget caixa(double altura, String legenda, Widget fab) =>
        SizedBox(
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
                  child: Text(
                    legenda,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
)
''';

  /// Region `sg-fab-cor`.
  static const String sgFabCor = r'''
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
)
''';

  /// Region `sg-fab-dica`.
  static const String sgFabDica = r'''
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
)
''';

  /// Region `sg-fab-elevacao`.
  static const String sgFabElevacao = r'''
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
          Text(
            elevation.value,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
  ],
)
''';

  /// Region `sg-fab-formas-tamanhos`.
  static const String sgFabFormasTamanhos = r'''
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
          Text(
            shape.value,
            style: Theme.of(context).textTheme.labelMedium,
          ),
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
)
''';

  /// Region `sg-fab-loading-disabled`.
  static const String sgFabLoadingDisabled = r'''
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
        Text(
          'disabled',
          style: Theme.of(context).textTheme.bodySmall,
        ),
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
        Text(
          'loading',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-fab-posicoes`.
  static const String sgFabPosicoes = r'''
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
)
''';

  /// Region `sg-fab-quarter-circle`.
  static const String sgFabQuarterCircle = r'''
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
      for (final a in acoes)
        SgFABAction(icon: a.icon, onClick: a.onClick),
    ];
    Widget caixa(double altura, String legenda, Widget fab) =>
        SizedBox(
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
                  child: Text(
                    legenda,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
            Expanded(
              child: caixa(
                256,
                'type="quarter-circle" direction="up"',
                SgFloatActionButton(
                  absolute: true,
                  position:
                      SgFloatActionButtonPosition.centerBottom,
                  actions: acoes,
                  type: SgFloatActionButtonType.quarterCircle,
                  direction: SgFloatActionButtonDirection.up,
                  severity: SgFloatActionButtonSeverity.secondary,
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: caixa(
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
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: caixa(
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
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: caixa(
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
              ),
            ),
          ],
        ),
      ],
    );
  },
)
''';

  /// Region `sg-fab-semi-circle`.
  static const String sgFabSemiCircle = r'''
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
      for (final a in acoes)
        SgFABAction(icon: a.icon, onClick: a.onClick),
    ];
    Widget caixa(double altura, String legenda, Widget fab) =>
        SizedBox(
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
                  child: Text(
                    legenda,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
            Expanded(
              child: caixa(
                288,
                'type="semi-circle" direction="up"',
                SgFloatActionButton(
                  absolute: true,
                  position:
                      SgFloatActionButtonPosition.centerBottom,
                  actions: acoesExtras,
                  type: SgFloatActionButtonType.semiCircle,
                  direction: SgFloatActionButtonDirection.up,
                  severity: SgFloatActionButtonSeverity.success,
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: caixa(
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
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: caixa(
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
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: caixa(
                192,
                'type="semi-circle" direction="right"',
                SgFloatActionButton(
                  absolute: true,
                  position: SgFloatActionButtonPosition.leftCenter,
                  actions: acoesSemRotulo,
                  type: SgFloatActionButtonType.semiCircle,
                  direction: SgFloatActionButtonDirection.right,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  },
)
''';

  /// Region `sg-fab-severidades`.
  static const String sgFabSeveridades = r'''
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
          Text(
            severity.value,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
  ],
)
''';

  /// Region `sg-fab-speed-dial`.
  static const String sgFabSpeedDial = r'''
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
      for (final a in acoes)
        SgFABAction(icon: a.icon, onClick: a.onClick),
    ];
    Widget caixa(double altura, String legenda, Widget fab) =>
        SizedBox(
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
                  child: Text(
                    legenda,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
            Expanded(
              child: caixa(
                288,
                'type="linear" direction="up"',
                SgFloatActionButton(
                  absolute: true,
                  position:
                      SgFloatActionButtonPosition.centerBottom,
                  actions: acoes,
                  type: SgFloatActionButtonType.linear,
                  direction: SgFloatActionButtonDirection.up,
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: caixa(
                288,
                'type="linear" direction="down"',
                SgFloatActionButton(
                  absolute: true,
                  position: SgFloatActionButtonPosition.centerTop,
                  actions: acoes,
                  type: SgFloatActionButtonType.linear,
                  direction: SgFloatActionButtonDirection.down,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: caixa(
                96,
                'type="linear" direction="left"',
                SgFloatActionButton(
                  absolute: true,
                  position: SgFloatActionButtonPosition.rightCenter,
                  actions: acoesSemRotulo,
                  type: SgFloatActionButtonType.linear,
                  direction: SgFloatActionButtonDirection.left,
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: caixa(
                96,
                'type="linear" direction="right"',
                SgFloatActionButton(
                  absolute: true,
                  position: SgFloatActionButtonPosition.leftCenter,
                  actions: acoesSemRotulo,
                  type: SgFloatActionButtonType.linear,
                  direction: SgFloatActionButtonDirection.right,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  },
)
''';
}
