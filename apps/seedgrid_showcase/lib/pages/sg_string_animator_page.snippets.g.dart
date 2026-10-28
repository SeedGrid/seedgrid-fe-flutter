// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_string_animator_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgStringAnimatorPageSnippets {
  /// Region `sg-string-animator-auto`.
  static const String sgStringAnimatorAuto = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      var target = 'LUCIANO';
      return StatefulBuilder(
        builder: (context, set) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SgStringAnimator(
              sourceString: 'LUCIANO',
              targetString: target,
              stringAnimatorStyle:
                  SgStringAnimatorStringAnimatorStyle.flip,
              autoStart: true,
              velocity: 70,
              fontSize: 28,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final nome in const ['MARTA', 'JOAO', 'ANA'])
                  OutlinedButton(
                    onPressed: () => set(() => target = nome),
                    child: Text(nome),
                  ),
              ],
            ),
          ],
        ),
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-direita`.
  static const String sgStringAnimatorDireita = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final controller = SgStringAnimatorController();
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SgStringAnimator(
            sourceString: '7',
            targetString: '2048',
            alignTo: SgStringAnimatorAlignTo.right,
            emptyChar: '0',
            charset: const [
              '0',
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
              '9',
            ],
            velocity: 90,
            controller: controller,
          ),
          const SizedBox(width: 24),
          FilledButton(
            onPressed: controller.startAnimation,
            child: Text(context.tx('Contar')),
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-estilos`.
  static const String sgStringAnimatorEstilos = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final controller = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final estilo in const [
            SgStringAnimatorStringAnimatorStyle.fade,
            SgStringAnimatorStringAnimatorStyle.matrix,
            SgStringAnimatorStringAnimatorStyle.neon,
            SgStringAnimatorStringAnimatorStyle.discard,
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SgStringAnimator(
                sourceString: 'HELLO',
                targetString: 'WORLD',
                stringAnimatorStyle: estilo,
                fontSize: 24,
                controller: controller,
              ),
            ),
          FilledButton(
            onPressed: controller.startAnimation,
            child: Text(context.tx('Animar')),
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-manual`.
  static const String sgStringAnimatorManual = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final controller = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: 'LUCIANO',
            targetString: 'MARTA',
            controller: controller,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: controller.startAnimation,
            child: Text(context.tx('Animar')),
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-string-animator-velocidade`.
  static const String sgStringAnimatorVelocidade = r'''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Builder(
    builder: (context) {
      final lento = SgStringAnimatorController();
      final rapido = SgStringAnimatorController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgStringAnimator(
            sourceString: 'ABCDEFG',
            targetString: 'XY',
            emptyChar: '.',
            velocity: 10,
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.flip,
            fontSize: 22,
            controller: lento,
          ),
          const SizedBox(height: 12),
          SgStringAnimator(
            sourceString: 'ABCDEFG',
            targetString: 'XY',
            emptyChar: '.',
            velocity: 100,
            stringAnimatorStyle:
                SgStringAnimatorStringAnimatorStyle.flip,
            fontSize: 22,
            controller: rapido,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              lento.startAnimation();
              rapido.startAnimation();
            },
            child: Text(context.tx('Animar os dois')),
          ),
        ],
      );
    },
  ),
)
''';
}
