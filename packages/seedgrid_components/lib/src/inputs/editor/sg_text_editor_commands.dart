// Comandos da barra de ferramentas do SgTextEditor, com a mesma semantica dos comandos TipTap usados
// pelo React (toggleBold, setColor, toggleHighlight({color}), toggleHeading, toggleBulletList,
// sinkListItem/liftListItem, setTextAlign, setLink, setImage, unsetAllMarks().clearNodes()).
import 'dart:convert';

import 'package:flutter/widgets.dart' show TextSelection;
import 'package:flutter_quill/flutter_quill.dart';

import 'sg_text_editor_html.dart';

class SgTextEditorCommands {
  const SgTextEditorCommands._();

  static const _inlineKeys = [
    'bold',
    'italic',
    'underline',
    'strike',
    'script',
    'link',
    'color',
    'background',
    'font',
    'size',
    'code', //
  ];

  // ---- consulta
  static Attribute? _attr(QuillController c, String key) =>
      c.getSelectionStyle().attributes[key];

  /// `editor.isActive(...)` para marcas e atributos de linha.
  static const _blockKeys = {
    'header',
    'align',
    'list',
    'blockquote',
    'code-block',
    'indent',
  };

  /// `editor.isActive(...)` para marcas e atributos de linha (linha: todas as linhas da selecao).
  static bool isActive(QuillController c, String key, [Object? value]) {
    if (_blockKeys.contains(key)) {
      final lines = _selectedLines(c);
      return lines.isNotEmpty &&
          lines.every(
            (l) =>
                _lineAttr(l, key) != null &&
                (value == null || _lineAttr(l, key) == value),
          );
    }
    final a = _attr(c, key);
    if (a == null || a.value == null) return false;
    return value == null || a.value == value;
  }

  /// Nivel do titulo da linha (1 a 6) ou nulo.
  static int? heading(QuillController c) {
    final lines = _selectedLines(c);
    if (lines.isEmpty) return null;
    final v = _lineAttr(lines.first, 'header');
    return v is int ? v : null;
  }

  static String? linkHref(QuillController c) {
    final v = _attr(c, 'link')?.value;
    return v is String ? v : null;
  }

  // ---- linhas da selecao
  static List<Line> _allLines(QuillController c) {
    final out = <Line>[];
    for (final n in c.document.root.children) {
      if (n is Line) {
        out.add(n);
      } else if (n is Block) {
        out.addAll(n.children.whereType<Line>());
      }
    }
    return out;
  }

  static List<Line> _selectedLines(QuillController c) {
    final s = c.selection;
    return _allLines(c).where((l) {
      final off = l.documentOffset;
      final last = off + l.length - 1;
      return (s.isCollapsed ? s.start >= off : s.end > off) && s.start <= last;
    }).toList();
  }

  static Object? _lineAttr(Line l, String key) =>
      l.style.attributes[key]?.value;

  static void _formatLine(QuillController c, Line l, Attribute a) {
    c.document.format(l.documentOffset, 0, a);
  }

  static void _notify(QuillController c) =>
      c.updateSelection(c.selection, ChangeSource.local);

  // ---- marcas
  static void toggleInline(QuillController c, Attribute attr) {
    c.formatSelection(
      isActive(c, attr.key, attr.value) ? Attribute.clone(attr, null) : attr,
    );
  }

  static void toggleBold(QuillController c) => toggleInline(c, Attribute.bold);
  static void toggleItalic(QuillController c) =>
      toggleInline(c, Attribute.italic);
  static void toggleUnderline(QuillController c) =>
      toggleInline(c, Attribute.underline);
  static void toggleStrike(QuillController c) =>
      toggleInline(c, Attribute.strikeThrough);
  static void toggleSubscript(QuillController c) =>
      toggleInline(c, Attribute.subscript);
  static void toggleSuperscript(QuillController c) =>
      toggleInline(c, Attribute.superscript);

  static void setColor(QuillController c, String hex) =>
      c.formatSelection(ColorAttribute(hex));

  static void setFontFamily(QuillController c, String family) =>
      c.formatSelection(FontAttribute(family));

