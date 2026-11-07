// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_string_animator_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgStringAnimatorPageSnippets {
  /// Region `sg-string-animator-auto-start`.
  static const String sgStringAnimatorAutoStart = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      const names = [
        'LUCIANO',
        'MARTA',
        'PEDRO',
        'ANA',
        'SEEDGRID',
      ];
      var idx = 0;
      return StatefulBuilder(
        builder: (context, set) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SgStringAnimator(
              sourceString:
                  names[(idx - 1 + names.length) % names.length],
              targetString: names[idx],
              stringAnimatorStyle:
                  SgStringAnimatorStringAnimatorStyle.roller3d,
              alignTo: SgStringAnimatorAlignTo.left,
              fontSize: 28,
              autoStart: true,
              velocity: 60,
            ),
            const SizedBox(height: 16),
            SgButton(
              size: SgSize.sm,
              label: Text(context.tx('Próximo nome')),
              onClick: () =>
                  set(() => idx = (idx + 1) % names.length),
            ),
          ],
        ),
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-discard`.
  static const String sgStringAnimatorDiscard = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final animRef = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: 'LUCIANO',
            targetString: 'MARTA',
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.discard,
            alignTo: SgStringAnimatorAlignTo.left,
            fontSize: 28,
            controller: animRef,
          ),
          const SizedBox(height: 16),
          SgButton(
            size: SgSize.sm,
            label: Text(context.tx('Animar')),
            onClick: animRef.startAnimation,
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-fade`.
  static const String sgStringAnimatorFade = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final animRef = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: 'LUCIANO',
            targetString: 'MARTA',
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.fade,
            alignTo: SgStringAnimatorAlignTo.left,
            fontSize: 28,
            controller: animRef,
          ),
          const SizedBox(height: 16),
          SgButton(
            size: SgSize.sm,
            label: Text(context.tx('Animar')),
            onClick: animRef.startAnimation,
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-flip`.
  static const String sgStringAnimatorFlip = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final animRef = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: 'LUCIANO',
            targetString: 'MARTA',
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.flip,
            alignTo: SgStringAnimatorAlignTo.left,
            fontSize: 28,
            controller: animRef,
          ),
          const SizedBox(height: 16),
          SgButton(
            size: SgSize.sm,
            label: Text(context.tx('Animar')),
            onClick: animRef.startAnimation,
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-matrix`.
  static const String sgStringAnimatorMatrix = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final animRef = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: 'LUCIANO',
            targetString: 'MARTA',
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.matrix,
            alignTo: SgStringAnimatorAlignTo.left,
            color: '#22d3ee',
            backgroundColor: '#0b1220',
            controller: animRef,
          ),
          const SizedBox(height: 16),
          SgButton(
            size: SgSize.sm,
            label: Text(context.tx('Animar')),
            onClick: animRef.startAnimation,
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-neon`.
  static const String sgStringAnimatorNeon = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final animRef = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: 'LUCIANO',
            targetString: 'MARTA',
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.neon,
            alignTo: SgStringAnimatorAlignTo.left,
            fontSize: 28,
            color: '#e4fbff',
            backgroundColor: '#090f22',
            controller: animRef,
          ),
          const SizedBox(height: 16),
          SgButton(
            size: SgSize.sm,
            label: Text(context.tx('Animar')),
            onClick: animRef.startAnimation,
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-roller-nomes`.
  static const String sgStringAnimatorRollerNomes = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final animRef = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: 'LUCIANO',
            targetString: 'MARTA',
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.roller3d,
            alignTo: SgStringAnimatorAlignTo.left,
            fontSize: 28,
            controller: animRef,
          ),
          const SizedBox(height: 16),
          SgButton(
            size: SgSize.sm,
            label: Text(context.tx('Animar')),
            onClick: animRef.startAnimation,
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-roller-numeros`.
  static const String sgStringAnimatorRollerNumeros = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final animRef = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: '42',
            targetString: '1337',
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.roller3d,
            alignTo: SgStringAnimatorAlignTo.right,
            fontSize: 28,
            controller: animRef,
          ),
          const SizedBox(height: 16),
          SgButton(
            size: SgSize.sm,
            label: Text(context.tx('Animar')),
            onClick: animRef.startAnimation,
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-velocidades`.
  static const String sgStringAnimatorVelocidades = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final casos = [
        (context.tx('Lento (velocity=10)'), 10),
        (context.tx('Médio (velocity=50)'), 50),
        (context.tx('Rápido (velocity=90)'), 90),
      ];
      final refs = [
        for (final _ in casos) SgStringAnimatorController(),
      ];
      return SgGrid(
        columns: const {'base': 1, 'md': 3},
        gap: 24,
        children: [
          for (var i = 0; i < casos.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  casos[i].$1,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                SgStringAnimator(
                  sourceString: 'ORIGEM',
                  targetString: 'DESTINO',
                  stringAnimatorStyle:
                      SgStringAnimatorStringAnimatorStyle.roller3d,
                  alignTo: SgStringAnimatorAlignTo.left,
                  fontSize: 22,
                  velocity: casos[i].$2,
                  controller: refs[i],
                ),
                const SizedBox(height: 8),
                SgButton(
                  size: SgSize.sm,
                  label: Text(context.tx('Animar')),
                  onClick: refs[i].startAnimation,
                ),
              ],
            ),
        ],
      );
    },
  ),
)
''';
}
