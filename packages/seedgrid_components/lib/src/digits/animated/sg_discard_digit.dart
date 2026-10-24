// Porte de SgDiscardDigit (React: src/digits/discard-digit/SgDiscardDigit.tsx): uma pilha de folhas de papel;
// ao mudar o valor a folha do topo voa para fora (modo `discard`) ou uma folha nova sobe por baixo (modo
// `incoming`). Mesma maquina de estados do React (displayValue, activeDiscard, activeIncoming, efeitos de
// quadro e de limpeza com temporizador de max(120, transitionMs)), mesmos numeros de movimento aleatorio,
// mesmas curvas CSS e perspectiva de 1000px. O `ref` imperativo vira [SgDiscardDigitController].
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_discard_digit.g.dart';
import 'digits_support.dart';

/// Distancia que cada folha aparece abaixo da de cima (a "lombada").
const double kPerLayerY = 3;

/// Deriva horizontal por folha.
const double kPerLayerX = 0;

/// Movimento sorteado de uma folha (o que `createRandomMotion` devolve no React).
class SgDiscardMotion {
  const SgDiscardMotion({
    required this.tx,
    required this.ty,
    required this.rotateZ,
    required this.rotateX,
    required this.scale,
  });

  final double tx;
  final double ty;
  final double rotateZ;
  final double rotateX;
  final double scale;
}

double _round(double v) => (v + 0.5).floorToDouble();

/// `createRandomMotion` do React (mesma ordem de sorteios: lado, tx, ty, rotateZ, rotateX, scale).
SgDiscardMotion sgCreateRandomMotion(double fontSize, math.Random rng) {
  final side = rng.nextDouble() < 0.5 ? -1 : 1;
  final base = math.max(26, _round(fontSize * 0.55));
  return SgDiscardMotion(
    tx: side * (base + _round(rng.nextDouble() * base * 0.55)),
    ty: math.max(
      56,
      _round(fontSize * 1.45 + rng.nextDouble() * fontSize * 0.55),
    ),
    rotateZ: side * (8 + _round(rng.nextDouble() * 12)),
    rotateX: -(10 + _round(rng.nextDouble() * 16)),
    scale: 0.68 + rng.nextDouble() * 0.14,
  );
}

/// Medidas do conjunto (iguais as do React).
class SgDiscardMetrics {
  SgDiscardMetrics({required double fontSize, required int depth}) {
    cardW = math.max(74, _round(fontSize * 1.14));
    cardH = math.max(96, _round(fontSize * 1.52));
    radius = math.max(8, _round(fontSize * 0.15));
    textSize = math.max(18, _round(fontSize * 0.86));
    numStack = depth - 1;
    containerW = cardW + pad * 2 + (numStack * kPerLayerX).ceilToDouble();
    containerH = cardH + numStack * kPerLayerY + pad * 2;
    cardLeft = ((containerW - cardW) / 2).floorToDouble();
  }

  static const double pad = 10;

  late final double cardW;
  late final double cardH;
  late final double radius;
  late final double textSize;
  late final int numStack;
  late final double containerW;
  late final double containerH;
  late final double cardLeft;
}

/// Profundidade da pilha: `totalNumberPages` manda; senao `stackDepth` (2 a 30).
int sgDiscardDepth({
  required int currentPage,
  num? totalNumberPages,
  num stackDepth = 20,
}) {
  if (totalNumberPages != null) {
    return math.max(
      1,
      math.min(30, totalNumberPages.toInt() - currentPage + 1),
    );
  }
  return math.max(2, math.min(30, stackDepth.toInt()));
}

/// Equivale ao `ref` (`SgDiscardDigitHandle`) do React.
class SgDiscardDigitController {
  _SgDiscardDigitState? _state;

  /// Decrementa a pagina atual (minimo 1) e faz a proxima troca de valor entrar por baixo.
  void decreasePage() => _state?._decrease();

  /// Incrementa a pagina atual (maximo `totalNumberPages`, se definido).
  void increasePage() => _state?._increase();

  /// Pagina atual (comeca em 1).
  int page() => _state?._currentPage ?? 1;
}

class SgDiscardDigit extends StatefulWidget implements SgDiscardDigitProps {
  const SgDiscardDigit({
    super.key,
    required this.value,
    this.color = '#0f172a',
    this.font,
    this.backgroundColor = '#f8fafc',
    this.fontSize = 64,
    this.fontWeight = 700,
    this.animateOnChange = true,
    this.transitionMs = 640,
    this.stackDepth = 20,
    this.totalNumberPages,
    this.changeAnimationMode = SgDiscardDigitChangeAnimationMode.discard,
    this.controller,
    this.random,
  });

