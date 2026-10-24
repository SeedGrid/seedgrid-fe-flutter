// Logica pura do SgNeonDigit (React: src/digits/neon-digit/SgNeonDigit.tsx): raios do brilho, camadas de
// sombra do texto e do contorno, e a duracao de cada fase. Conferida contra o React por vetores.
import 'dart:math' as math;
import 'dart:ui';

/// Camada de sombra: `0 0 {blur}px {color}`; [inset] = sombra interna do contorno.
class NeonShadow {
  const NeonShadow({
    required this.blur,
    required this.color,
    this.inset = false,
  });
  final double blur;
  final Color color;
  final bool inset;
}

class NeonMetrics {
  const NeonMetrics({
    required this.inner,
    required this.near,
    required this.mid,
    required this.outer,
    required this.ambient,
    required this.halfDuration,
  });

  final int inner;
  final int near;
  final int mid;
  final int outer;
  final int ambient;

  /// Duracao (ms) de cada fase da troca de valor: `max(40, round(transitionMs / 2))`.
  final int halfDuration;
}

/// Raios do brilho, proporcionais a [fontSize] e a [shadowStrength] (minimo 0,2).
NeonMetrics neonMetrics({
  num fontSize = 46,
  num shadowStrength = 1,
  num transitionMs = 320,
}) {
  final glowFactor = math.max(0.2, shadowStrength);
  int r(num v) => v.round();
  return NeonMetrics(
    inner: math.max(1, r(fontSize * 0.07 * glowFactor)),
    near: math.max(3, r(fontSize * 0.2 * glowFactor)),
    mid: math.max(6, r(fontSize * 0.42 * glowFactor)),
    outer: math.max(12, r(fontSize * 0.78 * glowFactor)),
    ambient: math.max(18, r(fontSize * 1.2 * glowFactor)),
    halfDuration: math.max(40, r(transitionMs / 2)),
  );
}

const Color _white = Color(0xFFFFFFFF);
// rgba(0, 0, 0, 0.24), com o alfa fracionario do CSS (nao 61/255), igual a interpretacao do texto da cor
final Color _innerDark = const Color.from(
  alpha: 0.24,
  red: 0,
  green: 0,
  blue: 0,
);

/// Sombras do texto: acesas (5 camadas) ou apagadas (1 camada fraca).
List<NeonShadow> neonTextShadows(
  NeonMetrics m, {
  required Color color,
  required Color glow,
  required bool lit,
}) {
  if (!lit) {
    return [
      NeonShadow(
        blur: math.max(1, (m.inner * 0.5).round()).toDouble(),
        color: glow,
      ),
    ];
  }
  return [
    NeonShadow(blur: m.inner.toDouble(), color: _white),
    NeonShadow(blur: m.near.toDouble(), color: color),
    NeonShadow(blur: m.mid.toDouble(), color: glow),
    NeonShadow(blur: m.outer.toDouble(), color: glow),
    NeonShadow(blur: m.ambient.toDouble(), color: glow),
  ];
}

/// Sombras do contorno: uma interna escura e duas externas coloridas (ou a versao apagada, de duas camadas).
List<NeonShadow> neonContainerShadows(
  NeonMetrics m, {
  required Color glow,
  required bool lit,
}) {
  final a = m.ambient;
  if (!lit) {
    return [
      NeonShadow(
        blur: (a * 0.4).round().toDouble(),
        color: _innerDark,
        inset: true,
      ),
      NeonShadow(blur: (a * 0.22).round().toDouble(), color: glow),
    ];
  }
  return [
    NeonShadow(
      blur: (a * 0.6).round().toDouble(),
      color: _innerDark,
      inset: true,
    ),
    NeonShadow(blur: (a * 0.7).round().toDouble(), color: glow),
    NeonShadow(blur: (a * 1.35).round().toDouble(), color: glow),
  ];
}

/// Interpola duas listas de sombras como o CSS: par a par, e a lista mais curta e completada com sombras
/// transparentes de raio 0. [t] = 0 devolve [dim]; 1 devolve [lit].
List<NeonShadow> lerpNeonShadows(
  List<NeonShadow> dim,
  List<NeonShadow> lit,
  double t,
) {
  final n = math.max(dim.length, lit.length);
  NeonShadow at(List<NeonShadow> list, int i, List<NeonShadow> other) =>
      i < list.length
      ? list[i]
      : NeonShadow(
          blur: 0,
          color: const Color(0x00000000),
          inset: other[i].inset,
        );
  return [
    for (var i = 0; i < n; i++)
      () {
        final a = at(dim, i, lit);
        final b = at(lit, i, dim);
        return NeonShadow(
          blur: a.blur + (b.blur - a.blur) * t,
          color: Color.lerp(a.color, b.color, t)!,
          inset: b.inset,
        );
      }(),
  ];
}
