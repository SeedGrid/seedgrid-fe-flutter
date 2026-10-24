// Porte de SgRoller3DDigit (React: src/digits/roller3d-digit/SgRoller3DDigit.tsx): um tambor vertical que
// desliza ate a posicao de `value` em `items`. Mesmas medidas (derivadas de fontSize), mesma curva
// cubic-bezier(0.22, 1, 0.36, 1), mesma duracao (transitionMs, 500) e mesmas cores por token.
// Atencao (defeito do React, mantido): a mascara do tambor e um gradiente sobre o tambor INTEIRO
// (transparente 0-22%, preto 22-78%, transparente 78-100%) e se move junto com ele; por isso, com 10 itens,
// os digitos perto das pontas (0, 1, 8, 9) aparecem esmaecidos mesmo no centro.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../generated/sg_roller3_d_digit.g.dart';
import '../../theme_access.dart';
import 'digits_support.dart';

const List<String> kRollerDefaultItems = [
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
];

/// Medidas do roller: iguais as do React (`Math.round` do JS arredonda .5 para cima).
class SgRollerMetrics {
  SgRollerMetrics(double fontSize, List<String> items, String value) {
    index = math.max(0, items.indexOf(value));
    final charCount = math.max(
      items.fold<int>(1, (m, s) => math.max(m, s.length)),
      1,
    );
    itemH = _round(fontSize * 1.2);
    width = _round(fontSize * (0.7 * charCount + 0.7));
    height = _round(fontSize * 2.7);
    translateY = -index * itemH + height / 2 - itemH / 2;
  }

  late final int index;
  late final double itemH;
  late final double width;
  late final double height;

  /// Deslocamento do tambor em px para o item `index` ficar no centro.
  late final double translateY;

  static double _round(double v) => (v + 0.5).floorToDouble();
}

class SgRoller3DDigit extends StatelessWidget implements SgRoller3DDigitProps {
  const SgRoller3DDigit({
    super.key,
    required this.value,
    this.items = kRollerDefaultItems,
    this.fontSize = 32,
    this.transitionMs = 500,
  });

  /// Valor atual; precisa estar em [items] (senao fica no primeiro).
  @override
  final String value;

  /// Todos os valores possiveis, em ordem.
  @override
  final List<String> items;

  /// Tamanho da fonte em px; define a escala do conjunto.
  @override
  final num fontSize;

  /// Duracao da transicao em ms.
  @override
  final num transitionMs;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final fs = fontSize.toDouble();
    final m = SgRollerMetrics(fs, items, value);

    final surface = digitToken(t, ['--sg-surface', '--sg-bg']);
    final border = digitToken(t, ['--sg-border']);
    final activeText = digitToken(t, ['--sg-text', '--sg-fg']);
    final mutedText = digitToken(t, ['--sg-muted', '--sg-fg']);

    const radius = BorderRadius.all(Radius.circular(16)); // rounded-2xl

    Widget drum = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++)
          SizedBox(
            key: ValueKey('roller-item-$i'),
            height: m.itemH,
            child: Center(
              child: Text(
                items[i],
                softWrap: false,
                style: TextStyle(
                  fontSize: fs,
                  height: 1,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: i == m.index ? activeText : mutedText,
                ),
              ),
            ),
          ),
      ],
    );

    // mask-image: linear-gradient(to bottom, transparent, black 22%, black 78%, transparent) no tambor inteiro.
    drum = ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x00000000),
          Color(0xFF000000),
          Color(0xFF000000),
          Color(0x00000000),
        ],
        stops: [0, 0.22, 0.78, 1],
      ).createShader(rect),
      child: drum,
    );

    return Container(
      key: const ValueKey('roller-root'),
      width: m.width,
      height: m.height,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: radius,
        boxShadow: [
          // ring-1 ring-border/70
          BoxShadow(color: border.withValues(alpha: 0.7), spreadRadius: 1),
          // shadow externa: 0 8px 28px rgba(0,0,0,.12)
          const BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, 8),
            blurRadius: 28,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Tambor: translateY animado (sem transicao no primeiro quadro, como no React).
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                key: const ValueKey('roller-drum'),
                tween: Tween<double>(end: m.translateY),
                duration: Duration(milliseconds: transitionMs.round()),
                curve: kRollerCurve,
                child: drum,
                builder: (context, dy, child) => OverflowBox(
                  alignment: Alignment.topCenter,
                  minHeight: 0,
                  maxHeight: double.infinity,
                  child: Transform.translate(
                    offset: Offset(0, dy),
                    child: child,
                  ),
                ),
              ),
            ),
            // Sombra interna: inset 0 0 28px rgba(0,0,0,.08)
            const IgnorePointer(
              child: CustomPaint(painter: _InnerShadowPainter(radius: 16)),
            ),
            // before: degrade de cima (black/6% -> transparente)
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x0F000000), Color(0x00000000)],
                  ),
                ),
              ),
            ),
            // after: degrade de baixo (black/12% -> transparente)
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0x1F000000), Color(0x00000000)],
                  ),
                ),
              ),
            ),
            // linha central: h-px bg-red-500/70 em top-1/2
            Positioned(
              left: 0,
              right: 0,
              top: m.height / 2,
              height: 1,
              child: const ColoredBox(
                key: ValueKey('roller-selector'),
                color: Color(0xB3EF4444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sombra interna (`inset 0 0 28px rgba(0,0,0,.08)`): o Flutter nao tem inset shadow.
class _InnerShadowPainter extends CustomPainter {
  const _InnerShadowPainter({required this.radius});
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.save();
    canvas.clipRRect(rrect);
    final outer = Path()
      ..addRect(rect.inflate(60))
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      outer,
      Paint()
        ..color = const Color(0x14000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InnerShadowPainter old) => old.radius != radius;
}