  /// Texto da folha do topo.
  @override
  final String value;

  /// Cor do texto (CSS em texto: `#rgb`, `#rrggbb`, `rgb()`).
  @override
  final String color;

  /// `font-family` do texto.
  @override
  final String? font;

  /// Cor de fundo das folhas.
  @override
  final String backgroundColor;

  /// Tamanho da fonte em px (escala do conjunto). Padrao do codigo React: 64 (o meta diz 72).
  @override
  final num fontSize;

  /// Peso: numero ou texto ('bold', '600').
  @override
  final Object fontWeight;

  /// Anima quando o valor muda.
  @override
  final bool animateOnChange;

  /// Duracao total em ms.
  @override
  final num transitionMs;

  /// Folhas visiveis na pilha (2 a 30); ignorado se [totalNumberPages] existir.
  @override
  final num stackDepth;

  /// Total de paginas do monte; a pilha encolhe a cada `increasePage()`.
  @override
  final num? totalNumberPages;

  /// Estrategia de animacao para mudancas por `value`.
  @override
  final SgDiscardDigitChangeAnimationMode changeAnimationMode;

  /// Equivale ao `ref` do React.
  final SgDiscardDigitController? controller;

  /// Fonte de numeros aleatorios (extra, para teste). Padrao: `Random()`.
  final math.Random? random;

  @override
  State<SgDiscardDigit> createState() => _SgDiscardDigitState();
}

enum _Direction { next, prev }

class _Active {
  _Active(this.id, this.value, this.motion);
  final int id;
  final String value;
  final SgDiscardMotion motion;
  bool started = false;
}

