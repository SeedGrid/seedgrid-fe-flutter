// Unidades de espaco do layout. No React `gap`, `padding`, `width`... aceitam `number | string`
// (`number` = px; `string` = qualquer valor CSS). Aqui os mesmos nomes aceitam `num` (px) ou texto
// 'Npx', 'Nrem'/'Nem' (1 = 16 px) e numero puro em texto. Outras unidades CSS (calc(), vh, vw...)
// nao tem equivalente e sao ignoradas (valor nulo).

/// `number | string` do React -> logical pixels. `null` quando nao ha valor ou a unidade nao e suportada.
double? sgSpace(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) {
    final s = v.trim().toLowerCase();
    if (s.isEmpty) return null;
    final m = RegExp(r'^(-?\d+(?:\.\d+)?)\s*(px|rem|em)?$').firstMatch(s);
    if (m == null) return null;
    final n = double.parse(m.group(1)!);
    return switch (m.group(2)) {
      'rem' || 'em' => n * 16,
      _ => n,
    };
  }
  return null;
}

/// `SgDockPercent` do React (`number | "N%"`, ambos significam porcentagem) -> N. `null` se invalido.
double? sgPercent(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) {
    final m = RegExp(r'^\s*(-?\d+(?:\.\d+)?)\s*%?\s*$').firstMatch(v);
    if (m != null) return double.parse(m.group(1)!);
  }
  return null;
}

/// Largura/altura estilo `toCssSize`: numero = px, 'N%' = fracao do espaco disponivel, 'Npx'/'Nrem' = px.
/// Devolve o tamanho em px dado o espaco [available] (se 'N%' e [available] for finito) ou `null`.
double? sgSize(Object? v, double available) {
  if (v is String && v.trim().endsWith('%')) {
    final p = sgPercent(v);
    if (p == null || !available.isFinite) return null;
    return available * p / 100;
  }
  return sgSpace(v);
}
