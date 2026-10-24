// Porte de SgClock (React: src/gadgets/clock/SgClock.tsx). Mesmos nomes de prop, valores e defaults.
// Props herdadas do HTML (`className`, `style`) nao existem (ADR 50). Diferencas (todas em README.md):
//   - fuso: Dart nao tem banco IANA; ver clock_tz.dart (zonas comuns + deslocamentos + registerSgClockTimeZone);
//   - tema por URL nao e portado (ADR 51, D8);
//   - estilos digitais animados (segment, sevenSegment, roller3d, flip, fade, matrix, neon, discard) dependem dos
//     widgets de digitos: o SgClock os desenha por um construtor registrado ([registerSgClockDigitalStyle]);
//     sem construtor registrado cai no estilo `default`.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_clock.g.dart';
import '../../i18n/i18n.dart';
import '../../layout/containers/sg_card.dart';
import '../../theme_access.dart';
import 'clock_digital_styles.dart' show ensureSgClockDigitalStyles;
import 'clock_ops.dart';
import 'clock_locale_data.g.dart';
import 'clock_theme.dart';
import 'clock_tz.dart';
import 'sg_time_provider.dart';

/// `cardProps` do React (`Omit<SgCardProps, 'title' | 'children'>`): subconjunto do [SgCard]. Campo nulo = mantem o
/// padrao do relogio. `className`/`style` nao existem.
class SgClockCardProps {
  const SgClockCardProps({
    this.id,
    this.actions,
    this.bgColor,
    this.bgColorFooter,
    this.bgColorTitle,
    this.cardStyle,
    this.collapseIcon,
    this.collapseIconSize,
    this.collapseToggleAlign,
    this.collapsible,
    this.defaultOpen,
    this.description,
    this.disabled,
    this.dragPersistKey,
    this.draggable,
    this.footer,
    this.header,
    this.leading,
    this.onOpenChange,
    this.open,
    this.size,
    this.trailing,
  });

  final String? id;
  final Widget? actions;
  final String? bgColor;
  final String? bgColorFooter;
  final String? bgColorTitle;
  final SgCardCardStyle? cardStyle;
  final Widget? collapseIcon;
  final num? collapseIconSize;
  final SgCardCollapseToggleAlign? collapseToggleAlign;
  final bool? collapsible;
  final bool? defaultOpen;
  final Widget? description;
  final bool? disabled;
  final String? dragPersistKey;
  final bool? draggable;
  final Widget? footer;
  final Widget? header;
  final Widget? leading;
  final ValueChanged<bool>? onOpenChange;
  final bool? open;
  final SgCardSize? size;
  final Widget? trailing;
}

// ---------------------------------------------------------------- tempo e formatacao (funcoes puras)

/// Hora, minuto e segundo de [utc] no [timezone] (equivale a `getHmsForTimezone`).
({int h, int m, int s}) sgClockHms(DateTime utc, String? timezone) {
  final wall = _wall(utc, timezone);
  return (h: wall.hour, m: wall.minute, s: wall.second);
}

DateTime _wall(DateTime utc, String? timezone) {
  final u = utc.isUtc ? utc : utc.toUtc();
  final off = sgClockOffsetMinutes(timezone, u);
  return u.add(Duration(minutes: off));
}

String _two(int n) => n.toString().padLeft(2, '0');

String _dayPeriodFor(String locale, int hour24) {
  final table =
      kSgClockDayPeriods[locale] ??
      kSgClockDayPeriods[locale.split('-').first] ??
      kSgClockDayPeriods[locale.split('-').first == 'pt' ? 'pt-PT' : 'en-US'] ??
      kSgClockDayPeriods['en-US']!;
  return table[hour24];
}

/// Partes do relogio digital, como o React as monta com `Intl.DateTimeFormat.formatToParts`.
class SgClockDigitalParts {
  const SgClockDigitalParts({
    required this.hour,
    required this.minute,
    required this.second,
    required this.dayPeriod,
    required this.is12h,
    required this.showSeconds,
    required this.size,
  });

  /// Sempre com 2 digitos; em 12h vai de 01 a 12.
  final String hour, minute;

  /// Vazio quando `showSeconds` e falso.
  final String second;

  /// So em 12h (`AM`/`PM`, ou o que o Intl do locale devolve: `da manhã`, `a. m.`).
  final String? dayPeriod;
  final bool is12h, showSeconds;

  /// `size` original do SgClock (`'sm'`, `'md'`, `'lg'` ou numero).
  final Object size;

  /// `HH:MM` ou `HH:MM:SS`.
  String get text => '$hour:$minute${showSeconds ? ':$second' : ''}';