  /// [size] no formato do React: `16px`.
  static void setFontSize(QuillController c, String size) {
    final n = double.tryParse(size.replaceAll('px', ''));
    if (n == null) return;
    c.formatSelection(
      SizeAttribute(n == n.roundToDouble() ? '${n.round()}' : '$n'),
    );
  }

  /// `toggleHighlight({ color })`: mesma cor remove, cor diferente troca.
  static void toggleHighlight(QuillController c, String hex) {
    final cur = _attr(c, 'background')?.value;
    c.formatSelection(
      cur == hex
          ? Attribute.clone(Attribute.background, null)
          : BackgroundAttribute(hex),
    );
  }

  // ---- blocos
  /// `value`: `p`, `h1`, `h2` ou `h3` (o `<select>` do React).
  static void setHeading(QuillController c, String value) {
    final lines = _selectedLines(c);
    if (value == 'p') {
      for (final l in lines) {
        if (_lineAttr(l, 'header') != null) {
          _formatLine(c, l, Attribute.clone(Attribute.header, null));
        }
      }
      _notify(c);
      return;
    }
    final level = int.parse(value.substring(1));
    final all =
        lines.isNotEmpty && lines.every((l) => _lineAttr(l, 'header') == level);
    final offsets = lines.map((l) => l.documentOffset).toList();
    for (final off in offsets) {
      final l = c.document.queryChild(off).node;
      final line = l is Line
          ? l
          : (l as Block).children.whereType<Line>().first;
      if (all) {
        c.document.format(
          line.documentOffset,
          0,
          Attribute.clone(Attribute.header, null),
        );
        continue;
      }
      if (_lineAttr(line, 'list') != null) {
        c.document.format(off, 0, Attribute.clone(Attribute.list, null));
        c.document.format(off, 0, Attribute.clone(Attribute.indent, null));
      }
      c.document.format(off, 0, HeaderAttribute(level: level));
    }
    _notify(c);
  }

  /// `toggleBulletList` (`bullet`) e `toggleOrderedList` (`ordered`).
  static void toggleList(QuillController c, String type) {
    final lines = _selectedLines(c);
    final all =
        lines.isNotEmpty && lines.every((l) => _lineAttr(l, 'list') == type);
    final offsets = lines.map((l) => l.documentOffset).toList();
    for (final off in offsets) {
      if (all) {
        c.document.format(off, 0, Attribute.clone(Attribute.list, null));
        c.document.format(off, 0, Attribute.clone(Attribute.indent, null));
      } else {
        c.document.format(off, 0, Attribute.clone(Attribute.header, null));
        c.document.format(off, 0, ListAttribute(type));
      }
    }
    _notify(c);
  }

  static Line? _lineAt(QuillController c, int offset) {
    for (final l in _allLines(c)) {
      if (l.documentOffset == offset) return l;
    }
    return null;
  }

  /// `sinkListItem`: so aninha se o item anterior esta na lista no mesmo nivel ou mais fundo.
  static void indent(QuillController c) {
    final offsets = _selectedLines(c).map((l) => l.documentOffset).toList();
    for (final off in offsets) {
      final all = _allLines(c);
      final i = all.indexWhere((l) => l.documentOffset == off);
      if (i <= 0) continue;
      final l = all[i];
      if (_lineAttr(l, 'list') == null) continue;
      final prev = all[i - 1];
      if (_lineAttr(prev, 'list') == null) continue;
      final cur = (_lineAttr(l, 'indent') as int?) ?? 0;
      final p = (_lineAttr(prev, 'indent') as int?) ?? 0;
      if (p < cur) continue;
      c.document.format(off, 0, Attribute.getIndentLevel(cur + 1));
    }
    _notify(c);
  }

  /// `liftListItem`: sobe um nivel; no nivel 0 o item sai da lista e vira paragrafo.
  static void outdent(QuillController c) {
    final offsets = _selectedLines(c).map((l) => l.documentOffset).toList();
    for (final off in offsets) {
      final l = _lineAt(c, off);
      if (l == null || _lineAttr(l, 'list') == null) continue;
      final cur = (_lineAttr(l, 'indent') as int?) ?? 0;
      if (cur > 0) {
        c.document.format(
          off,
          0,
          cur == 1
              ? Attribute.clone(Attribute.indent, null)
              : Attribute.getIndentLevel(cur - 1),
        );
      } else {
        c.document.format(off, 0, Attribute.clone(Attribute.list, null));
      }
    }
    _notify(c);
  }

