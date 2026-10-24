// Pintura compartilhada dos digitos: sombra externa (brilho) e sombra interna ao estilo do CSS.
// No CSS o raio de desfoque B vale um desvio-padrao de B / 2; e o que `MaskFilter.blur` espera.
import 'dart:ui';

/// `box-shadow: dx dy blur spread color` (sombra externa): desenha [rrect] deslocado e dilatado, desfocado.
void paintOuterShadow(
  Canvas canvas,
  RRect rrect, {
  required double blur,
  required Color color,
  Offset offset = Offset.zero,
  double spread = 0,
}) {
  if (color.a == 0) return;
  final shape = rrect.shift(offset).inflate(spread);
  final paint = Paint()..color = color;
  if (blur > 0) paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2);
  canvas.drawRRect(shape, paint);
}

/// `box-shadow: inset dx dy blur spread color`: preenche o que fica FORA do [rrect] (encolhido pelo
/// [spread] e deslocado), desfocado, recortado ao proprio [rrect].
void paintInsetShadow(
  Canvas canvas,
  RRect rrect, {
  required double blur,
  required Color color,
  Offset offset = Offset.zero,
  double spread = 0,
}) {
  if (color.a == 0) return;
  canvas.save();
  canvas.clipRRect(rrect);
  final hole = rrect.shift(offset).deflate(spread);
  final path = Path()
    ..fillType = PathFillType.evenOdd
    ..addRect(
      rrect.outerRect.inflate(blur + spread.abs() + offset.distance + 4),
    )
    ..addRRect(hole);
  final paint = Paint()..color = color;
  if (blur > 0) paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2);
  canvas.drawPath(path, paint);
  canvas.restore();
}

/// Mesma cor com o alfa multiplicado por [factor] (0..1).
Color scaleAlpha(Color c, double factor) =>
    c.withValues(alpha: (c.a * factor).clamp(0.0, 1.0));