  /// `text` + periodo em maiusculas (usado pelos estilos matrix e neon).
  String get textWithPeriod =>
      is12h && dayPeriod != null ? '$text ${dayPeriod!.toUpperCase()}' : text;

  /// `digitalSizeToNumber` do React: numero = ele mesmo, sm 12, lg 28, md 16.
  double get sizePx => size is num
      ? (size as num).toDouble()
      : (size == 'sm' ? 12 : (size == 'lg' ? 28 : 16));
}

/// Monta as partes do digital para o instante [utc].
SgClockDigitalParts sgClockDigitalParts(
  DateTime utc, {
  String? timezone,
  String locale = 'pt-BR',
  bool is12h = false,
  bool showSeconds = true,
  Object size = 'md',
}) {
  final w = _wall(utc, timezone);
  final h24 = w.hour;
  final hour = is12h ? _two(h24 % 12 == 0 ? 12 : h24 % 12) : _two(h24);
  String? period;
  if (is12h) {
    period = _dayPeriodFor(locale, h24);
    if (period.isEmpty) {
      period = h24 >= 12
          ? 'PM'
          : 'AM'; // mesmo recuo do React quando o Intl nao devolve periodo
    }
  }
  return SgClockDigitalParts(
    hour: hour,
    minute: _two(w.minute),
    second: showSeconds ? _two(w.second) : '',
    dayPeriod: period,
    is12h: is12h,
    showSeconds: showSeconds,
    size: size,
  );
}

/// Angulos dos ponteiros do analogico (graus, sentido horario a partir das 12).
({double hour, double minute, double second}) sgClockAnalogAngles(
  DateTime utc, {
  String? timezone,
  bool smooth = false,
}) {
  final w = _wall(utc, timezone);
  final ms =
      utc.millisecondsSinceEpoch %
      1000; // `getMilliseconds()` do instante (fusos tem minutos inteiros)
  final s = w.second;
  final sec = smooth ? s + ms / 1000 : s.toDouble();
  final m = w.minute;
  final h = w.hour;
  return (
    second: (sec / 60) * 360,
    minute: ((m + sec / 60) / 60) * 360,
    hour: (((h % 12) + m / 60 + sec / 3600) / 12) * 360,
  );
}

// ---------------------------------------------------------------- estilos digitais registrados

/// Desenha o relogio digital de um estilo nao padrao (digitos animados). O corpo do `SgClock` envolve o
/// resultado com o rotulo de acessibilidade.
typedef SgClockDigitalStyleBuilder =
    Widget Function(BuildContext context, SgClockDigitalParts parts);

final Map<SgClockDigitalStyle, SgClockDigitalStyleBuilder> _digitalStyles = {};

/// Liga um estilo digital (`segment`, `sevenSegment`, `roller3d`, `flip`, `fade`, `matrix`, `neon`, `discard`) a
/// um construtor, tipicamente feito com os widgets de digitos.
void registerSgClockDigitalStyle(
  SgClockDigitalStyle style,
  SgClockDigitalStyleBuilder builder,
) => _digitalStyles[style] = builder;

void unregisterSgClockDigitalStyle(SgClockDigitalStyle style) =>
    _digitalStyles.remove(style);

/// Estilos digitais com construtor registrado.
Set<SgClockDigitalStyle> get registeredSgClockDigitalStyles =>
    _digitalStyles.keys.toSet();

// ---------------------------------------------------------------- widget

class SgClock extends StatefulWidget implements SgClockProps {
  const SgClock({
    super.key,
    this.clockStyle = SgClockClockStyle.digital,
    this.size = 'md',
    this.initialServerTime,
    this.timezone,
    this.locale = 'pt-BR',
    this.format = SgClockFormat.v24h,
    this.showSeconds = true,
    this.digitalStyle = SgClockDigitalStyle.defaultValue,
    this.secondHandMode = SgClockSecondHandMode.step,
    this.themeId = 'classic',
    this.theme,
    this.centerOverlay,
    this.cardTitle,
    this.cardProps,
  });

  @override
  final SgClockClockStyle clockStyle;

  /// `'sm'`, `'md'`, `'lg'` ou numero (px).
  @override
  final Object size;
  @override
  final String? initialServerTime;

  /// Nome do fuso (`America/Sao_Paulo`, `UTC`, `+03:00`, `Etc/GMT+3`); nulo = fuso da maquina.
  @override
  final String? timezone;
  @override
  final String locale;
  @override
  final SgClockFormat format;
  @override
  final bool showSeconds;
  @override
  final SgClockDigitalStyle digitalStyle;
  @override
  final SgClockSecondHandMode secondHandMode;
  @override
  final String themeId;