class _SgDiscardDigitState extends State<SgDiscardDigit>
    with TickerProviderStateMixin {
  int _currentPage = 1;
  _Direction _direction = _Direction.next;
  late String _displayValue = widget.value;
  _Active? _activeDiscard;
  _Active? _activeIncoming;
  int _idSeq = 0;
  late final math.Random _rng = widget.random ?? math.Random();

  AnimationController? _discardCtl;
  AnimationController? _incomingCtl;
  Timer? _discardTimer;
  Timer? _incomingTimer;

  Duration get _duration => Duration(milliseconds: widget.transitionMs.round());
  Duration get _cleanupDelay =>
      Duration(milliseconds: math.max(120, widget.transitionMs.round()));

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  @override
  void didUpdateWidget(SgDiscardDigit old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      if (old.controller?._state == this) old.controller!._state = null;
      widget.controller?._state = this;
    }
    // O `useEffect` do React roda a cada render com deps (value, animateOnChange, mode, fontSize...).
    _effect();
  }

  @override
  void dispose() {
    if (widget.controller?._state == this) widget.controller!._state = null;
    _discardTimer?.cancel();
    _incomingTimer?.cancel();
    _discardCtl?.dispose();
    _incomingCtl?.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ controller

  void _decrease() {
    setState(() {
      _direction = _Direction.prev;
      _currentPage = math.max(1, _currentPage - 1);
    });
  }

  void _increase() {
    setState(() {
      _direction = _Direction.next;
      final total = widget.totalNumberPages;
      _currentPage = total != null
          ? math.min(total.toInt(), _currentPage + 1)
          : _currentPage + 1;
    });
  }

  // ------------------------------------------------------------------ efeito principal (porte do useEffect)

  /// Devolve se mudou algum estado que exige novo render.
  void _effect() {
    if (!widget.animateOnChange) {
      _activeDiscard = null;
      _activeIncoming = null;
      _discardTimer?.cancel();
      _incomingTimer?.cancel();
      _displayValue = widget.value;
      return;
    }
    if (widget.value == _displayValue &&
        _activeDiscard == null &&
        _activeIncoming == null) {
      return;
    }

    final useIncoming =
        _direction == _Direction.prev ||
        widget.changeAnimationMode ==
            SgDiscardDigitChangeAnimationMode.incoming;

    if (useIncoming) {
      // A folha nova sobe por baixo; displayValue so muda no fim da animacao.
      if (_activeIncoming == null && widget.value != _displayValue) {
        _activeIncoming = _Active(
          ++_idSeq,
          widget.value,
          sgCreateRandomMotion(widget.fontSize.toDouble(), _rng),
        );
        _scheduleStart(_activeIncoming!, incoming: true);
      }
    } else {
      // A folha atual voa para fora, revelando o valor novo.
      if (_activeIncoming == null) {
        if (_activeDiscard == null) {
          _activeDiscard = _Active(
            ++_idSeq,
            _displayValue,
            sgCreateRandomMotion(widget.fontSize.toDouble(), _rng),
          );
          _scheduleStart(_activeDiscard!, incoming: false);
        }
        _displayValue = widget.value;
      }
    }
    _direction = _Direction.next;
  }

  /// "RAF": no proximo quadro a folha vira `started` e o controlador anima.
  void _scheduleStart(_Active a, {required bool incoming}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = incoming ? _activeIncoming : _activeDiscard;
      if (current == null || current.id != a.id || current.started) return;
      current.started = true;
      final ctl = AnimationController(vsync: this, duration: _duration);
      if (incoming) {
        _incomingCtl?.dispose();
        _incomingCtl = ctl;
      } else {
        _discardCtl?.dispose();
        _discardCtl = ctl;
      }
      ctl.addListener(() {
        if (mounted) setState(() {});
      });
      ctl.forward();

      // Limpeza: depois de max(120, transitionMs) a folha some e o valor final aparece.
      final timer = Timer(_cleanupDelay, () {
        if (!mounted) return;
        setState(() {
          if (incoming) {
            if (_activeIncoming?.id == a.id) _activeIncoming = null;
            _displayValue = widget.value;
          } else {
            if (_activeDiscard?.id == a.id) _activeDiscard = null;
            if (_displayValue != widget.value) _displayValue = widget.value;
          }
          _effect();
        });
      });
      if (incoming) {
        _incomingTimer?.cancel();
        _incomingTimer = timer;
      } else {
        _discardTimer?.cancel();
        _discardTimer = timer;
      }
      setState(() {});
    });
  }

  // ------------------------------------------------------------------ pintura

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final fs = w.fontSize.toDouble();
    final depth = sgDiscardDepth(
      currentPage: _currentPage,
      totalNumberPages: w.totalNumberPages,
      stackDepth: w.stackDepth,
    );
    final m = SgDiscardMetrics(fontSize: fs, depth: depth);
    final bg = parseCssColor(w.backgroundColor) ?? const Color(0xFFF8FAFC);
    final fg = parseCssColor(w.color) ?? const Color(0xFF0F172A);
    final weight = parseFontWeight(w.fontWeight);

    const edgeSoft = Color(0x290F172A); // rgba(15,23,42,.16)
    const edgeMid = Color(0x420F172A); // rgba(15,23,42,.26)
    const subtle = Color(0x1F020817); // rgba(2,8,23,.12)

    // Folhas de fundo: i=0 e a de baixo (mais deslocada, z menor).
    final layers = <Widget>[
      for (var i = 0; i < m.numStack; i++)
        () {
          final dist = m.numStack - i;
          return Positioned(
            key: ValueKey('discard-sheet-$i'),
            top: SgDiscardMetrics.pad + dist * kPerLayerY,
            left: m.cardLeft + dist * kPerLayerX,
            width: m.cardW,
            height: m.cardH,
            child: Opacity(
              opacity: math.max(0.80, 1 - (dist - 1) * 0.007),
              // O Flutter nao aceita raio com bordas de cores diferentes: borda uniforme e a de baixo
              // (um pouco mais forte, para cada faixa de 3px ler como borda de folha) vira uma linha.
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(m.radius),
                  border: Border.all(color: edgeSoft),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(m.radius),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 1,
                      width: double.infinity,
                      child: ColoredBox(color: edgeMid),
                    ),
                  ),
                ),
              ),
            ),
          );
        }(),
    ];

    Widget paper({
      required Widget child,
      required List<BoxShadow> shadows,
      required Color border,
      double glossStrong = 0,
    }) {
      return Container(
        width: m.cardW,
        height: m.cardH,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(m.radius),
          border: Border.all(color: border),
          boxShadow: shadows,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(-0.6, -1),
                    end: const Alignment(0.6, 1),
                    colors: [
                      Color.fromRGBO(255, 255, 255, 0.55 + glossStrong),
                      Color.fromRGBO(255, 255, 255, 0.12 + glossStrong * 0.4),
                      const Color(0x00FFFFFF),
                    ],
                    stops: const [0, 0.28, 0.55],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0x05000000),
                      Color.fromRGBO(0, 0, 0, 0.09 + glossStrong * 0.5),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: CustomPaint(painter: _PaperTexturePainter()),
            ),
            // inset 0 1px 0 rgba(255,255,255,.80)
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 1,
              child: ColoredBox(color: Color(0xCCFFFFFF)),
            ),
            child,
          ],
        ),
      );
    }

    Widget digit(String text) => Text(
      text,
      softWrap: false,
      style: TextStyle(
        color: fg,
        fontFamily: w.font,
        fontSize: m.textSize,
        fontWeight: weight,
        height: 1,
        shadows: const [
          Shadow(color: Color(0x73FFFFFF), offset: Offset(0, 1)),
          Shadow(
            color: Color(0x1A020817),
            offset: Offset(0, 10),
            blurRadius: 16,
          ),
        ],
      ),
    );

    // Folha de cima.
    final main = Positioned(
      key: const ValueKey('discard-main'),
      top: SgDiscardMetrics.pad,
      left: m.cardLeft,
      child: paper(
        border: edgeSoft,
        shadows: [
          const BoxShadow(color: subtle, offset: Offset(0, 8), blurRadius: 16),
          const BoxShadow(color: Color(0x38FFFFFF), spreadRadius: 1),
        ],
        child: digit(_displayValue),
      ),
    );

    final groundShadow = _ground(m);

    final children = <Widget>[
      groundShadow,
      ...layers,
      main,
      if (_activeIncoming != null) _incomingCard(m, paper, digit),
      if (_activeDiscard != null) _discardCard(m, paper, digit),
    ];
    return Semantics(
      label: w.value,
      image: true,
      child: ExcludeSemantics(
        // role=img do React: o rotulo e o valor; o conteudo visual (texto das folhas) nao e lido de novo.
        child: SizedBox(
          key: const ValueKey('discard-root'),
          width: m.containerW,
          height: m.containerH,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, -1 / 1000), // perspective: 1000px
            child: Stack(clipBehavior: Clip.none, children: children),
          ),
        ),
      ),
    );
  }

  Widget _ground(SgDiscardMetrics m) {
    final gw = _round(m.cardW * 0.88);
    final double gh = math.max<double>(14, _round(m.cardH * 0.12));
    return Positioned(
      key: const ValueKey('discard-ground'),
      left: m.containerW / 2 - gw / 2,
      top: SgDiscardMetrics.pad + m.cardH + m.numStack * kPerLayerY + 2,
      width: gw,
      height: gh,
      child: ImageFiltered(
        imageFilter: _blur8,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Color(0x4D020817), Color(0x0D020817), Color(0x00020817)],
              stops: [0, 0.7, 1],
            ),
          ),
        ),
      ),
    );
  }

  Matrix4 _motionMatrix(
    SgDiscardMotion mo,
    double t, {
    required bool toMotion,
    required Offset origin,
  }) {
    // toMotion: identidade (z 80) -> movimento (z 74); senao movimento -> identidade.
    final from = toMotion ? _Pose.rest : _Pose.of(mo);
    final to = toMotion ? _Pose.of(mo) : _Pose.rest;
    final p = _Pose.lerp(from, to, t);
    return Matrix4.identity()
      ..translateByDouble(origin.dx, origin.dy, 0, 1)
      ..translateByDouble(p.tx, p.ty, p.z, 1)
      ..rotateX(p.rotateX * math.pi / 180)
      ..rotateZ(p.rotateZ * math.pi / 180)
      ..scaleByDouble(p.scale, p.scale, 1, 1)
      ..translateByDouble(-origin.dx, -origin.dy, 0, 1);
  }

  Widget _discardCard(
    SgDiscardMetrics m,
    Widget Function({
      required Widget child,
      required List<BoxShadow> shadows,
      required Color border,
      double glossStrong,
    })
    paper,
    Widget Function(String) digit,
  ) {
    final a = _activeDiscard!;
    final ctl = _discardCtl;
    final raw = a.started && ctl != null ? ctl.value : 0.0;
    final tTransform = kDiscardCurve.transform(raw);
    final tOpacity = kCssEase.transform(raw);
    final tShadow = kCssEase.transform(math.min(1, raw / 0.65));
    final opacity = 1 - tOpacity;
    final shadows = BoxShadow.lerpList(
      const [
        BoxShadow(
          color: Color(0x47020817),
          offset: Offset(0, 16),
          blurRadius: 22,
        ),
        BoxShadow(
          color: Color(0x2E020817),
          offset: Offset(0, 30),
          blurRadius: 30,
        ),
        BoxShadow(color: Color(0x42FFFFFF), spreadRadius: 1),
      ],
      const [
        BoxShadow(
          color: Color(0x47020817),
          offset: Offset(0, 7),
          blurRadius: 15,
        ),
        BoxShadow(
          color: Color(0x24020817),
          offset: Offset(0, 22),
          blurRadius: 26,
        ),
      ],
      tShadow,
    )!;
    return Positioned(
      key: ValueKey('discard-flying-${a.id}'),
      top: SgDiscardMetrics.pad,
      left: m.cardLeft,
      child: Opacity(
        opacity: opacity.clamp(0, 1),
        child: Transform(
          transform: _motionMatrix(
            a.motion,
            tTransform,
            toMotion: true,
            origin: Offset(m.cardW * 0.5, m.cardH * 0.2),
          ),
          child: paper(
            border: const Color(0x420F172A),
            shadows: shadows,
            glossStrong: 0.07,
            child: digit(a.value),
          ),
        ),
      ),
    );
  }

  Widget _incomingCard(
    SgDiscardMetrics m,
    Widget Function({
      required Widget child,
      required List<BoxShadow> shadows,
      required Color border,
      double glossStrong,
    })
    paper,
    Widget Function(String) digit,
  ) {
    final a = _activeIncoming!;
    final ctl = _incomingCtl;
    final raw = a.started && ctl != null ? ctl.value : 0.0;
    final tTransform = kIncomingCurve.transform(raw);
    final tOpacity = kCssEase.transform(math.min(1, raw / 0.6));
    return Positioned(
      key: ValueKey('discard-incoming-${a.id}'),
      top: SgDiscardMetrics.pad,
      left: m.cardLeft,
      child: Opacity(
        opacity: tOpacity.clamp(0, 1),
        child: Transform(
          transform: _motionMatrix(
            a.motion,
            tTransform,
            toMotion: false,
            origin: Offset(m.cardW * 0.5, m.cardH * 0.8),
          ),
          child: paper(
            border: const Color(0x420F172A),
            shadows: const [
              BoxShadow(
                color: Color(0x47020817),
                offset: Offset(0, 16),
                blurRadius: 22,
              ),
              BoxShadow(
                color: Color(0x2E020817),
                offset: Offset(0, 30),
                blurRadius: 30,
              ),
              BoxShadow(color: Color(0x42FFFFFF), spreadRadius: 1),
            ],
            glossStrong: 0.07,
            child: digit(a.value),
          ),
        ),
      ),
    );
  }
}

