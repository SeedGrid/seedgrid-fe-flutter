// Conversor HTML <-> Delta do SgTextEditor.
//
// O React (TipTap) recebe e emite HTML (`editor.getHTML()`, so o corpo). O motor Dart (flutter_quill) fala
// Delta. Este arquivo le o HTML que o TipTap emite e escreve HTML que o TipTap le de volta igual.
// Regras de leitura copiadas do TipTap/ProseMirror: marcas aceitas (negrito, italico, sublinhado, tachado,
// codigo, sub/sobrescrito, destaque, link, estilo de span), colapso de espacos, texto solto vira paragrafo,
// link com protocolo nao permitido perde o link, imagem `data:` e descartada, tags desconhecidas sao
// transparentes e script/style/iframe somem. Ordem de aninhamento das marcas na saida = ordem do esquema
// do TipTap: link > estilo(span) > negrito > italico > tachado > sublinhado > destaque > sub > sup.
// O que o modelo Delta nao representa esta em docs/SG_TEXT_EDITOR_PoC.md ("Nao suportado").
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_quill/quill_delta.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as hp;

/// Tipo de embed (bloco) das imagens: o dado e um JSON `{"src","alt","title"}`.
const String sgImageEmbed = 'sgImage';

/// Tipo de embed (bloco) da regua horizontal (`<hr>`).
const String sgHrEmbed = 'sgHr';

/// Quebra de linha suave (`<br>`): U+2028 dentro do texto do paragrafo.
const String sgSoftBreak = ' ';

const _linkProtocols = {
  'http',
  'https',
  'ftp',
  'ftps',
  'mailto',
  'tel',
  'callto',
  'sms',
  'cid',
  'xmpp', //
};

/// `isAllowedUri` do TipTap Link: relativo ou protocolo permitido.
bool sgIsAllowedLinkUri(String? uri) {
  if (uri == null) return false;
  final u = uri.replaceAll(RegExp(r'[\u0000-   ᠎ -  　]'), '');
  if (u.isEmpty) return false;
  final m = RegExp(r'^([a-zA-Z][a-zA-Z0-9+.\-]*):').firstMatch(u);
  if (m == null) return true;
  return _linkProtocols.contains(m.group(1)!.toLowerCase());
}

const _ws = r'[ \t\r\n\f]';
final _wsRun = RegExp('$_ws+');
final _wsTrail = RegExp('$_ws+\$');
final _wsEndChar = RegExp('$_ws\$');

const _ignoredTags = {
  'head',
  'noscript',
  'object',
  'script',
  'style',
  'title',
  'iframe',
  'video',
  'audio', //
  'input', 'select', 'textarea', 'canvas', 'svg', 'template',
};
const _blockTags = {
  'address',
  'article',
  'aside',
  'blockquote',
  'canvas',
  'dd',
  'div',
  'dl',
  'fieldset',
  'figcaption', //
  'figure',
  'footer',
  'form',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'header',
  'hgroup',
  'hr',
  'li', //
  'noscript',
  'ol',
  'output',
  'p',
  'pre',
  'section',
  'table',
  'tfoot',
  'ul',
  'dt',
  'main',
  'nav',
  'details',
};
const _transparentBlocks = {
  'thead',
  'tbody',
  'tr',
  'td',
  'th',
  'caption',
  'colgroup',
  'summary',
};

const _colorNames = <String, String>{
  'black': '#000000',
  'white': '#ffffff',
  'red': '#ff0000',
  'lime': '#00ff00',
  'blue': '#0000ff', //
  'yellow': '#ffff00',
  'cyan': '#00ffff',
  'aqua': '#00ffff',
  'magenta': '#ff00ff',
  'fuchsia': '#ff00ff',
  'silver': '#c0c0c0',
  'gray': '#808080',
  'grey': '#808080',
  'maroon': '#800000',
  'olive': '#808000',
  'green': '#008000',
  'purple': '#800080',
  'teal': '#008080',
  'navy': '#000080',
  'orange': '#ffa500',
  'pink': '#ffc0cb',
  'brown': '#a52a2a',
  'gold': '#ffd700',
  'indigo': '#4b0082',
  'violet': '#ee82ee',
  'coral': '#ff7f50',
  'crimson': '#dc143c',
  'salmon': '#fa8072',
  'tomato': '#ff6347',
  'turquoise': '#40e0d0',
  'khaki': '#f0e68c',
  'lavender': '#e6e6fa',
  'beige': '#f5f5dc',
};

