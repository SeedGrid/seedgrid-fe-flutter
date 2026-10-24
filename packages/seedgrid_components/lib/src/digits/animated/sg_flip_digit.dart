// Porte de SgFlipDigit (React: src/digits/flip-digit/SgFlipDigit.tsx, que usa @pqina/flip 1.8.4).
// SEM a biblioteca (ela mexe no DOM): o motor do flip (flip_engine.dart) e a transformacao 3D
// (Matrix4 com perspectiva de 4em e rotateX) reproduzem o `tick.view.flip`: 800 ms, ease-out-bounce,
// sombras e a ordem das cartas. As cores sao as do CSS da biblioteca (#333232 / #edebeb), que nao usa
// tokens do tema. `width` e `height` existem no contrato, mas o React tambem os ignora (obsoletos).
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../generated/sg_flip_digit.g.dart';
import 'flip_engine.dart';

const Color _panelBg = Color(0xFF333232);
const Color _panelFg = Color(0xFFEDEBEB);

class SgFlipDigit extends StatefulWidget implements SgFlipDigitProps {
  const SgFlipDigit({
    super.key,
    required this.value,
    this.fontSize = 70,
    this.width,
    this.height,
  });

  /// O caractere exibido (um so).
  @override
  final String value;

  /// Tamanho da fonte em px: controla a escala do digito inteiro.
  @override
  final num fontSize;

  /// Obsoleto (o React tambem ignora): use [fontSize].
  @override
  final num? width;

  /// Obsoleto (o React tambem ignora): use [fontSize].
  @override
  final num? height;

  @override
  State<SgFlipDigit> createState() => SgFlipDigitState();
}

