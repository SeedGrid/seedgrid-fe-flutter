// Porte de sgDocking.tsx (React): o modelo de encaixe `align` top / left / bottom / right / client
// e o fluxo do conteudo (`renderDockContent`). E a base de SgPanel e SgScreen.
//
// Estrutura (igual ao React, com `gap`): uma coluna com os itens `top`, uma linha central e os itens
// `bottom`. A linha central tem os itens `left`, uma area central e os itens `right`. A area central
// divide o espaco, em partes iguais, entre os itens `client` e o conteudo solto (filhos que nao sao
// itens de encaixe). Sem nenhum item de encaixe, so existe o conteudo solto, em fluxo flex.
//
// Diferenca do React: la o item de encaixe e um `SgPanel` com a prop `align`. Em Dart nao da para
// inspecionar as props de um widget qualquer; por isso o item declara `SgDockable` (o SgPanel deve
// implementa-lo) ou e embrulhado em [SgDockItem].
import 'package:flutter/widgets.dart';

/// `SgDockAlign` do React.
enum SgDockAlign {
  top('top'),
  left('left'),
  bottom('bottom'),
  right('right'),
  client('client');

  const SgDockAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgDockAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// `SgDockContentDirection` do React.
enum SgDockContentDirection {
  row('row'),
  column('column');

  const SgDockContentDirection(this.value);
  final String value;

  static SgDockContentDirection? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// `SgDockContentJustify` do React.
enum SgDockContentJustify {
  start('start'),
  center('center'),
  end('end'),
  between('between'),
  around('around'),
  evenly('evenly');

  const SgDockContentJustify(this.value);
  final String value;

  static SgDockContentJustify? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// `SgDockContentAlign` do React.
enum SgDockContentAlign {
  start('start'),
  center('center'),
  end('end'),
  stretch('stretch');

  const SgDockContentAlign(this.value);
  final String value;

  static SgDockContentAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// `getDefaultContentDirection`.
SgDockContentDirection getDefaultContentDirection(SgDockAlign? align) =>
    align == SgDockAlign.top || align == SgDockAlign.bottom
    ? SgDockContentDirection.row
    : SgDockContentDirection.column;

/// `getDefaultContentAlign`.
SgDockContentAlign getDefaultContentAlign(SgDockAlign? align) =>
    align == SgDockAlign.top || align == SgDockAlign.bottom
    ? SgDockContentAlign.start
    : SgDockContentAlign.stretch;

/// `getDefaultContentGap`.
double getDefaultContentGap() => 10;

/// `toCssSpace` em pixels logicos: numero = px; texto aceita `12`, `12px`, `1rem` e `1em` (16 px).
/// Qualquer outra coisa (`calc()`, `%`) vira `null`, como se a prop nao existisse.
double? toSpacePx(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is! String) return null;
  final m = RegExp(
    r'^\s*(-?\d+(?:\.\d+)?)\s*(px|rem|em)?\s*$',
  ).firstMatch(value);
  if (m == null) return null;
  final n = double.parse(m.group(1)!);
  return switch (m.group(2)) {
    'rem' || 'em' => n * 16,
    _ => n,
  };
}

/// Medida de encaixe: numero ou `'N%'` (`SgDockPercent`). `isPercent` = fracao do container.
/// Texto `'Npx'` tambem e aceito (o React o repassa ao CSS como esta), valendo pixels.
typedef SgDockSize = ({double value, bool isPercent});

/// `toCssPercent`: numero e texto `'N%'` sao porcentagem; `'Npx'` e pixel; o resto e `null`.
SgDockSize? toDockSize(Object? value) {
  if (value == null) return null;
  if (value is num) return (value: value.toDouble(), isPercent: true);
  if (value is! String) return null;
  final m = RegExp(r'^\s*(-?\d+(?:\.\d+)?)\s*(%|px)\s*$').firstMatch(value);
  if (m == null) return null;
  return (value: double.parse(m.group(1)!), isPercent: m.group(2) == '%');
}

/// Item de encaixe (equivale a um `SgPanel` com `align` no React).
abstract interface class SgDockable {
  SgDockAlign? get dockAlign;

