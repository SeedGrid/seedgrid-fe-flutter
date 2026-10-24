// Porte de SgQRCode (React: src/gadgets/qr-code/SgQRCode.tsx, que usa o QRCodeSVG do qrcode.react).
// A matriz de modulos sai IDENTICA a do React (qr_matrix.dart, porte do gerador qrcodegen) e e desenhada por
// CustomPainter, sem suavizacao (o React usa shape-rendering="crispEdges").
// Diferencas: `imageClassName` e `logoClassName` existem so para cumprir o contrato (ADR 50); `logoSrc` e uma URL
// (rede); para imagens locais use a prop extra `logoImage` (ImageProvider); a caixa de erro em cinza nao pulsa tanto
// quanto o `animate-pulse` do Tailwind (mesma curva e duracao, 1 -> 0.5 -> 1 em 2 s).
import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_qr_code.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'gauge_math.dart';
import 'gauge_painters.dart';
import 'qr_matrix.dart';

/// Medidas do wrapper, como o React as calcula (`Math.round`, `Math.max`, `Math.min`).
class SgQRCodeLayout {
  const SgQRCodeLayout({
    required this.safeSize,
    required this.safeMargin,
    required this.safeLogoSize,
    required this.safeLogoPadding,
  });

  final double safeSize;
  final double safeMargin;
  final double safeLogoSize;
  final double safeLogoPadding;

  /// `safeLogoSize + safeLogoPadding * 2`.
  double get logoContainerSize => safeLogoSize + safeLogoPadding * 2;
}

SgQRCodeLayout sgQrCodeLayout({
  required num size,
  required num margin,
  required num logoPadding,
  num? logoSize,
}) {
  final safeSize = _max(64, jsRound(size));
  final safeMargin = _max(0, jsRound(margin));
  final safeLogoPadding = _max(0, jsRound(logoPadding));
  final raw = jsRound(logoSize ?? safeSize * 0.22);
  final safeLogoSize = _max(18, raw < safeSize ? raw : safeSize);
  return SgQRCodeLayout(
    safeSize: safeSize,
    safeMargin: safeMargin,
    safeLogoSize: safeLogoSize,
    safeLogoPadding: safeLogoPadding,
  );
}

double _max(double a, double b) => a > b ? a : b;

class SgQRCode extends StatefulWidget implements SgQRCodeProps {
  const SgQRCode({
    super.key,
    this.value,
    this.size = 220,
    this.margin = 2,
    this.fgColor = '#000000',
    this.bgColor = '#FFFFFF',
    this.errorCorrectionLevel = SgQRCodeErrorCorrectionLevel.h,
    this.logoSrc,
    this.logoImage,
    this.logoAlt = 'Logo',
    this.logoSize,
    this.logoPadding = 6,
    this.logoBackgroundColor = '#FFFFFF',
    this.logoBorderRadius = 12,
    this.imageClassName,
    this.logoClassName,
    this.emptyFallback,
    this.onGenerateError,
  });

  /// Texto do QR. Vazio ou so espacos: mostra [emptyFallback] (ou nada).
  @override
  final String? value;

  /// Lado em px (minimo 64).
  @override
  final num size;

  /// Margem em modulos (minimo 0).
  @override
  final num margin;

  /// Cor CSS dos modulos (`#rrggbb`, `rgb(...)`, `hsl(var(--token))`).
  @override
  final String fgColor;

  /// Cor CSS do fundo.
  @override
  final String bgColor;
  @override
  final SgQRCodeErrorCorrectionLevel errorCorrectionLevel;

  /// URL da imagem central.
  @override
  final String? logoSrc;

  /// Extra do Flutter: imagem central local ou em memoria (tem precedencia sobre [logoSrc]).
  final ImageProvider? logoImage;
  @override
  final String logoAlt;

  /// Lado da imagem central. Padrao: 22% de [size] (entre 18 e [size]).
  @override
  final num? logoSize;
  @override
  final num logoPadding;

  /// Cor CSS do fundo da imagem central.
  @override
  final String logoBackgroundColor;
  @override
  final num logoBorderRadius;

  /// Sem efeito no Flutter (classe CSS do React).
  @override
  final String? imageClassName;

  /// Sem efeito no Flutter (classe CSS do React).
  @override
  final String? logoClassName;
  @override
  final Widget? emptyFallback;

  /// Chamado quando o texto nao cabe em nenhum QR (o React captura o erro num ErrorBoundary).
  @override
  final void Function(Object error)? onGenerateError;

  @override
  State<SgQRCode> createState() => _SgQRCodeState();
}

