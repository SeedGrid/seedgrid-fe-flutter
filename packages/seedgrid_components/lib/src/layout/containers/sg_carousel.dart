// Porte de SgCarousel (React: src/layout/SgCarousel.tsx). Mesmos nomes de prop, valores e defaults.
// Extra do Flutter (mobile-first, o React nao tem): deslizar o dedo troca de slide, e o autoplay pausa
// enquanto o dedo/ponteiro esta sobre o carrossel (no React so o hover pausa).
// `className`/`style` nao existem (ADR 50): a prop de contrato `itemClassName` e ignorada.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_carousel.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'containers_support.dart';

/// `customNavigators` do React: botoes proprios de anterior/proximo.
class SgCarouselNavigators {
  const SgCarouselNavigators({this.prev, this.next});

  final Widget? prev;
  final Widget? next;
}

class SgCarousel extends StatefulWidget implements SgCarouselProps {
  const SgCarousel({
    super.key,
    required this.items,
    this.autoPlay = false,
    this.autoPlayInterval = 3000,
    this.circular = true,
    this.customNavigators,
    this.gap = 16,
    this.height,
    this.id,
    this.itemClassName,
    this.numScroll = 1,
    this.numVisible = 1,
    this.onIndexChange,
    this.orientation = SgCarouselOrientation.horizontal,
    this.showIndicators = true,
    this.showNavigators = true,
    this.width = '100%',
  });

  @override
  final List<Widget> items;
  @override
  final bool autoPlay;

  /// Milissegundos.
  @override
  final num autoPlayInterval;
  @override
  final bool circular;
  @override
  final SgCarouselNavigators? customNavigators;

  /// Espaco entre itens, em px.
  @override
  final num gap;

  /// Numero (px) ou `'Npx'`/`'N%'`. Sem altura, a horizontal tem a altura dos itens; a vertical precisa
  /// de altura (sem ela usa 300, extra do Flutter: o React colapsaria a 0).
  @override
  final Object? height;
  @override
  final String? id;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? itemClassName;
  @override
  final num numScroll;
  @override
  final num numVisible;

  /// Chamado quando o indice ativo muda (nunca na montagem).
  @override
  final ValueChanged<int>? onIndexChange;
  @override
  final SgCarouselOrientation orientation;
  @override
  final bool showIndicators;
  @override
  final bool showNavigators;

  /// Numero (px) ou texto (`'100%'`, `'320px'`).
  @override
  final Object? width;

  @override
  State<SgCarousel> createState() => _SgCarouselState();
}

class _SgCarouselState extends State<SgCarousel> {
  int _active = 0;
  bool _paused = false;
  Timer? _timer;
  int _lastNotified = 0;
  double _drag = 0;
  double _lastStep = -1;
  final ScrollController _ctrl = ScrollController();

  int get _numVisible =>
      widget.numVisible.toInt() < 1 ? 1 : widget.numVisible.toInt();
  int get _numScroll =>
      widget.numScroll.toInt() < 1 ? 1 : widget.numScroll.toInt();
  int get _count => widget.items.length;
  int get _maxStart => (_count - _numVisible).clamp(0, 1 << 30);
  int get _totalPages => _count == 0 ? 0 : _maxStart ~/ _numScroll + 1;
  bool get _horizontal =>
      widget.orientation == SgCarouselOrientation.horizontal;

  @override
  void initState() {
    super.initState();
    _armTimer();
  }