typedef _Rgba = ({int r, int g, int b, double a});

/// Cor CSS -> canais RGB e alfa (0 a 1), ou nulo. Aceita `#rgb`, `#rgba`, `#rrggbb`, `#rrggbbaa`, `rgb()`, `rgba()`,
/// `hsl()`, `hsla()` e nomes basicos.
_Rgba? _parseCssColor(String? value) {
  if (value == null) return null;
  final v = value.trim().toLowerCase();
  if (v.isEmpty) return null;
  _Rgba rgba(num r, num g, num b, [double a = 1]) => (
    r: r.round().clamp(0, 255),
    g: g.round().clamp(0, 255),
    b: b.round().clamp(0, 255),
    a: a.clamp(0.0, 1.0),
  );
  if (v.startsWith('#')) {
    final h = v.substring(1);
    if (!RegExp(r'^[0-9a-f]+$').hasMatch(h)) return null;
    var full = h;
    if (h.length == 3 || h.length == 4) {
      full = h.split('').map((c) => '$c$c').join();
    } else if (h.length != 6 && h.length != 8) {
      return null;
    }
    int ch(int i) => int.parse(full.substring(i * 2, i * 2 + 2), radix: 16);
    return rgba(ch(0), ch(1), ch(2), full.length == 8 ? ch(3) / 255 : 1);
  }
  final fn = RegExp(r'^(rgba?|hsla?)\(([^)]*)\)$').firstMatch(v);
  if (fn != null) {
    final parts = fn
        .group(2)!
        .split(RegExp(r'[,\s/]+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.length < 3) return null;
    double num(String s, double scale) {
      if (s.endsWith('%')) {
        return (double.tryParse(s.substring(0, s.length - 1)) ?? 0) /
            100 *
            scale;
      }
      return double.tryParse(s.replaceAll('deg', '')) ?? 0;
    }

    final alpha = parts.length > 3 ? num(parts[3], 1) : 1.0;
    if (fn.group(1)!.startsWith('rgb')) {
      return rgba(
        num(parts[0], 255),
        num(parts[1], 255),
        num(parts[2], 255),
        alpha,
      );
    }
    final h = (num(parts[0], 360) % 360 + 360) % 360;
    final sat =
        (parts[1].endsWith('%') ? num(parts[1], 1) : num(parts[1], 1) / 100)
            .clamp(0.0, 1.0);
    final lig =
        (parts[2].endsWith('%') ? num(parts[2], 1) : num(parts[2], 1) / 100)
            .clamp(0.0, 1.0);
    double f(int n) {
      final k = (n + h / 30) % 12;
      final a = sat * math.min(lig, 1 - lig);
      return lig - a * math.max(-1.0, math.min(math.min(k - 3, 9 - k), 1.0));
    }

    return rgba(f(0) * 255, f(8) * 255, f(4) * 255, alpha);
  }
  final named = _colorNames[v];
  return named == null ? null : _parseCssColor(named);
}

String _hex2(int c) => c.toRadixString(16).padLeft(2, '0');

/// Cor CSS -> `#rrggbb` (ou nulo). O canal alfa e descartado; para guardar o alfa use [sgCssColorToQuill].
String? sgCssColorToHex(String? value) {
  final c = _parseCssColor(value);
  return c == null ? null : '#${_hex2(c.r)}${_hex2(c.g)}${_hex2(c.b)}';
}

/// Cor CSS -> valor de cor do Delta: `#rrggbb` quando opaca e `rgba(r, g, b, a)` quando tem transparencia
/// (o flutter_quill le os dois formatos). Nulo se a cor for invalida.
String? sgCssColorToQuill(String? value) {
  final c = _parseCssColor(value);
  if (c == null) return null;
  final a = (c.a * 100).round() / 100;
  if (a >= 1) return '#${_hex2(c.r)}${_hex2(c.g)}${_hex2(c.b)}';
  final alpha = a == a.roundToDouble() ? '${a.round()}' : '$a';
  return 'rgba(${c.r}, ${c.g}, ${c.b}, $alpha)';
}

Map<String, String> _styleMap(String? style) {
  final out = <String, String>{};
  if (style == null) return out;
  for (final decl in style.split(';')) {
    final i = decl.indexOf(':');
    if (i < 0) continue;
    final k = decl.substring(0, i).trim().toLowerCase();
    var v = decl
        .substring(i + 1)
        .trim()
        .replaceAll(RegExp(r'\s*!important$'), '');
    if (k.isNotEmpty && v.isNotEmpty) out[k] = v;
  }
  return out;
}

String? _sizeToQuill(String? raw) {
  if (raw == null) return null;
  final m = RegExp(
    r'^([0-9]*\.?[0-9]+)\s*(px|pt|em|rem|%)?$',
  ).firstMatch(raw.trim().toLowerCase());
  if (m == null) return null;
  final n = double.parse(m.group(1)!);
  final px = switch (m.group(2)) {
    'pt' => n * 96 / 72,
    'em' || 'rem' => n * 16,
    '%' => n / 100 * 16,
    _ => n,
  };
  if (px <= 0) return null;
  final r = double.parse(px.toStringAsFixed(2));
  return r == r.roundToDouble() ? '${r.round()}' : '$r';
}

/// Guarda o texto original de uma cor/tamanho (ex.: `yellow`, `1.5em`) quando o valor do Delta o escreve diferente,
/// para o HTML de saida repetir o que o autor escreveu. So vale enquanto a conversao do original bater com o valor atual.
void _keepRaw(
  Map<String, Object?> attrs,
  String key,
  String? raw,
  String converted,
) {
  final r = raw?.trim();
  if (r == null || r.isEmpty || r == converted || r == '${converted}px') return;
  attrs[key] = r;
}

class _Seg {
  _Seg(this.text, this.attrs);
  String text;
  final Map<String, Object?> attrs;
}

class _Line {
  final List<_Seg> segs = [];
  Map<String, Object?> attrs = {};
  String? embedType;
  String? embedData;
}

/// Acumulador de conteudo inline de um bloco de texto (colapso de espacos do ProseMirror).
class _Run {
  final List<_Seg> segs = [];
  bool get isEmpty => segs.isEmpty;

  void addText(
    String raw,
    Map<String, Object?> attrs, {
    bool preserve = false,
  }) {
    var value = raw;
    if (!preserve) {
      value = value.replaceAll(_wsRun, ' ');
      if (value.startsWith(' ')) {
        final prev = segs.isEmpty ? null : segs.last;
        if (prev == null ||
            prev.text == sgSoftBreak ||
            _wsEndChar.hasMatch(prev.text)) {
          value = value.substring(1);
        }
      }
    }
    if (value.isEmpty) return;
    _push(value, attrs);
  }

  void addBreak(Map<String, Object?> attrs) => _push(sgSoftBreak, attrs);

  void _push(String text, Map<String, Object?> attrs) {
    final a = attrs.containsKey('code')
        ? <String, Object?>{'code': true}
        : Map<String, Object?>.of(attrs);
    segs.add(_Seg(text, a));
  }

  /// Remove o espaco final do bloco (ProseMirror `finish`).
  void trimEnd() {
    if (segs.isEmpty) return;
    final last = segs.last;
    if (last.text == sgSoftBreak) return;
    last.text = last.text.replaceAll(_wsTrail, '');
    if (last.text.isEmpty) segs.removeLast();
  }

  void clear() => segs.clear();
}

class _Ctx {
  const _Ctx({this.quote = false});
  final bool quote;
}

class _Parser {
  final List<_Line> lines = [];

  // ---- inline
  Map<String, Object?> _marksOf(
    dom.Element el,
    Map<String, Object?> inherited,
  ) {
    final attrs = Map<String, Object?>.of(inherited);
    final tag = el.localName ?? '';
    final style = _styleMap(el.attributes['style']);
    switch (tag) {
      case 'strong':
        attrs['bold'] = true;
      case 'b':
        if ((style['font-weight'] ?? '') != 'normal') attrs['bold'] = true;
      case 'em' || 'i':
        attrs['italic'] = true;
      case 'u':
        attrs['underline'] = true;
      case 's' || 'strike' || 'del':
        attrs['strike'] = true;
      case 'code':
        attrs['code'] = true;
      case 'sub':
        // o TipTap aceita sub e sup juntos (sai sempre `<sub><sup>`); o Delta so tem um `script`, o outro vai em `sg-sup`
        if (attrs['script'] == 'super') attrs['sg-sup'] = true;
        attrs['script'] = 'sub';
      case 'sup':
        if (attrs['script'] == 'sub') {
          attrs['sg-sup'] = true;
        } else {
          attrs['script'] = 'super';
        }
      case 'a':
        final href = el.attributes['href'];
        if (href != null && sgIsAllowedLinkUri(href)) attrs['link'] = href;
      case 'mark':
        final rawBg = sgCssColorToQuill(el.attributes['data-color']) != null
            ? el.attributes['data-color']
            : style['background-color'];
        final c = sgCssColorToQuill(rawBg);
        if (c != null) {
          attrs['background'] = c;
          _keepRaw(attrs, 'sg-bg-raw', rawBg, c);
        } else {
          // `<mark>` sem cor: o Delta precisa de um valor (amarelo padrao); `sg-mark` lembra que nao havia cor.
          attrs['background'] = '#ffff00';
          attrs['sg-mark'] = true;
        }
      case 'span':
        if (el.attributes.containsKey('style')) {
          final ff = style['font-family']
              ?.replaceAll(RegExp(r'''['"]+'''), '')
              .trim();
          if (ff != null && ff.isNotEmpty) attrs['font'] = ff;
          final col = sgCssColorToQuill(style['color']);
          if (col != null) {
            attrs['color'] = col;
            _keepRaw(attrs, 'sg-color-raw', style['color'], col);
          }
          final sz = _sizeToQuill(style['font-size']);
          if (sz != null) {
            attrs['size'] = sz;
            _keepRaw(attrs, 'sg-size-raw', style['font-size'], sz);
          }
        }
    }
    final fw = style['font-weight'];
    if (fw != null && RegExp(r'^(bold(er)?|[5-9]\d\d)$').hasMatch(fw)) {
      attrs['bold'] = true;
    }
    if ((style['font-style'] ?? '') == 'italic') attrs['italic'] = true;
    final td = style['text-decoration'] ?? style['text-decoration-line'] ?? '';
    if (td.contains('underline')) attrs['underline'] = true;
    if (td.contains('line-through')) attrs['strike'] = true;
    return attrs;
  }

  /// Percorre filhos inline. [onImage] trata `<img>` (que quebra o paragrafo).
  void _inline(
    dom.Node n,
    _Run run,
    Map<String, Object?> attrs,
    void Function(dom.Element) onImage, {
    bool preserve = false,
  }) {
    if (n is dom.Text) {
      run.addText(n.text, attrs, preserve: preserve);
    } else if (n is dom.Element) {
      final tag = n.localName ?? '';
      if (_ignoredTags.contains(tag)) return;
      if (tag == 'br') {
        run.addBreak(attrs);
        return;
      }
      if (tag == 'img') {
        onImage(n);
        return;
      }
      final next = _marksOf(n, attrs);
      for (final c in n.nodes) {
        _inline(c, run, next, onImage, preserve: preserve);
      }
    }
  }

  String? _align(dom.Element el) {
    final v = _styleMap(el.attributes['style'])['text-align'];
    return const {'left', 'right', 'center', 'justify'}.contains(v) ? v : null;
  }

  void _emitRun(_Run run, Map<String, Object?> lineAttrs) {
    run.trimEnd();
    final l = _Line()..attrs = Map.of(lineAttrs);
    for (final s in run.segs) {
      l.segs.add(s);
    }
    lines.add(l);
    run.clear();
  }

  void _image(dom.Element el) {
    final src = el.attributes['src'];
    if (src == null || src.isEmpty || src.toLowerCase().startsWith('data:')) {
      return;
    }
    final data = <String, String>{'src': src};
    final alt = el.attributes['alt'];
    final title = el.attributes['title'];
    if (alt != null) data['alt'] = alt;
    if (title != null) data['title'] = title;
    lines.add(
      _Line()
        ..embedType = sgImageEmbed
        ..embedData = jsonEncode(data),
    );
  }

  // ---- blocos
  void blocks(List<dom.Node> nodes, _Ctx ctx) {
    final loose = _Run();
    var looseImage = false;
    Map<String, Object?> quoteAttrs() => ctx.quote ? {'blockquote': true} : {};
    void flush() {
      if (!loose.isEmpty || looseImage) {
        if (!loose.isEmpty) {
          // espaco so em branco entre blocos nao gera paragrafo
          final onlyWs = loose.segs.every(
            (s) => s.text.trim().isEmpty && s.text != sgSoftBreak,
          );
          if (!onlyWs) _emitRun(loose, quoteAttrs());
        }
      }
      loose.clear();
      looseImage = false;
    }

    void looseImg(dom.Element e) {
      if (!loose.isEmpty) flush();
      looseImage = true;
      _image(e);
    }

    for (final n in nodes) {
      if (n is dom.Text) {
        if (loose.isEmpty && n.text.trim().isEmpty) continue;
        loose.addText(n.text, {});
      } else if (n is dom.Element) {
        final tag = n.localName ?? '';
        if (_ignoredTags.contains(tag)) continue;
        if (tag == 'img') {
          looseImg(n);
        } else if (tag == 'ul' || tag == 'ol') {
          flush();
          _list(n, 0, ctx);
        } else if (tag == 'blockquote') {
          flush();
          blocks(n.nodes, const _Ctx(quote: true));
        } else if (tag == 'pre') {
          flush();
          _code(n);
        } else if (tag == 'hr') {
          flush();
          lines.add(
            _Line()
              ..embedType = sgHrEmbed
              ..embedData = '',
          );
        } else if (tag == 'p' || RegExp(r'^h[1-6]$').hasMatch(tag)) {
          flush();
          _textblock(n, ctx);
        } else if (_blockTags.contains(tag) ||
            _transparentBlocks.contains(tag)) {
          flush();
          blocks(n.nodes, ctx);
        } else {
          _inline(n, loose, {}, looseImg);
        }
      }
    }
    flush();
  }

  void _textblock(dom.Element el, _Ctx ctx) {
    final tag = el.localName!;
    final attrs = <String, Object?>{};
    if (ctx.quote) {
      attrs['blockquote'] = true;
    } else if (tag != 'p') {
      attrs['header'] = int.parse(tag.substring(1));
    }
    final al = _align(el);
    if (al != null) attrs['align'] = al;
    final run = _Run();
    var emittedImage = false;
    final base = _marksOf(el, {});
    for (final c in el.nodes) {
      _inline(c, run, base, (img) {
        if (!run.isEmpty) _emitRun(run, attrs);
        _image(img);
        emittedImage = true;
      });
    }
    if (run.isEmpty && emittedImage) return;
    _emitRun(run, attrs);
  }

  void _code(dom.Element pre) {
    var text = pre.text;
    if (text.endsWith('\n') && text.length > 1) {
      text = text.substring(0, text.length - 1);
    }
    final cls = pre.querySelector('code')?.className ?? '';
    final lang = RegExp(r'(?:^|\s)language-(\S+)').firstMatch(cls)?.group(1);
    for (final part in text.split('\n')) {
      final l = _Line()
        ..attrs = {'code-block': true, if (lang != null) 'sg-lang': lang};
      if (part.isNotEmpty) l.segs.add(_Seg(part, {}));
      lines.add(l);
    }
  }

  void _list(dom.Element list, int indent, _Ctx ctx) {
    final ordered = list.localName == 'ol';
    final start = ordered ? int.tryParse(list.attributes['start'] ?? '') : null;
    var first = true;
    for (final li in list.nodes.whereType<dom.Element>()) {
      if (li.localName != 'li') continue;
      _listItem(li, ordered, indent, ctx, first ? start : null);
      first = false;
    }
  }

  void _listItem(
    dom.Element li,
    bool ordered,
    int indent,
    _Ctx ctx, [
    int? start,
  ]) {
    final attrs = <String, Object?>{'list': ordered ? 'ordered' : 'bullet'};
    if (indent > 0) attrs['indent'] = indent;
    // `<ol start="3">`: o numero inicial fica na primeira linha da lista (o TipTap omite quando e 1)
    if (start != null && start != 1) attrs['sg-start'] = start;
    final item = _Run();
    var emitted = false;
    String? align;
    void emit() {
      final a = Map<String, Object?>.of(attrs);
      if (align != null) a['align'] = align;
      _emitRun(item, a);
      attrs.remove('sg-start');
      emitted = true;
    }

    void softJoin() {
      if (!item.isEmpty) item.addBreak({});
    }

    for (final n in li.nodes) {
      if (n is dom.Element) {
        final tag = n.localName ?? '';
        if (_ignoredTags.contains(tag)) continue;
        if (tag == 'ul' || tag == 'ol') {
          if (!emitted) emit();
          _list(n, indent + 1, ctx);
          continue;
        }
        if (tag == 'p' || RegExp(r'^h[1-6]$').hasMatch(tag)) {
          if (emitted) {
            emitted = false;
            align = null;
          }
          align ??= _align(n);
          softJoin();
          final base = _marksOf(n, {});
          for (final c in n.nodes) {
            _inline(c, item, base, (_) {});
          }
          continue;
        }
        if (_blockTags.contains(tag)) {
          softJoin();
          for (final c in n.nodes) {
            _inline(c, item, {}, (_) {});
          }
          continue;
        }
      }
      if (emitted && (n is! dom.Text || n.text.trim().isNotEmpty)) {
        emitted = false;
      }
      _inline(n, item, {}, (_) {});
    }
    if (!emitted) emit();
  }
}

/// Conversao entre o HTML do SgTextEditor (corpo, como `editor.getHTML()`) e Delta.
class SgTextEditorHtml {
  const SgTextEditorHtml._();

  /// HTML do corpo -> Delta (sempre termina em `\n`).
  static Delta toDelta(String html) {
    final frag = hp.parseFragment(html);
    final p = _Parser()..blocks(frag.nodes, const _Ctx());
    if (p.lines.isEmpty) p.lines.add(_Line());
    final d = Delta();
    for (final l in p.lines) {
      if (l.embedType != null) {
        d.insert(<String, Object?>{l.embedType!: l.embedData});
        d.insert('\n');
        continue;
      }
      for (final s in l.segs) {
        d.insert(s.text, s.attrs.isEmpty ? null : s.attrs);
      }
      d.insert('\n', l.attrs.isEmpty ? null : l.attrs);
    }
    return d;
  }

  /// Delta -> HTML do corpo no formato do TipTap.
  static String fromDelta(Delta delta) => _Writer().write(_linesOf(delta));

  /// `parseHtmlDocument` do React: `<style>` do `<head>` e `body.innerHTML`.
  static ({String cssText, String bodyHtml}) parseDocument(String html) {
    final doc = hp.parse(html);
    final css = doc
        .querySelectorAll('head style')
        .map((s) => s.text)
        .join('\n')
        .trim();
    return (cssText: css, bodyHtml: (doc.body?.innerHtml ?? '').trim());
  }

  /// `buildFullHtmlDocument` do React.
  static String buildDocument(String bodyHtml, String cssText, String lang) {
    final css = cssText.trim();
    return '<!doctype html>\n<html lang="$lang">\n<head>\n  <meta charset="utf-8" />\n'
        '  <meta name="viewport" content="width=device-width,initial-scale=1" />\n'
        '  ${css.isNotEmpty ? '<style>\n$css\n</style>' : ''}\n</head>\n<body>\n$bodyHtml\n</body>\n</html>';
  }
}

List<_Line> _linesOf(Delta delta) {
  final out = <_Line>[];
  var cur = _Line();
  for (final op in delta.toList()) {
    final data = op.data;
    final attrs = op.attributes ?? const <String, Object?>{};
    if (data is String) {
      var start = 0;
      while (true) {
        final i = data.indexOf('\n', start);
        final piece = data.substring(start, i < 0 ? data.length : i);
        if (piece.isNotEmpty) cur.segs.add(_Seg(piece, Map.of(attrs)));
        if (i < 0) break;
        cur.attrs = Map.of(attrs);
        out.add(cur);
        cur = _Line();
        start = i + 1;
      }
    } else if (data is Map) {
      final key = data.keys.first as String;
      final value = data[key];
      if (key == sgImageEmbed || key == sgHrEmbed) {
        cur.embedType = key;
        cur.embedData = '$value';
      } else if (key == 'image') {
        cur.embedType = sgImageEmbed;
        cur.embedData = jsonEncode({'src': '$value'});
      } else if (key == 'divider') {
        cur.embedType = sgHrEmbed;
        cur.embedData = '';
      }
    }
  }
  if (cur.segs.isNotEmpty || cur.embedType != null) out.add(cur);
  return out;
}

String _escText(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll(' ', '&nbsp;');
String _escAttr(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('"', '&quot;')
    .replaceAll(' ', '&nbsp;');

class _Mark {
  _Mark(this.sig, this.open, this.close);
  final String sig;
  final String open;
  final String close;
}

List<_Mark> _marksFor(Map<String, Object?> a) {
  if (a['code'] == true) return [_Mark('code', '<code>', '</code>')];
  final out = <_Mark>[];
  final link = a['link'];
  if (link is String && link.isNotEmpty) {
    out.add(
      _Mark(
        'link:$link',
        '<a target="_blank" rel="noopener noreferrer nofollow" href="${_escAttr(link)}">',
        '</a>',
      ),
    );
  }
  final font = a['font'] is String && (a['font'] as String).isNotEmpty
      ? a['font'] as String
      : null;
  var color = a['color'] is String && (a['color'] as String).isNotEmpty
      ? a['color'] as String
      : null;
  final colorRaw = a['sg-color-raw'];
  if (color != null &&
      colorRaw is String &&
      sgCssColorToQuill(colorRaw) == color) {
    color = colorRaw;
  }
  String? size;
  final rawSize = a['size'];
  final sizeRaw = a['sg-size-raw'];
  if (rawSize != null &&
      sizeRaw is String &&
      _sizeToQuill(sizeRaw) == '$rawSize') {
    size = sizeRaw;
  } else if (rawSize != null) {
    size = switch ('$rawSize') {
      'small' => '10px',
      'large' => '18px',
      'huge' => '32px',
      'normal' || '' => null,
      final s => double.tryParse(s) != null ? '${s}px' : s,
    };
  }
  if (font != null || color != null || size != null) {
    final parts = [
      if (font != null) 'font-family: $font',
      if (color != null) 'color: $color',
      if (size != null) 'font-size: $size',
    ];
    out.add(
      _Mark(
        'ts:$font|$color|$size',
        '<span style="${_escAttr(parts.join('; '))}">',
        '</span>',
      ),
    );
  }
  if (a['bold'] == true) out.add(_Mark('b', '<strong>', '</strong>'));
  if (a['italic'] == true) out.add(_Mark('i', '<em>', '</em>'));
  if (a['strike'] == true) out.add(_Mark('s', '<s>', '</s>'));
  if (a['underline'] == true) out.add(_Mark('u', '<u>', '</u>'));
  var bg = a['background'];
  if (bg is String && bg.isNotEmpty) {
    final bgRaw = a['sg-bg-raw'];
    if (bgRaw is String && sgCssColorToQuill(bgRaw) == bg) bg = bgRaw;
    if (a['sg-mark'] == true && bg == '#ffff00') {
      out.add(_Mark('hl:', '<mark>', '</mark>'));
    } else {
      out.add(
        _Mark(
          'hl:$bg',
          '<mark data-color="${_escAttr(bg)}" style="background-color: ${_escAttr(bg)}; color: inherit">',
          '</mark>',
        ),
      );
    }
  }
  if (a['script'] == 'sub') {
    out.add(_Mark('sub', '<sub>', '</sub>'));
    if (a['sg-sup'] == true) out.add(_Mark('sup', '<sup>', '</sup>'));
  }
  if (a['script'] == 'super') out.add(_Mark('sup', '<sup>', '</sup>'));
  return out;
}

class _Writer {
  final StringBuffer out = StringBuffer();

  String inline(List<_Seg> segs) {
    final b = StringBuffer();
    final active = <_Mark>[];
    for (final s in segs) {
      final marks = _marksFor(s.attrs);
      var keep = 0;
      while (keep < active.length &&
          keep < marks.length &&
          active[keep].sig == marks[keep].sig) {
        keep++;
      }
      while (active.length > keep) {
        b.write(active.removeLast().close);
      }
      for (var i = keep; i < marks.length; i++) {
        b.write(marks[i].open);
        active.add(marks[i]);
      }
      final parts = s.text.split(sgSoftBreak);
      for (var i = 0; i < parts.length; i++) {
        if (i > 0) b.write('<br>');
        b.write(_escText(parts[i]));
      }
    }
    while (active.isNotEmpty) {
      b.write(active.removeLast().close);
    }
    return b.toString();
  }

  String _alignAttr(Map<String, Object?> a) {
    final v = a['align'];
    return const {'left', 'right', 'center', 'justify'}.contains(v)
        ? ' style="text-align: $v"'
        : '';
  }

  String write(List<_Line> lines) {
    if (lines.isEmpty) return '<p></p>';
    var i = 0;
    while (i < lines.length) {
      final l = lines[i];
      if (l.embedType == sgHrEmbed) {
        out.write('<hr>');
        i++;
      } else if (l.embedType == sgImageEmbed) {
        out.write(_img(l.embedData ?? ''));
        i++;
      } else if (l.attrs['code-block'] == true) {
        final txt = <String>[];
        while (i < lines.length &&
            lines[i].attrs['code-block'] == true &&
            lines[i].embedType == null) {
          txt.add(
            lines[i].segs
                .map((s) => s.text.replaceAll(sgSoftBreak, '\n'))
                .join(),
          );
          i++;
        }
        final lang = l.attrs['sg-lang'];
        final cls = lang is String && lang.isNotEmpty
            ? ' class="language-${_escAttr(lang)}"'
            : '';
        out.write('<pre><code$cls>${_escText(txt.join('\n'))}</code></pre>');
      } else if (l.attrs['blockquote'] == true) {
        out.write('<blockquote>');
        while (i < lines.length &&
            lines[i].attrs['blockquote'] == true &&
            lines[i].embedType == null) {
          out.write(
            '<p${_alignAttr(lines[i].attrs)}>${inline(lines[i].segs)}</p>',
          );
          i++;
        }
        out.write('</blockquote>');
      } else if (l.attrs['list'] != null) {
        i = _list(lines, i);
      } else {
        final h = l.attrs['header'];
        final tag = h is int && h >= 1 && h <= 6 ? 'h$h' : 'p';
        out.write('<$tag${_alignAttr(l.attrs)}>${inline(l.segs)}</$tag>');
        i++;
      }
    }
    return out.toString();
  }

  String _img(String json) {
    try {
      final m = jsonDecode(json) as Map;
      final b = StringBuffer('<img src="${_escAttr('${m['src'] ?? ''}')}"');
      if (m['alt'] != null) b.write(' alt="${_escAttr('${m['alt']}')}"');
      if (m['title'] != null) b.write(' title="${_escAttr('${m['title']}')}"');
      b.write('>');
      return b.toString();
    } catch (_) {
      return '';
    }
  }

  int _list(List<_Line> lines, int start) {
    final stack = <String>[];
    var i = start;
    while (i < lines.length &&
        lines[i].attrs['list'] != null &&
        lines[i].embedType == null) {
      final l = lines[i];
      final tag = l.attrs['list'] == 'ordered' ? 'ol' : 'ul';
      final rawIndent = l.attrs['indent'];
      var d = rawIndent is int ? rawIndent : 0;
      if (d < 0) d = 0;
      if (d > stack.length) d = stack.length;
      while (stack.length > d + 1) {
        out.write('</li></${stack.removeLast()}>');
      }
      final startAttr = tag == 'ol' && l.attrs['sg-start'] is num
          ? ' start="${(l.attrs['sg-start'] as num).toInt()}"'
          : '';
      if (stack.length == d + 1) {
        if (stack.last != tag) {
          out.write('</li></${stack.removeLast()}>');
          out.write('<$tag$startAttr><li>');
          stack.add(tag);
        } else {
          out.write('</li><li>');
        }
      } else {
        out.write('<$tag$startAttr><li>');
        stack.add(tag);
      }
      out.write('<p${_alignAttr(l.attrs)}>${inline(l.segs)}</p>');
      i++;
    }
    while (stack.isNotEmpty) {
      out.write('</li></${stack.removeLast()}>');
    }
    return i;
  }
}