  /// Numero, `'N%'` ou `'Npx'`.
  Object? get dockWidth;
  Object? get dockHeight;
  num? get dockMinWidthPx;
  num? get dockMinHeightPx;
}

/// Embrulha qualquer widget como item de encaixe.
class SgDockItem extends StatelessWidget implements SgDockable {
  const SgDockItem({
    super.key,
    required this.align,
    required this.child,
    this.width,
    this.height,
    this.minWidthPx,
    this.minHeightPx,
  });

  final SgDockAlign align;
  final Widget child;
  final Object? width;
  final Object? height;
  final num? minWidthPx;
  final num? minHeightPx;

  @override
  SgDockAlign? get dockAlign => align;
  @override
  Object? get dockWidth => width;
  @override
  Object? get dockHeight => height;
  @override
  num? get dockMinWidthPx => minWidthPx;
  @override
  num? get dockMinHeightPx => minHeightPx;

  @override
  Widget build(BuildContext context) => child;
}

MainAxisAlignment _mainAxis(SgDockContentJustify j) => switch (j) {
  SgDockContentJustify.start => MainAxisAlignment.start,
  SgDockContentJustify.center => MainAxisAlignment.center,
  SgDockContentJustify.end => MainAxisAlignment.end,
  SgDockContentJustify.between => MainAxisAlignment.spaceBetween,
  SgDockContentJustify.around => MainAxisAlignment.spaceAround,
  SgDockContentJustify.evenly => MainAxisAlignment.spaceEvenly,
};

WrapAlignment _wrapAlignment(SgDockContentJustify j) => switch (j) {
  SgDockContentJustify.start => WrapAlignment.start,
  SgDockContentJustify.center => WrapAlignment.center,
  SgDockContentJustify.end => WrapAlignment.end,
  SgDockContentJustify.between => WrapAlignment.spaceBetween,
  SgDockContentJustify.around => WrapAlignment.spaceAround,
  SgDockContentJustify.evenly => WrapAlignment.spaceEvenly,
};

CrossAxisAlignment _crossAxis(SgDockContentAlign a) => switch (a) {
  SgDockContentAlign.start => CrossAxisAlignment.start,
  SgDockContentAlign.center => CrossAxisAlignment.center,
  SgDockContentAlign.end => CrossAxisAlignment.end,
  SgDockContentAlign.stretch => CrossAxisAlignment.stretch,
};

/// `renderDockContent` do React.
class SgDockContent extends StatelessWidget {
  const SgDockContent({
    super.key,
    required this.children,
    this.align,
    this.contentDirection,
    this.contentGap,
    this.contentJustify,
    this.contentAlign,
    this.contentWrap,
  });

  final List<Widget> children;

  /// `align` do container (so define os padroes de direcao e alinhamento do conteudo).
  final SgDockAlign? align;
  final SgDockContentDirection? contentDirection;

  /// Numero (px) ou texto (`'12px'`, `'1rem'`). Padrao 10.
  final Object? contentGap;
  final SgDockContentJustify? contentJustify;
  final SgDockContentAlign? contentAlign;
  final bool? contentWrap;

  bool _isDock(Widget w) =>
      w is SgDockable && (w as SgDockable).dockAlign != null;