  @override
  void didUpdateWidget(SgCarousel old) {
    super.didUpdateWidget(old);
    // Mantem o indice dentro dos limites quando itens/props mudam.
    final clamped = _active.clamp(0, _maxStart);
    if (clamped != _active) _setActive(clamped);
    _armTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  // O efeito do React recria o intervalo a cada mudanca de indice/pausa: cada slide espera o intervalo inteiro.
  void _armTimer() {
    _timer?.cancel();
    if (widget.autoPlay && !_paused) {
      _timer = Timer.periodic(
        Duration(milliseconds: widget.autoPlayInterval.round()),
        (_) => _next(),
      );
    }
  }

  void _setActive(int next) {
    if (next == _active) return;
    setState(() => _active = next);
    if (_lastNotified != next) {
      _lastNotified = next;
      widget.onIndexChange?.call(next);
    }
    _armTimer();
  }

  void _next() {
    if (_count == 0) return;
    final next = _active + _numScroll;
    _setActive(next > _maxStart ? (widget.circular ? 0 : _maxStart) : next);
  }

  void _prev() {
    if (_count == 0) return;
    final next = _active - _numScroll;
    _setActive(next < 0 ? (widget.circular ? _maxStart : 0) : next);
  }

  void _pause(bool value) {
    if (_paused == value) return;
    _paused = value;
    _armTimer();
  }

  // Anima (ou salta, se o tamanho do item mudou) o scroll interno ate o slide ativo.
  void _syncScroll(double step) {
    final stepChanged = (step - _lastStep).abs() > 0.5;
    _lastStep = step;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_ctrl.hasClients) return;
      final target = (_active * step).clamp(
        0.0,
        _ctrl.position.maxScrollExtent,
      );
      if ((target - _ctrl.offset).abs() <= 0.5) return;
      if (stepChanged) {
        _ctrl.jumpTo(target);
      } else {
        _ctrl.animateTo(
          target,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onSwipe(double distance, double velocity) {
    if (distance.abs() < 40 && velocity.abs() < 300) return;
    final forward = distance < 0 || velocity < -300;
    if (forward) {
      _next();
    } else {
      _prev();
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final p = ContainerPalette(sgThemeOf(context));
    final i18n = useComponentsI18n(context);
    final canPrev = w.circular ? _maxStart > 0 : _active > 0;
    final canNext = w.circular ? _maxStart > 0 : _active < _maxStart;
    final gap = w.gap.toDouble();
    final n = _numVisible;

    return LayoutBuilder(
      builder: (context, c) {
        final boxW =
            resolveDimension(w.width, c.maxWidth) ??
            (c.hasBoundedWidth ? c.maxWidth : 400.0);
        final boxH =
            resolveDimension(w.height, c.maxHeight) ??
            (_horizontal ? null : 300.0);
        final extentMain = _horizontal ? boxW : boxH!;
        final itemExtent = ((extentMain - gap * (n - 1)) / n).clamp(
          0.0,
          double.infinity,
        );
        final step = itemExtent + gap;
        _syncScroll(step);

        final children = [
          for (var i = 0; i < w.items.length; i++)
            SizedBox(
              key: ValueKey('sg-carousel-item-$i'),
              width: _horizontal ? itemExtent : null,
              height: _horizontal ? null : itemExtent,
              child: w.items[i],
            ),
        ];
        // stretch (itens com 100% da altura, como no React) so com altura definida.
        final strip = _horizontal
            ? Row(
                crossAxisAlignment: boxH != null
                    ? CrossAxisAlignment.stretch
                    : CrossAxisAlignment.start,
                spacing: gap,
                children: children,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: gap,
                children: children,
              );

        Widget viewport = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SingleChildScrollView(
            key: const ValueKey('sg-carousel-viewport'),
            controller: _ctrl,
            scrollDirection: _horizontal ? Axis.horizontal : Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            child: strip,
          ),
        );
        if (boxH != null) viewport = SizedBox(height: boxH, child: viewport);
        viewport = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: _horizontal ? (_) => _drag = 0 : null,
          onHorizontalDragUpdate: _horizontal
              ? (d) => _drag += d.delta.dx
              : null,
          onHorizontalDragEnd: _horizontal
              ? (d) => _onSwipe(_drag, d.primaryVelocity ?? 0)
              : null,
          onVerticalDragStart: _horizontal ? null : (_) => _drag = 0,
          onVerticalDragUpdate: _horizontal ? null : (d) => _drag += d.delta.dy,
          onVerticalDragEnd: _horizontal
              ? null
              : (d) => _onSwipe(_drag, d.primaryVelocity ?? 0),
          child: viewport,
        );

        Widget navButton({required bool isPrev}) {
          final disabled = isPrev ? !canPrev : !canNext;
          final custom = isPrev
              ? w.customNavigators?.prev
              : w.customNavigators?.next;
          final icon = _horizontal
              ? (isPrev ? Icons.chevron_left : Icons.chevron_right)
              : (isPrev ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down);
          final Widget visual =
              custom ??
              Material(
                color: p.background.withValues(alpha: 0.9),
                shape: const CircleBorder(),
                elevation: 6,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(icon, size: 24, color: p.foreground),
                ),
              );
          final button = Semantics(
            button: true,
            enabled: !disabled,
            child: Opacity(
              opacity: disabled ? 0.3 : (custom == null ? 0.7 : 1),
              child: InkResponse(
                key: ValueKey(isPrev ? 'sg-carousel-prev' : 'sg-carousel-next'),
                onTap: disabled ? null : (isPrev ? _prev : _next),
                radius: 24,
                child: visual,
              ),
            ),
          );
          if (_horizontal) {
            return Positioned(
              top: 0,
              bottom: 0,
              left: isPrev ? 8 : null,
              right: isPrev ? null : 8,
              child: Center(child: button),
            );
          }
          return Positioned(
            left: 0,
            right: 0,
            top: isPrev ? 0 : null,
            bottom: isPrev ? null : 0,
            child: Center(child: button),
          );
        }

        Widget indicators() {
          final dots = [
            for (var i = 0; i < _totalPages; i++)
              Semantics(
                button: true,
                label: t(i18n, 'components.carousel.goToSlide', {
                  'slide': i + 1,
                }),
                child: GestureDetector(
                  key: ValueKey('sg-carousel-indicator-$i'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _setActive((i * _numScroll).clamp(0, _maxStart)),
                  // area de toque maior que o ponto visivel (mobile-first)
                  child: Padding(
                    padding: _horizontal
                        ? const EdgeInsets.symmetric(vertical: 8)
                        : const EdgeInsets.symmetric(horizontal: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: _horizontal
                          ? (_active ~/ _numScroll == i ? 32.0 : 8.0)
                          : 8,
                      height: _horizontal
                          ? 8
                          : (_active ~/ _numScroll == i ? 32.0 : 8.0),
                      decoration: BoxDecoration(
                        color: _active ~/ _numScroll == i
                            ? p.primary
                            : p.foreground.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
          ];
          final flex = _horizontal
              ? Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: dots)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: dots,
                );
          return _horizontal
              ? Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8,
                  child: Center(child: flex),
                )
              : Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(child: flex),
                );
        }

        return MouseRegion(
          onEnter: (_) => _pause(true),
          onExit: (_) => _pause(false),
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _pause(true),
            onPointerUp: (_) => _pause(false),
            onPointerCancel: (_) => _pause(false),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: boxW,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Vertical: os botoes (40 px, metade fora) e os indicadores ficam FORA do viewport; o React deixa
                    // transbordar, mas no Flutter o toque fora da area do pai nao chega: reserva-se a folga (parcial).
                    _horizontal
                        ? viewport
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                              right: 24,
                            ),
                            child: viewport,
                          ),
                    if (w.showNavigators) ...[
                      navButton(isPrev: true),
                      navButton(isPrev: false),
                    ],
                    if (w.showIndicators) indicators(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