  /// `left`, `center`, `right` ou `justify`.
  static void setTextAlign(QuillController c, String value) {
    for (final off in _selectedLines(c).map((l) => l.documentOffset).toList()) {
      c.document.format(off, 0, AlignAttribute(value));
    }
    _notify(c);
  }

  // ---- link e imagem
  /// `setLink({ href })`: protocolo nao permitido nao faz nada (como o TipTap).
  static void setLink(QuillController c, String href) {
    if (!sgIsAllowedLinkUri(href)) return;
    c.formatSelection(LinkAttribute(href));
  }

  /// `unsetLink()`: com o cursor dentro de um link, remove o link inteiro.
  static void unsetLink(QuillController c) {
    final s = c.selection;
    final off = s.start;
    var len = s.end - s.start;
    var start = off;
    if (len == 0) {
      final seg = c.document.querySegmentLeafNode(off);
      final leaf =
          seg.leaf ??
          (off > 0 ? c.document.querySegmentLeafNode(off - 1).leaf : null);
      final href = leaf?.style.attributes['link']?.value;
      if (leaf == null || href == null) return;
      var first = leaf;
      var last = leaf;
      while (first.previous is Leaf &&
          (first.previous as Leaf).style.attributes['link']?.value == href) {
        first = first.previous! as Leaf;
      }
      while (last.next is Leaf &&
          (last.next as Leaf).style.attributes['link']?.value == href) {
        last = last.next! as Leaf;
      }
      start = first.documentOffset;
      len = last.documentOffset + last.length - start;
    }
    c.document.format(start, len, Attribute.clone(Attribute.link, null));
    _notify(c);
  }

  /// `setImage({ src })`: a imagem fica em linha propria (divide o paragrafo no cursor); troca a selecao.
  static void insertImage(QuillController c, String src) {
    final s = c.selection;
    if (s.end > s.start) c.replaceText(s.start, s.end - s.start, '', null);
    var p = s.start;
    final seg = c.document.querySegmentLeafNode(p);
    final line = seg.line;
    final lineOff = line!.documentOffset;
    final before = p > lineOff;
    final after = p < lineOff + line.length - 1;
    if (before) {
      c.replaceText(p, 0, '\n', null);
      p++;
    }
    c.replaceText(
      p,
      0,
      BlockEmbed(sgImageEmbed, jsonEncode({'src': src})),
      null,
    );
    p++;
    if (after) c.replaceText(p, 0, '\n', null);
    c.updateSelection(TextSelection.collapsed(offset: p), ChangeSource.local);
  }

  /// `unsetAllMarks().clearNodes()`.
  static void clearFormatting(QuillController c) {
    final s = c.selection;
    if (!s.isCollapsed) {
      for (final k in _inlineKeys) {
        c.document.format(
          s.start,
          s.end - s.start,
          Attribute.clone(_registered(k), null),
        );
      }
    } else {
      c.toggledStyle = const Style();
    }
    for (final l in _selectedLines(c).map((l) => l.documentOffset).toList()) {
      for (final a in <Attribute>[
        Attribute.header,
        Attribute.list,
        Attribute.blockQuote,
        Attribute.codeBlock,
        Attribute.align,
        Attribute.indent,
      ]) {
        final line = _lineAt(c, l);
        if (line != null && line.style.attributes.containsKey(a.key)) {
          c.document.format(l, 0, Attribute.clone(a, null));
        }
      }
    }
    _notify(c);
  }

  static Attribute _registered(String key) => switch (key) {
    'bold' => Attribute.bold,
    'italic' => Attribute.italic,
    'underline' => Attribute.underline,
    'strike' => Attribute.strikeThrough,
    'script' => Attribute.script,
    'link' => Attribute.link,
    'color' => Attribute.color,
    'background' => Attribute.background,
    'font' => Attribute.font,
    'size' => Attribute.size,
    _ => Attribute.inlineCode,
  };
}
