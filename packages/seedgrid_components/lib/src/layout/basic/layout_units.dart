// Unidades de espaco do layout. No React `gap`, `padding`, `width`... aceitam `number | string`
// (`number` = px; `string` = qualquer valor CSS). Aqui os mesmos nomes aceitam `num` (px) ou texto CSS:
// 'Npx', 'Nrem'/'Nem' (1 = 16 px), 'Nvh'/'Nvw'/'Nvmin'/'Nvmax' (e as variantes d/s/l), 'N%' (precisa de
// `available`), `calc()`, `min()`, `max()`, `clamp()` e numero puro em texto. Unidade desconhecida = nulo.
import 'dart:math' as math;
import 'dart:ui' show Size;

/// `number | string` do React -> logical pixels. `null` quando nao ha valor ou a unidade nao e suportada.
/// [viewport] resolve `vh`/`vw`/`vmin`/`vmax`; [available] resolve `%` (sem ele, `%` e nulo).
double? sgSpace(Object? v, {Size? viewport, double? available}) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) {
    final s = v.trim().toLowerCase();
    if (s.isEmpty) return null;
    return _CssLength(s, viewport, available).parse();
  }
  return null;
}

/// Avaliador de comprimento CSS: numero com unidade, parenteses, `+ - * /`, `calc()`, `min()`, `max()`,
/// `clamp()`. Tudo em px; numero sem unidade dentro de uma expressao vale como px.
class _CssLength {
  _CssLength(this.src, this.viewport, this.available);

  final String src;
  final Size? viewport;
  final double? available;
  int _i = 0;
  bool _bad = false;

  double? parse() {
    final v = _expr();
    _skip();
    if (_bad || _i != src.length || v == null || !v.isFinite) return null;
    return v;
  }

  void _skip() {
    while (_i < src.length && src[_i] == ' ') {
      _i++;
    }
  }

  double? _expr() {
    var v = _term();
    while (!_bad) {
      _skip();
      if (_i >= src.length) break;
      final c = src[_i];
      if (c != '+' && c != '-') break;
      _i++;
      final r = _term();
      if (v == null || r == null) {
        _bad = true;
        return null;
      }
      v = c == '+' ? v + r : v - r;
    }
    return v;
  }

  double? _term() {
    var v = _factor();
    while (!_bad) {
      _skip();
      if (_i >= src.length) break;
      final c = src[_i];
      if (c != '*' && c != '/') break;
      _i++;
      final r = _factor();
      if (v == null || r == null) {
        _bad = true;
        return null;
      }
      v = c == '*' ? v * r : v / r;
    }
    return v;
  }

  double? _factor() {
    _skip();
    if (_i >= src.length) {
      _bad = true;
      return null;
    }
    final c = src[_i];
    if (c == '(') {
      _i++;
      final v = _expr();
      return _close(v);
    }
    final fn = RegExp(r'^(calc|min|max|clamp)\(').firstMatch(src.substring(_i));
    if (fn != null) {
      _i += fn.end;
      final args = <double>[];
      while (!_bad) {
        final v = _expr();
        if (v == null) {
          _bad = true;
          return null;
        }
        args.add(v);
        _skip();
        if (_i < src.length && src[_i] == ',') {
          _i++;
          continue;
        }
        break;
      }
      final ok = _close(0) != null;
      if (!ok || args.isEmpty) {
        _bad = true;
        return null;
      }
      return switch (fn.group(1)) {
        'min' => args.reduce(math.min),
        'max' => args.reduce(math.max),
        'clamp' =>
          args.length == 3
              ? math.max(args[0], math.min(args[1], args[2]))
              : null,
        _ => args.first,
      };
    }
    final m = RegExp(
      r'^([+-]?(?:\d+(?:\.\d*)?|\.\d+))(px|rem|em|%|d?v[hw]|[sl]v[hw]|d?vmin|d?vmax|svmin|svmax|lvmin|lvmax|pt)?',
    ).firstMatch(src.substring(_i));
    if (m == null) {
      _bad = true;
      return null;
    }
    _i += m.end;
    final n = double.parse(m.group(1)!);
    final unit = m.group(2);
    final vp = viewport;
    double? need(double? base) {
      if (base == null) _bad = true;
      return base == null ? null : n * base / 100;
    }

    return switch (unit) {
      null || 'px' => n,
      'rem' || 'em' => n * 16,
      'pt' => n * 4 / 3,
      '%' => need(available),
      _ when unit.endsWith('vh') => need(vp?.height),
      _ when unit.endsWith('vw') => need(vp?.width),
      _ when unit.endsWith('vmin') => need(
        vp == null ? null : math.min(vp.width, vp.height),
      ),
      _ => need(vp == null ? null : math.max(vp.width, vp.height)),
    };
  }

  double? _close(double? v) {
    _skip();
    if (v == null || _i >= src.length || src[_i] != ')') {
      _bad = true;
      return null;
    }
    _i++;
    return v;
  }
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

/// Largura/altura estilo `toCssSize`: numero = px, 'N%' = fracao do espaco disponivel, 'Npx'/'Nrem'/`calc()`/`vh`...
/// = px. Devolve o tamanho em px dado o espaco [available] (se 'N%' e [available] for finito) ou `null`.
double? sgSize(Object? v, double available, {Size? viewport}) {
  if (v is String && v.trim().endsWith('%') && !v.contains('(')) {
    final p = sgPercent(v);
    if (p == null || !available.isFinite) return null;
    return available * p / 100;
  }
  return sgSpace(
    v,
    viewport: viewport,
    available: available.isFinite ? available : null,
  );
}