class _SgQRCodeState extends State<SgQRCode>
    with SingleTickerProviderStateMixin {
  String? _key;
  QrMatrix? _matrix;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _compute(String text) {
    final key = '$text|${widget.errorCorrectionLevel.value}';
    if (key == _key) return;
    _key = key;
    _matrix = null;
    try {
      _matrix = encodeQrMatrix(text, widget.errorCorrectionLevel);
    } catch (e) {
      // O React avisa depois de renderizar (componentDidCatch): aqui, depois do quadro.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _key == key) widget.onGenerateError?.call(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final text = (w.value ?? '').trim();
    final layout = sgQrCodeLayout(
      size: w.size,
      margin: w.margin,
      logoPadding: w.logoPadding,
      logoSize: w.logoSize,
    );
    final side = layout.safeSize;

    if (text.isEmpty) {
      _key = null;
      if (w.emptyFallback == null) return const SizedBox.shrink();
      return SizedBox(
        width: side,
        height: side,
        child: Center(child: w.emptyFallback),
      );
    }

    _compute(text);

    final fg = resolveGaugeColor(w.fgColor, theme, const Color(0xFF000000));
    final bg = resolveGaugeColor(w.bgColor, theme, const Color(0xFFFFFFFF));
    final Widget code;
    if (_matrix != null) {
      code = CustomPaint(
        size: Size.square(side),
        painter: QrPainter2(
          matrix: _matrix!,
          margin: layout.safeMargin.toInt(),
          fg: fg,
          bg: bg,
        ),
      );
    } else {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
      final muted = theme.color('--muted');
      code = FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0.5).animate(
          CurvedAnimation(parent: _pulse, curve: const Cubic(0.4, 0, 0.6, 1)),
        ),
        child: DecoratedBox(
          key: const ValueKey('sg-qr-erro'),
          decoration: BoxDecoration(
            color: muted.withValues(alpha: muted.a * 0.4),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }
    if (_matrix != null && _pulse.isAnimating) _pulse.stop();

    final hasLogo =
        w.logoImage != null || (w.logoSrc != null && w.logoSrc!.isNotEmpty);
    Widget? logo;
    if (hasLogo) {
      final image = w.logoImage != null
          ? Image(
              image: w.logoImage!,
              width: layout.safeLogoSize,
              height: layout.safeLogoSize,
              fit: BoxFit.contain,
              semanticLabel: w.logoAlt,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            )
          : Image.network(
              w.logoSrc!,
              width: layout.safeLogoSize,
              height: layout.safeLogoSize,
              fit: BoxFit.contain,
              semanticLabel: w.logoAlt,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            );
      logo = Container(
        key: const ValueKey('sg-qr-logo'),
        width: layout.logoContainerSize,
        height: layout.logoContainerSize,
        padding: EdgeInsets.all(layout.safeLogoPadding),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: resolveGaugeColor(
            w.logoBackgroundColor,
            theme,
            const Color(0xFFFFFFFF),
          ),
          borderRadius: BorderRadius.circular(w.logoBorderRadius.toDouble()),
        ),
        child: image,
      );
    }

    return Semantics(
      image: true,
      label: t(i18n, 'components.gadgets.qrcode.title'),
      child: SizedBox(
        width: side,
        height: side,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: code),
            // o logo pode passar do QR (position:absolute no React): sem restricao de tamanho.
            if (logo != null)
              OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: logo,
              ),
          ],
        ),
      ),
    );
  }
}

/// Desenha a matriz sem suavizacao (equivale a `shape-rendering="crispEdges"`): cada modulo ocupa
/// `lado / (modulos + 2 * margem)`.
class QrPainter2 extends CustomPainter {
  const QrPainter2({
    required this.matrix,
    required this.margin,
    required this.fg,
    required this.bg,
  });

  final QrMatrix matrix;
  final int margin;
  final Color fg;
  final Color bg;

  @override
  void paint(Canvas canvas, Size size) {
    final cells = matrix.size + 2 * margin;
    final cell = size.width / cells;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = bg
        ..isAntiAlias = false,
    );
    final path = Path();
    for (var y = 0; y < matrix.size; y++) {
      var x = 0;
      while (x < matrix.size) {
        if (!matrix.modules[y][x]) {
          x++;
          continue;
        }
        final start = x;
        while (x < matrix.size && matrix.modules[y][x]) {
          x++;
        }
        path.addRect(
          Rect.fromLTWH(
            (start + margin) * cell,
            (y + margin) * cell,
            (x - start) * cell,
            cell,
          ),
        );
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = fg
        ..isAntiAlias = false,
    );
  }

  @override
  bool shouldRepaint(QrPainter2 old) =>
      !identical(old.matrix, matrix) ||
      old.margin != margin ||
      old.fg != fg ||
      old.bg != bg;
}