  /// Tema avulso (tem precedencia sobre `themeId`).
  @override
  final SgClockTheme? theme;
  @override
  final Widget? centerOverlay;
  @override
  final Widget? cardTitle;
  @override
  final SgClockCardProps? cardProps;

  @override
  State<SgClock> createState() => _SgClockState();
}

class _SgClockState extends State<SgClock> {
  late final int _seedMs;
  Duration _perfStart = Duration.zero;
  bool _hydrated = false;
  Timer? _timer;
  bool _tzReported = false;

  @override
  void initState() {
    super.initState();
    final parsed = widget.initialServerTime == null
        ? null
        : DateTime.tryParse(widget.initialServerTime!);
    _seedMs = (parsed ?? SgClockEnvironment.now()).millisecondsSinceEpoch;
    _perfStart = SgClockEnvironment.elapsed();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _hydrated = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// `useSecondTick`: sem provider o relogio se redesenha a cada segundo.
  void _ensureTimer(bool needed) {
    if (needed && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!needed && _timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  int _nowMs(SgTimeContextValue? ctx) {
    if (ctx != null) return ctx.nowMs().floor();
    if (!_hydrated) return _seedMs;
    final delta =
        (SgClockEnvironment.elapsed() - _perfStart).inMicroseconds / 1000.0;
    return (_seedMs + delta).floor();
  }

  /// Fuso valido ou, se for uma zona nao suportada, reporta o erro uma vez e usa o fuso da maquina.
  String? _safeZone() {
    final z = widget.timezone;
    try {
      sgClockOffsetMinutes(z, DateTime.now().toUtc());
      return z;
    } on SgClockUnsupportedTimeZoneError catch (e) {
      if (!_tzReported) {
        _tzReported = true;
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: e,
            library: 'seedgrid_components',
            context: ErrorDescription('while resolving the SgClock timezone'),
          ),
        );
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final i18n = useComponentsI18n(context);
    final ctx = useSgTimeContext(context);
    _ensureTimer(ctx == null);
    final zone = _safeZone();
    final utc = DateTime.fromMillisecondsSinceEpoch(_nowMs(ctx), isUtc: true);

    final Widget clockNode = w.clockStyle == SgClockClockStyle.analog
        ? _buildAnalog(context, i18n, utc, zone)
        : _buildDigital(context, i18n, utc, zone);

    final cp = w.cardProps;
    final theme = sgThemeOf(context);
    final surface = theme.vars['--sg-surface'] ?? theme.vars['--sg-bg'];
    final surface2 = theme.vars['--sg-surface-2'] ?? surface;
    final explicitKey = cp?.dragPersistKey?.trim();
    final cardId = cp?.id?.trim();
    final persistKey = explicitKey != null && explicitKey.isNotEmpty
        ? explicitKey
        : (cardId != null && cardId.isNotEmpty
              ? 'sg-clock:$cardId'
              : 'sg-clock');

    final card = SgCard(
      id: cp?.id,
      title: w.cardTitle ?? Text(t(i18n, 'components.gadgets.clock.title')),
      actions: cp?.actions,
      bgColor: cp?.bgColor ?? 'rgb($surface)',
      bgColorFooter: cp?.bgColorFooter,
      bgColorTitle: cp?.bgColorTitle ?? 'rgb($surface2)',
      cardStyle: cp?.cardStyle ?? SgCardCardStyle.outlined,
      collapseIcon: cp?.collapseIcon,
      collapseIconSize: cp?.collapseIconSize ?? 20,
      collapseToggleAlign:
          cp?.collapseToggleAlign ?? SgCardCollapseToggleAlign.right,
      collapsible: cp?.collapsible ?? true,
      defaultOpen: cp?.defaultOpen ?? true,
      description: cp?.description,
      disabled: cp?.disabled ?? false,
      dragPersistKey: persistKey,
      draggable: cp?.draggable ?? true,
      footer: cp?.footer,
      header: cp?.header,
      leading: cp?.leading,
      onOpenChange: cp?.onOpenChange,
      open: cp?.open,
      size: cp?.size ?? SgCardSize.md,
      trailing: cp?.trailing,
      child: clockNode,
    );
    // width: fit-content e max-width: 100% no React.
    return Align(
      alignment: Alignment.topLeft,
      child: IntrinsicWidth(child: card),
    );
  }

  // ------------------------------------------------------------ analogico

  Widget _buildAnalog(
    BuildContext context,
    SgComponentsI18n i18n,
    DateTime utc,
    String? zone,
  ) {
    final w = widget;
    final size = w.size is num
        ? (w.size as num).toDouble()
        : (w.size == 'sm' ? 140.0 : (w.size == 'lg' ? 320.0 : 240.0));
    final dark = sgClockIsDark(context);
    final resolver = useSgClockThemeResolver(context);
    final themeObj =
        w.theme ??
        (resolver != null
            ? resolveTheme(resolver, w.themeId, 'classic')
            : (getTheme(w.themeId) ?? getTheme('classic')));
    final a = sgClockAnalogAngles(
      utc,
      timezone: zone,
      smooth: w.secondHandMode == SgClockSecondHandMode.smooth,
    );

    final handColor = dark
        ? const Color(0xFFE5E5E5)
        : const Color(0xFF262626); // neutral-200 / neutral-800
    const rose = Color(0xFFF43F5E); // rose-500
    final showSeconds = w.showSeconds;

    void hands(Canvas canvas) {
      void rotated(double deg, void Function() draw) {
        canvas.save();
        canvas.translate(50, 50);
        canvas.rotate(sgClockRad(deg));
        canvas.translate(-50, -50);
        draw();
        canvas.restore();
      }

      Paint stroke(Color c, double width) => Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..strokeWidth = width
        ..color = c;
      rotated(
        a.hour,
        () => canvas.drawLine(
          const Offset(50, 50),
          const Offset(50, 28),
          stroke(handColor, 2.6),
        ),
      );
      rotated(
        a.minute,
        () => canvas.drawLine(
          const Offset(50, 50),
          const Offset(50, 18),
          stroke(handColor, 1.7),
        ),
      );
      if (showSeconds) {
        rotated(
          a.second,
          () => canvas.drawLine(
            const Offset(50, 54),
            const Offset(50, 14),
            stroke(rose, 0.9),
          ),
        );
      }
      canvas.drawCircle(const Offset(50, 50), 2.2, Paint()..color = handColor);
      if (showSeconds) {
        canvas.drawCircle(const Offset(50, 50), 1.1, Paint()..color = rose);
      }
    }

    final face = themeObj == null
        ? CustomPaint(
            size: Size.square(size),
            painter: SgClockOpsPainter(ops: const [], dark: dark, extra: hands),
          )
        : SgClockThemeLayer(
            theme: themeObj,
            size: size,
            dark: dark,
            extra: hands,
          );

    return Semantics(
      label: t(i18n, 'components.gadgets.clock.analogAria'),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned.fill(child: face),
            if (w.centerOverlay != null)
              Center(
                child: SizedBox(
                  width: size * 0.3,
                  height: size * 0.3,
                  child: Center(child: w.centerOverlay),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------ digital

  Widget _buildDigital(
    BuildContext context,
    SgComponentsI18n i18n,
    DateTime utc,
    String? zone,
  ) {
    final w = widget;
    final parts = sgClockDigitalParts(
      utc,
      timezone: zone,
      locale: w.locale,
      is12h: w.format == SgClockFormat.v12h,
      showSeconds: w.showSeconds,
      size: w.size,
    );
    final label = t(i18n, 'components.gadgets.clock.digitalAria');
    if (w.digitalStyle != SgClockDigitalStyle.defaultValue) {
      ensureSgClockDigitalStyles(); // registra os 8 estilos que faltam (idempotente)
    }
    final builder = w.digitalStyle == SgClockDigitalStyle.defaultValue
        ? null
        : _digitalStyles[w.digitalStyle];
    if (builder != null) {
      return Semantics(label: label, child: builder(context, parts));
    }

    final size = w.size;
    final fontSize = size is num
        ? size.toDouble()
        : (size == 'sm' ? 14.0 : (size == 'lg' ? 24.0 : 16.0));
    final lineHeight = size is num
        ? 1.0
        : (size == 'sm' ? 20 / 14 : (size == 'lg' ? 32 / 24 : 24 / 16));
    final muted = sgThemeOf(context).vars['--muted-foreground'];
    final mutedColor = muted == null
        ? Theme.of(context).disabledColor
        : sgThemeOf(context).color('--muted-foreground');
    return Semantics(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // `align-top` do periodo
        children: [
          Text(
            parts.text,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: fontSize,
              height: lineHeight,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: DefaultTextStyle.of(context).style.color,
            ),
          ),
          if (parts.is12h &&
              parts.dayPeriod != null &&
              parts.dayPeriod!.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              parts.dayPeriod!,
              style: TextStyle(
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w600,
                color: mutedColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
