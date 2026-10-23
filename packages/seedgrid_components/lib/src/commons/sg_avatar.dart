// Porte de SgAvatar e SgAvatarGroup (React: src/commons/SgAvatar.tsx).
// Diferencas (ADR 50): `children` vira `child` (no grupo, `children` e uma lista, como no React);
// `label` e Widget (um `Text` de texto recebe a mesma normalizacao do React: 2 iniciais em
// maiuscula); `src` vira NetworkImage ou `imageProvider`; `aria-label` = semanticLabel; sem
// className/imageClassName. Extras de HTML: onClick, title, semanticLabel, imageProvider.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../generated/enums.g.dart';
import '../generated/sg_avatar.g.dart';
import '../generated/sg_avatar_group.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';
import 'commons_colors.dart';

/// Cores customizadas do avatar (`SgAvatarCustomColors` do React).
class SgAvatarCustomColors {
  const SgAvatarCustomColors({this.bg, this.fg, this.border, this.ring});
  final Color? bg, fg, border, ring;
}

/// Equivale a `resolveAvatarColors` do React.
({Color bg, Color fg, Color border, Color ring}) resolveAvatarColors(
  SgTheme t,
  SgAvatarSeverity severity, [
  SgAvatarCustomColors? custom,
]) {
  final base = severityColors(t, severity.value);
  return (
    bg: custom?.bg ?? base.bg,
    fg: custom?.fg ?? base.fg,
    border: custom?.border ?? base.border,
    ring: custom?.ring ?? base.ring,
  );
}

class _Size {
  const _Size(this.box, this.font, this.icon);
  final double box, font, icon;
}

// size-6/8/10/14/20, text-[11px]/xs/sm/lg/2xl, size-3.5/4/5/7/9
const _sizes = {
  SgAvatarSize.xs: _Size(24, 11, 14),
  SgAvatarSize.sm: _Size(32, 12, 16),
  SgAvatarSize.md: _Size(40, 14, 20),
  SgAvatarSize.lg: _Size(56, 18, 28),
  SgAvatarSize.xl: _Size(80, 24, 36),
};

/// `normalizeLabel` do React: ate 2 letras = maiusculas; 2+ palavras = iniciais das 2 primeiras;
/// senao as 2 primeiras letras.
String normalizeAvatarLabel(String label) {
  final trimmed = label.trim();
  if (trimmed.isEmpty) return '';
  if (trimmed.length <= 2) return trimmed.toUpperCase();
  final words = trimmed
      .split(RegExp(r'\s+'))
      .where((s) => s.isNotEmpty)
      .toList();
  if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
  return trimmed.substring(0, 2).toUpperCase();
}

class SgAvatar extends StatefulWidget implements SgAvatarProps {
  const SgAvatar({
    super.key,
    this.src,
    this.alt,
    this.label,
    this.icon,
    this.fallback,
    this.size = SgAvatarSize.md,
    this.shape = SgAvatarShape.circle,
    this.severity = SgAvatarSeverity.primary,
    this.bordered = true,
    this.disabled = false,
    this.customColors,
    this.imageClassName,
    this.child,
    this.onImageError,
    this.onClick,
    this.title,
    this.semanticLabel,
    this.imageProvider,
  });

  @override
  final String? src;
  @override
  final String? alt;
  @override
  final Widget? label;
  @override
  final Widget? icon;
  @override
  final Widget? fallback;
  @override
  final SgAvatarSize size;
  @override
  final SgAvatarShape shape;
  @override
  final SgAvatarSeverity severity;
  @override
  final bool bordered;
  @override
  final bool disabled;
  @override
  final SgAvatarCustomColors? customColors;

  /// className da imagem (React-only, ADR 50). Ignorado.
  @override
  final String? imageClassName;

  /// `children` no React (tem precedencia sobre imagem, icone e label).
  @override
  final Widget? child;

  /// Chamado quando a imagem falha ao carregar (o avatar cai no icone/label/fallback).
  @override
  final void Function(Object error)? onImageError;

  /// Com `onClick` o avatar e interativo (focavel, cursor de mao), como no React.
  final VoidCallback? onClick;
  final String? title;

  /// `aria-label` no React.
  final String? semanticLabel;

  /// Imagem pronta (ex.: `AssetImage`); tem precedencia sobre [src].
  final ImageProvider? imageProvider;

  @override
  State<SgAvatar> createState() => _SgAvatarState();
}