/// Estado publico para testes: expoe o motor e o relogio do flip.
class SgFlipDigitState extends State<SgFlipDigit>
    with SingleTickerProviderStateMixin {
  final SgFlipEngine engine = SgFlipEngine();
  late final Ticker _ticker = createTicker(_onTick);
  double _clock = 0;
  double _tickerBase = 0;

  @override
  void initState() {
    super.initState();
    engine.addListener(_rebuild);
    _draw(widget.value);
  }

  @override
  void didUpdateWidget(SgFlipDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _draw(widget.value);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _draw(String v) {
    // `_clock` e o relogio do ticker: avanca por quadro; o instante do `draw` usa o ultimo valor.
    engine.setValue(v, _clock);
    if (engine.animating) _startTicker();
  }

  void _startTicker() {
    if (_ticker.isActive) return;
    _tickerBase = _clock;
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    _clock = _tickerBase + elapsed.inMicroseconds / 1000;
    if (!engine.tick(_clock)) _ticker.stop();
  }

  @override
  void dispose() {
    _ticker.dispose();
    engine.removeListener(_rebuild);
    engine.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ medidas (em relacao a fontSize)

  double get _fs => widget.fontSize.toDouble();
  double get _lineH => _fs * 1.4;
  double get _indent => _fs * 0.25;
  double get _margin => _fs * 0.0625;

  /// Largura do cartao: max(1.125em, recuo + texto com letter-spacing de 0.25em).
  ///
  /// Medir texto custa caro e isto roda a cada quadro da animacao: o resultado fica em cache e so e
  /// refeito quando o texto, o tamanho ou o estilo da fonte mudam.
  String? _widthKey;
  double _widthCache = 0;

  double _cardWidth(BuildContext context) {
    final style = _textStyle(context);
    final text = engine.value ?? widget.value;
    final key = '$text|$_fs|${style.fontFamily}|${style.fontWeight}';
    if (_widthKey != key) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      _widthCache = math.max(_fs * 1.125, _indent + tp.width);
      _widthKey = key;
    }
    return _widthCache;
  }

  TextStyle _textStyle(BuildContext context) => TextStyle(
    fontSize: _fs,
    height: 1.4,
    letterSpacing: _fs * 0.25,
    color: _panelFg,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final w = _cardWidth(context);
    final h = _lineH;
    final radius = Radius.circular(_fs * 0.125);

    // Ordem de pintura: cartas mais novas primeiro (embaixo); z-index maior depois.
    final ordered = engine.cards.reversed.toList();
    final painted = [
      ...ordered.where((c) => c.zIndex == null),
      ...(ordered.where((c) => c.zIndex != null).toList()
        ..sort((a, b) => a.zIndex!.compareTo(b.zIndex!))),
    ];

    return ExcludeSemantics(
      // O React marca o digito como aria-hidden.
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _margin),
        child: SizedBox(
          key: const ValueKey('flip-digit'),
          width: w,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Sombra da pilha (tick-flip-card-shadow): left/right .15em, bottom .125em, altura .5em.
              Positioned(
                key: const ValueKey('flip-stack-shadow'),
                left: _fs * 0.15,
                right: _fs * 0.15,
                bottom: _fs * 0.125,
                height: _fs * 0.5,
                child: Opacity(
                  opacity: engine.stackShadow.clamp(0, 1),
                  child: Transform(
                    alignment: Alignment.bottomLeft,
                    transform: Matrix4.diagonal3Values(
                      1,
                      engine.stackShadow.clamp(0, 1),
                      1,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x80000000),
                            offset: Offset(0, _fs * 0.125),
                            blurRadius: _fs * 0.25,
                          ),
                          BoxShadow(
                            color: const Color(0xBF000000),
                            offset: Offset(0, _fs * 0.125),
                            blurRadius: _fs * 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Sombra estatica do cartao (tick-flip-shadow).
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(radius),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x40000000),
                        offset: Offset(0, _fs * 0.125),
                        blurRadius: _fs * 0.3125,
                      ),
                      BoxShadow(
                        color: const Color(0x40000000),
                        offset: Offset(0, _fs * 0.02125),
                        blurRadius: _fs * 0.06125,
                      ),
                    ],
                  ),
                ),
              ),
              for (final c in painted)
                Positioned.fill(
                  key: ObjectKey(c),
                  child: _FlipCardView(
                    card: c,
                    fontSize: _fs,
                    width: w,
                    height: h,
                    radius: radius,
                    textStyle: _textStyle(context),
                    indent: _indent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlipCardView extends StatelessWidget {
  const _FlipCardView({
    required this.card,
    required this.fontSize,
    required this.width,
    required this.height,
    required this.radius,
    required this.textStyle,
    required this.indent,
  });

  final SgFlipCard card;
  final double fontSize;
  final double width;
  final double height;
  final Radius radius;
  final TextStyle textStyle;
  final double indent;

  Widget _glyph(String? text) => SizedBox(
    width: width,
    height: height,
    child: Center(
      child: Padding(
        padding: EdgeInsets.only(left: indent),
        child: Text(text ?? '', style: textStyle, softWrap: false),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final a = card.rotation; // graus; frente: a, verso: -180 + a
    final frontVisible = a > -90;
    final backVisible = a < -90;
    final panelH = height * 0.51;

    // perspective: 4em no cartao (origem no centro).
    final perspective = Matrix4.identity()..setEntry(3, 2, -1 / (4 * fontSize));

    final front = Positioned(
      left: 0,
      top: 0,
      width: width,
      height: panelH,
      child: Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.rotationX(a * math.pi / 180),
        child: Visibility(
          visible: frontVisible,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: DecoratedBox(
            key: const ValueKey('flip-front'),
            decoration: BoxDecoration(
              color: _panelBg,
              borderRadius: BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(left: 0, top: 0, child: _glyph(card.front)),
                // linha de luz do topo: inset 0 1px rgba(255,255,255,.05)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 1,
                  child: const ColoredBox(color: Color(0x0DFFFFFF)),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: card.shadowFront.clamp(0, 1),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xCC000000), Color(0x4D000000)],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final back = Positioned(
      left: 0,
      top: height * 0.5,
      width: width,
      height: panelH,
      child: Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.rotationX((-180 + a) * math.pi / 180),
        child: Visibility(
          visible: backVisible,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: DecoratedBox(
            key: const ValueKey('flip-back'),
            decoration: BoxDecoration(
              color: _panelBg,
              borderRadius: BorderRadius.only(
                bottomLeft: radius,
                bottomRight: radius,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // O texto do verso mostra a metade de baixo: a caixa do glifo sobe 51% da altura.
                Positioned(left: 0, top: -panelH, child: _glyph(card.back)),
                // :after - gradiente escuro no topo do verso.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Color(0x4D000000),
                          Color(0x26000000),
                          Color(0x00000000),
                        ],
                        stops: [0, 1 / panelH, 0.3],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: card.shadowBack.clamp(0, 1),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xB3000000), Color(0x80000000)],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: card.highlightBack.clamp(0, 1),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x26FFFFFF), Color(0x4DFFFFFF)],
                        ),
                      ),
                    ),
                  ),
                ),
                // inset 0 -1px rgba(0,0,0,.1)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 1,
                  child: const ColoredBox(color: Color(0x1A000000)),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Frente por cima do verso quando visivel; so uma das duas aparece por vez.
    return Transform(
      alignment: Alignment.center,
      transform: perspective,
      child: Stack(clipBehavior: Clip.none, children: [back, front]),
    );
  }
}