  @override
  Widget build(BuildContext context) {
    final direction = contentDirection ?? getDefaultContentDirection(align);
    final gap = toSpacePx(contentGap) ?? getDefaultContentGap();
    final justify = contentJustify ?? SgDockContentJustify.start;
    final cAlign = contentAlign ?? getDefaultContentAlign(align);
    final wrap = contentWrap ?? false;

    final dock = <Widget>[];
    final loose = <Widget>[];
    for (final c in children) {
      (_isDock(c) ? dock : loose).add(c);
    }

    Widget flow(List<Widget> items) {
      if (wrap) {
        return Wrap(
          key: const ValueKey('sg-dock-conteudo'),
          direction: direction == SgDockContentDirection.row
              ? Axis.horizontal
              : Axis.vertical,
          alignment: _wrapAlignment(justify),
          // Wrap nao tem 'stretch': cai em 'start'.
          crossAxisAlignment: switch (cAlign) {
            SgDockContentAlign.center => WrapCrossAlignment.center,
            SgDockContentAlign.end => WrapCrossAlignment.end,
            _ => WrapCrossAlignment.start,
          },
          spacing: gap,
          runSpacing: gap,
          children: items,
        );
      }
      return Flex(
        key: const ValueKey('sg-dock-conteudo'),
        direction: direction == SgDockContentDirection.row
            ? Axis.horizontal
            : Axis.vertical,
        mainAxisAlignment: _mainAxis(justify),
        crossAxisAlignment: _crossAxis(cAlign),
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0 && gap > 0)
              SizedBox(
                width: direction == SgDockContentDirection.row ? gap : 0,
                height: direction == SgDockContentDirection.column ? gap : 0,
              ),
            items[i],
          ],
        ],
      );
    }

    if (dock.isEmpty) return flow(loose);

    SgDockable d(Widget w) => w as SgDockable;
    List<Widget> byAlign(SgDockAlign a) =>
        dock.where((w) => d(w).dockAlign == a).toList();

    return LayoutBuilder(
      builder: (context, c) {
        // `flex-basis: N%` e fracao do container; com eixo sem limite o CSS resolve como `auto`.
        double? px(SgDockSize? s, double available) {
          if (s == null) return null;
          if (!s.isPercent) return s.value;
          if (!available.isFinite) return null;
          return available * s.value / 100;
        }

        Widget top(Widget w) {
          final item = d(w);
          final h = px(toDockSize(item.dockHeight), c.maxHeight);
          final minH = item.dockMinHeightPx?.toDouble();
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: minH ?? 0),
            child: h == null ? w : SizedBox(height: h, child: w),
          );
        }

        Widget side(Widget w) {
          final item = d(w);
          final wd = px(toDockSize(item.dockWidth), c.maxWidth);
          final minW = item.dockMinWidthPx?.toDouble();
          return ConstrainedBox(
            constraints: BoxConstraints(minWidth: minW ?? 0),
            child: wd == null ? w : SizedBox(width: wd, child: w),
          );
        }

        Widget sep(bool vertical) =>
            vertical ? SizedBox(height: gap) : SizedBox(width: gap);

        // Linha central: left..., [client... + conteudo solto], right...
        final center = <Widget>[
          for (final w in byAlign(SgDockAlign.client)) Expanded(child: w),
          if (loose.isNotEmpty) Expanded(child: flow(loose)),
        ];
        Widget centerRow = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < center.length; i++) ...[
              if (i > 0 && gap > 0) sep(false),
              center[i],
            ],
          ],
        );

        final middleItems = <Widget>[
          for (final w in byAlign(SgDockAlign.left)) side(w),
          Expanded(child: centerRow),
          for (final w in byAlign(SgDockAlign.right)) side(w),
        ];
        Widget middleRow = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < middleItems.length; i++) ...[
              if (i > 0 && gap > 0) sep(false),
              middleItems[i],
            ],
          ],
        );

        final column = <Widget>[
          for (final w in byAlign(SgDockAlign.top)) top(w),
          c.hasBoundedHeight
              ? Expanded(child: middleRow)
              : IntrinsicHeight(child: middleRow),
          for (final w in byAlign(SgDockAlign.bottom)) top(w),
        ];
        return Column(
          key: const ValueKey('sg-dock-conteudo-dock'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < column.length; i++) ...[
              if (i > 0 && gap > 0) sep(true),
              column[i],
            ],
          ],
        );
      },
    );
  }
}
