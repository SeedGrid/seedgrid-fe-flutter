// Porte de SgFadeDigit (React: src/digits/fade-digit/SgFadeDigit.tsx): cartao que "apaga" o digito atual
// (fade out de 200 ms), troca o conteudo e "acende" o novo (fade in de 200 ms). Mesmas proporcoes do
// SgFlipDigit (mesmo cartao, divisoria e sombra), para misturar os dois em relogios.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/sg_fade_digit.g.dart';
import 'digit_colors.dart';

/// Duracao de cada fase (saida e entrada), em ms.
const int kFadeDigitMs = 200;

/// Dimensoes do cartao a partir de [fontSize]: largura, altura e raio (iguais as do SgFlipDigit).
({int width, int height, int radius}) fadeDigitCard(num fontSize) => (
  width: (fontSize * 0.88).round(),
  height: (fontSize * 1.38).round(),
  radius: (fontSize * 0.04).round() < 2 ? 2 : (fontSize * 0.04).round(),
);

class SgFadeDigit extends StatefulWidget implements SgFadeDigitProps {
  const SgFadeDigit({
    super.key,
    required this.value,
    this.color = '#edebeb',
    this.backgroundColor = '#333232',
    this.font,
    this.fontSize = 70,
  });

  /// Caractere mostrado. Ao mudar, o atual apaga e o novo acende.
  @override
  final String value;

  /// Cor do digito (texto CSS).
  @override
  final String color;

  /// Cor de fundo do cartao.
  @override
  final String backgroundColor;

  /// Familia da fonte.
  @override
  final String? font;

  /// Tamanho da fonte em pixels; define a escala do cartao.
  @override
  final num fontSize;

  @override
  State<SgFadeDigit> createState() => _SgFadeDigitState();
}

class _SgFadeDigitState extends State<SgFadeDigit> {
  late String _displayValue = widget.value;
  double _opacity = 1;
  Timer? _timer;

  /// Equivale ao `useEffect([value, displayValue])` do React.
  void _sync() {
    _timer?.cancel();
    _timer = null;
    if (widget.value == _displayValue) return;
    _opacity = 0; // fase 1: apaga
    _timer = Timer(const Duration(milliseconds: kFadeDigitMs), () {
      if (!mounted) return;
      setState(() {
        _displayValue = widget.value; // troca com o digito invisivel
        _opacity = 1; // fase 2: acende
      });
      _sync();
    });
  }

  @override
  void didUpdateWidget(SgFadeDigit old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _sync();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final card = fadeDigitCard(w.fontSize);
    final radius = BorderRadius.circular(card.radius.toDouble());
    return Semantics(
      image: true,
      label: _displayValue,
      excludeSemantics: true,
      child: Container(
        width: card.width.toDouble(),
        height: card.height.toDouble(),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: resolveDigitColor(w.backgroundColor, const Color(0xFF333232)),
          borderRadius: radius,
          // 0 .125em .3125em / 0 .02125em .06125em (em = 16 px, a fonte padrao do navegador)
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 0.34),
              blurRadius: 0.98,
            ),
          ],
        ),
        child: Stack(
          children: [
            // divisoria entre as metades
            Positioned(
              left: 0,
              right: 0,
              top: (card.height / 2).round().toDouble(),
              height: 1,
              child: const ColoredBox(color: Color(0x59000000)),
            ),
            // brilho no alto do cartao
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x0BFFFFFF), Color(0x00FFFFFF)],
                    stops: [0, 0.52],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedOpacity(
                key: const ValueKey('sg-fade-opacity'),
                opacity: _opacity,
                duration: const Duration(milliseconds: kFadeDigitMs),
                curve: Curves.ease,
                child: Center(
                  child: Text(
                    _displayValue,
                    key: const ValueKey('sg-fade-text'),
                    style: TextStyle(
                      color: resolveDigitColor(
                        w.color,
                        const Color(0xFFEDEBEB),
                      ),
                      fontSize: w.fontSize.toDouble(),
                      fontFamily: w.font,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