class _SgAvatarState extends State<SgAvatar> {
  bool _imageFailed = false;
  bool _focused = false;

  @override
  void didUpdateWidget(SgAvatar old) {
    super.didUpdateWidget(old);
    if (old.src != widget.src || old.imageProvider != widget.imageProvider) {
      _imageFailed = false;
    }
  }

  bool _renderable(Widget? w) =>
      w != null &&
      !(w is Text && (w.data ?? '').trim().isEmpty && w.textSpan == null);

  String? _labelString() {
    final l = widget.label;
    return l is Text ? l.data : null;
  }

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final s = _sizes[w.size]!;
    final c = resolveAvatarColors(t, w.severity, w.customColors);
    final i18n = useComponentsI18n(context);

    final provider =
        w.imageProvider ??
        (w.src != null && w.src!.isNotEmpty ? NetworkImage(w.src!) : null);
    final hasChild = _renderable(w.child);
    final showImage = !hasChild && provider != null && !_imageFailed;
    final showIcon = !hasChild && !showImage && _renderable(w.icon);
    final showLabel =
        !hasChild && !showImage && !showIcon && _renderable(w.label);

    final interactive = w.onClick != null;
    final alt = w.alt ?? t_(i18n);
    final ariaLabel = w.semanticLabel ?? _labelString() ?? alt;
    final squareRadius =
        (w.size == SgAvatarSize.xs || w.size == SgAvatarSize.sm) ? 6.0 : 12.0;
    final radius = w.shape == SgAvatarShape.circle ? s.box / 2 : squareRadius;
    final fg = showImage ? Colors.transparent : c.fg;

    Widget content;
    if (hasChild) {
      content = w.child!;
    } else if (showImage) {
      content = Image(
        image: provider,
        fit: BoxFit.cover,
        width: s.box,
        height: s.box,
        semanticLabel: alt,
        errorBuilder: (_, error, _) {
          // marca a falha fora do build (setState durante o build da imagem nao e permitido)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_imageFailed) {
              setState(() => _imageFailed = true);
              w.onImageError?.call(error);
            }
          });
          return const SizedBox.shrink();
        },
      );
    } else if (showIcon) {
      content = SizedBox(
        width: s.icon,
        height: s.icon,
        child: FittedBox(
          child: IconTheme(
            data: IconThemeData(color: c.fg, size: s.icon),
            child: w.icon!,
          ),
        ),
      );
    } else if (showLabel) {
      final text = _labelString();
      content = text != null
          ? Text(normalizeAvatarLabel(text).toUpperCase())
          : w.label!;
    } else {
      content = SizedBox(
        width: s.icon,
        height: s.icon,
        child: FittedBox(
          child: _renderable(w.fallback) ? w.fallback! : const Text('?'),
        ),
      );
    }

    Widget body = Container(
      key: const ValueKey('avatar-box'),
      width: s.box,
      height: s.box,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: showImage ? t.color('--muted') : c.bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: w.bordered ? c.border : Colors.transparent),
        boxShadow: [
          if (interactive && _focused && !w.disabled)
            BoxShadow(color: c.ring, spreadRadius: 2),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: fg,
          fontSize: s.font,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
        child: content,
      ),
    );

    if (interactive) {
      body = MouseRegion(
        cursor: w.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: Focus(
          canRequestFocus: !w.disabled,
          onFocusChange: (f) => setState(() => _focused = f),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: w.disabled ? null : w.onClick,
            child: body,
          ),
        ),
      );
    }
    if (w.disabled) body = Opacity(opacity: 0.55, child: body);
    if (w.title != null) body = Tooltip(message: w.title!, child: body);
    return Semantics(
      label: ariaLabel,
      button: interactive,
      enabled: interactive ? !w.disabled : null,
      image: showImage,
      child: body,
    );
  }

  String t_(SgComponentsI18n i18n) => t(i18n, 'components.avatar.defaultAlt');
}

// ---------------------------------------------------------------- grupo

/// Sobreposicao (px) de `none|sm|md|lg` = `-ml-0/1/2/3` do React.
double _overlapPx(SgAvatarGroupOverlap o) => switch (o) {
  SgAvatarGroupOverlap.none => 0,
  SgAvatarGroupOverlap.sm => 4,
  SgAvatarGroupOverlap.md => 8,
  SgAvatarGroupOverlap.lg => 12,
};