final _blur8 = ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8); // CSS blur(8px)

/// Pose de uma folha: o que o CSS `translate3d(tx, ty, z) rotateX rotateZ scale` interpola.
class _Pose {
  const _Pose(this.tx, this.ty, this.z, this.rotateX, this.rotateZ, this.scale);

  /// translate3d(0, 0, 80px) rotateX(0) rotateZ(0) scale(1).
  static const rest = _Pose(0, 0, 80, 0, 0, 1);

  /// translate3d(tx, ty, 74px) rotateX() rotateZ() scale(): a folha deslocada.
  factory _Pose.of(SgDiscardMotion m) =>
      _Pose(m.tx, m.ty, 74, m.rotateX, m.rotateZ, m.scale);

  final double tx, ty, z, rotateX, rotateZ, scale;

  static _Pose lerp(_Pose a, _Pose b, double t) => _Pose(
    a.tx + (b.tx - a.tx) * t,
    a.ty + (b.ty - a.ty) * t,
    a.z + (b.z - a.z) * t,
    a.rotateX + (b.rotateX - a.rotateX) * t,
    a.rotateZ + (b.rotateZ - a.rotateZ) * t,
    a.scale + (b.scale - a.scale) * t,
  );
}

/// `repeating-linear-gradient(0deg, rgba(15,23,42,.025) 0 1px, transparent 1px 4px)`: linhas finas a cada 4px.
class _PaperTexturePainter extends CustomPainter {
  const _PaperTexturePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x060F172A);
    // 0deg = de baixo para cima: a primeira faixa de 1px encosta na borda de baixo.
    for (var y = size.height; y > 0; y -= 4) {
      canvas.drawRect(Rect.fromLTWH(0, y - 1, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(_PaperTexturePainter old) => false;
}