class SgAvatarGroup extends StatelessWidget implements SgAvatarGroupProps {
  const SgAvatarGroup({
    super.key,
    required this.children,
    this.max,
    this.total,
    this.overlap = SgAvatarGroupOverlap.md,
    this.moreSeverity = SgAvatarSeverity.neutral,
    this.moreLabel,
    this.size = SgAvatarSize.md,
    this.shape = SgAvatarShape.circle,
    this.bordered = true,
  });

  /// Os avatares (no React, `children`).
  final List<Widget> children;

  /// O contrato gerado chama o conteudo de `child` (singular, vindo de `children`); aqui e a linha dos avatares.
  @override
  Widget get child => Row(mainAxisSize: MainAxisSize.min, children: children);
  @override
  final num? max;
  @override
  final num? total;
  @override
  final SgAvatarGroupOverlap overlap;
  @override
  final SgAvatarSeverity moreSeverity;

  /// `(remaining) => ReactNode` do React.
  @override
  final Widget Function(int remaining)? moreLabel;
  @override
  final SgAvatarSize size;
  @override
  final SgAvatarShape shape;
  @override
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final normalizedMax = (max != null && max!.isFinite && max! > 0)
        ? max!.floor()
        : null;
    final visibleCount = normalizedMax != null
        ? (normalizedMax < children.length ? normalizedMax : children.length)
        : children.length;
    final visible = children.take(visibleCount).toList();
    final calculatedTotal =
        ((total ?? children.length) < children.length
                ? children.length
                : (total ?? children.length))
            .toInt();
    final hidden = (calculatedTotal - visibleCount) < 0
        ? 0
        : calculatedTotal - visibleCount;

    return _OverlapRow(
      overlap: _overlapPx(overlap),
      children: [
        ...visible,
        if (hidden > 0)
          SgAvatar(
            size: size,
            shape: shape,
            severity: moreSeverity,
            bordered: bordered,
            // `child` (nao `label`): no React a string passa pelo normalizeLabel e e cortada em 2
            // letras, entao o padrao "+18" viraria "+1" (defeito do React, registrado). Aqui vai inteiro.
            child: moreLabel != null ? moreLabel!(hidden) : Text('+$hidden'),
          ),
      ],
    );
  }
}

/// Linha onde cada filho (menos o primeiro) comeca [overlap] px antes do fim do anterior
/// (o `-ml-*` do React; `Row` nao aceita margem negativa).
class _OverlapRow extends MultiChildRenderObjectWidget {
  const _OverlapRow({required this.overlap, required super.children});
  final double overlap;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderOverlapRow(overlap);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderOverlapRow renderObject,
  ) => renderObject.overlap = overlap;
}

class _OverlapParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderOverlapRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _OverlapParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _OverlapParentData> {
  _RenderOverlapRow(this._overlap);

  double _overlap;
  set overlap(double v) {
    if (v == _overlap) return;
    _overlap = v;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _OverlapParentData) {
      child.parentData = _OverlapParentData();
    }
  }

  @override
  void performLayout() {
    var x = 0.0;
    var h = 0.0;
    var child = firstChild;
    var first = true;
    while (child != null) {
      child.layout(
        BoxConstraints(maxHeight: constraints.maxHeight),
        parentUsesSize: true,
      );
      final pd = child.parentData! as _OverlapParentData;
      if (!first) x -= _overlap;
      pd.offset = Offset(x, 0);
      x += child.size.width;
      if (child.size.height > h) h = child.size.height;
      first = false;
      child = pd.nextSibling;
    }
    // centraliza na vertical (items-center)
    child = firstChild;
    while (child != null) {
      final pd = child.parentData! as _OverlapParentData;
      pd.offset = Offset(pd.offset.dx, (h - child.size.height) / 2);
      child = pd.nextSibling;
    }
    size = constraints.constrain(Size(x < 0 ? 0 : x, h));
  }

  @override
  double computeMinIntrinsicWidth(double height) => 0;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    var x = 0.0;
    var h = 0.0;
    var first = true;
    var child = firstChild;
    while (child != null) {
      final s = child.getDryLayout(
        BoxConstraints(maxHeight: constraints.maxHeight),
      );
      if (!first) x -= _overlap;
      x += s.width;
      if (s.height > h) h = s.height;
      first = false;
      child = (child.parentData! as _OverlapParentData).nextSibling;
    }
    return constraints.constrain(Size(x < 0 ? 0 : x, h));
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
