// SgColorPicker: seletor de cor SOMENTE FLUTTER. Nao existe no React (la se usa o `input type=color` nativo
// do navegador) e nao exige paridade; por isso nao tem contrato gerado (`implements XProps`) e suas props
// ficam em sg_color_picker_props.dart (escritas a mao). Ver docs/DIVERGENCIAS_DO_REACT.md.
//
// Painel com sliders de matiz, saturacao e brilho (SgSlider), previa da cor, campo hex (#RRGGBB) com validacao
// e lista opcional de cores predefinidas. O valor emitido e sempre '#RRGGBB' maiusculo.
// [showSgColorPicker] abre o painel num dialogo e devolve a cor escolhida (null se cancelar), como showDatePicker.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../buttons/sg_button.dart';
import '../../form/sg_form.dart';
import '../../form/sg_rules.dart' show resolveFieldError;
import '../../generated/enums.g.dart' show SgAppearance;
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import '../choice/choice_shared.dart';
import '../choice/sg_slider.dart';

final RegExp _hexRe = RegExp(r'^#?[0-9a-fA-F]{6}$');

/// '#RRGGBB' maiusculo a partir de `#rrggbb` ou `rrggbb`; nulo se o texto nao for uma cor hex completa.
String? sgNormalizeHex(String? value) {
  if (value == null) return null;
  final s = value.trim();
  if (!_hexRe.hasMatch(s)) return null;
  return '#${s.replaceFirst('#', '').toUpperCase()}';
}

/// '#RRGGBB' maiusculo de uma [Color] (o canal alfa e ignorado).
String sgColorToHex(Color c) {
  String two(double v) =>
      (v * 255).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  return '#${two(c.r)}${two(c.g)}${two(c.b)}'.toUpperCase();
}

/// [Color] opaca de um hex valido (`#RRGGBB`); preto se o texto for invalido.
Color sgHexToColor(String hex) {
  final n = sgNormalizeHex(hex);
  if (n == null) return const Color(0xFF000000);
  return Color(0xFF000000 | int.parse(n.substring(1), radix: 16));
}

const Map<String, Map<String, String>> _messages = {
  'pt-BR': {
    'hue': 'Matiz',
    'saturation': 'Saturação',
    'brightness': 'Brilho',
    'hex': 'Cor (#RRGGBB)',
    'invalid': 'Cor inválida; use #RRGGBB',
    'presets': 'Cores predefinidas',
    'preview': 'Prévia da cor',
    'title': 'Escolher cor',
    'ok': 'OK',
    'cancel': 'Cancelar',
  },
  'pt-PT': {
    'hue': 'Matiz',
    'saturation': 'Saturação',
    'brightness': 'Brilho',
    'hex': 'Cor (#RRGGBB)',
    'invalid': 'Cor inválida; use #RRGGBB',
    'presets': 'Cores predefinidas',
    'preview': 'Pré-visualização da cor',
    'title': 'Escolher cor',
    'ok': 'OK',
    'cancel': 'Cancelar',
  },
  'en-US': {
    'hue': 'Hue',
    'saturation': 'Saturation',
    'brightness': 'Brightness',
    'hex': 'Color (#RRGGBB)',
    'invalid': 'Invalid color; use #RRGGBB',
    'presets': 'Preset colors',
    'preview': 'Color preview',
    'title': 'Pick a color',
    'ok': 'OK',
    'cancel': 'Cancel',
  },
  'es': {
    'hue': 'Matiz',
    'saturation': 'Saturación',
    'brightness': 'Brillo',
    'hex': 'Color (#RRGGBB)',
    'invalid': 'Color no válido; use #RRGGBB',
    'presets': 'Colores predefinidos',
    'preview': 'Vista previa del color',
    'title': 'Elegir color',
    'ok': 'OK',
    'cancel': 'Cancelar',
  },
  'fr': {
    'hue': 'Teinte',
    'saturation': 'Saturation',
    'brightness': 'Luminosité',
    'hex': 'Couleur (#RRGGBB)',
    'invalid': 'Couleur invalide ; utilisez #RRGGBB',
    'presets': 'Couleurs prédéfinies',
    'preview': 'Aperçu de la couleur',
    'title': 'Choisir une couleur',
    'ok': 'OK',
    'cancel': 'Annuler',
  },
};

String _msg(BuildContext context, String key) {
  final loc = normalizeComponentsLocale(context.sgI18n.locale);
  return (_messages[loc] ?? _messages['en-US']!)[key]!;
}

/// Como a cor e escolhida: [gradient] (classico: area de saturacao x brilho e barra de matiz em gradiente) ou
/// [sliders] (tres barras: matiz, saturacao e brilho).
enum SgColorPickerMode { gradient, sliders }

/// Seletor de cor (somente Flutter). Controlado quando [value] e informado; senao guarda o proprio estado
/// (comecando em [defaultValue], ou preto). Dentro de formulario: [name] + [control].
class SgColorPicker extends StatefulWidget {
  const SgColorPicker({
    super.key,
    required this.id,
    this.ariaLabel,
    this.control,
    this.defaultValue,
    this.enabled = true,
    this.error,
    this.labelText,
    this.mode = SgColorPickerMode.gradient,
    this.name,
    this.onChange,
    this.presets,
    this.showHex = true,
    this.value,
    this.width,
  });

  /// Identificador unico (base das chaves dos sliders, do campo hex e das cores predefinidas).
  final String id;

  /// Rotulo de acessibilidade do painel.
  final String? ariaLabel;

  /// Controlador do formulario (junto com [name]).
  final SgFormController? control;

  /// Cor inicial '#RRGGBB' quando nao controlado.
  final String? defaultValue;

  /// Padrao `true`; `false` bloqueia sliders, campo hex e cores predefinidas.
  final bool enabled;

  /// Mensagem de erro externa.
  final String? error;

  /// Titulo exibido acima do painel.
  final String? labelText;

  /// Forma de escolher a cor: [SgColorPickerMode.gradient] (padrao, classico) ou [SgColorPickerMode.sliders].
  final SgColorPickerMode mode;

  /// Nome do campo no formulario.
  final String? name;

  /// Recebe a cor '#RRGGBB' maiuscula a cada mudanca valida.
  final ValueChanged<String>? onChange;

  /// Cores predefinidas ('#RRGGBB'); tocar numa delas escolhe a cor.
  final List<String>? presets;

  /// Mostra o campo hex (padrao `true`).
  final bool showHex;

  /// Cor controlada '#RRGGBB'.
  final String? value;

  /// Numero (px) ou texto 'N%'.
  final Object? width;

  @override
  State<SgColorPicker> createState() => _SgColorPickerState();
}

class _SgColorPickerState extends State<SgColorPicker> {
  late HSVColor _hsv;
  late final TextEditingController _hexCtl;
  late final ChoiceFieldBinding _binding = ChoiceFieldBinding(() {
    if (mounted) setState(() {});
  });
  String _lastHex = '';
  bool _hexInvalid = false;

  String get _currentHex => sgColorToHex(_hsv.toColor());

  @override
  void initState() {
    super.initState();
    final start =
        sgNormalizeHex(widget.value) ??
        sgNormalizeHex(widget.defaultValue) ??
        '#000000';
    _hsv = HSVColor.fromColor(sgHexToColor(start));
    _lastHex = _currentHex;
    _hexCtl = TextEditingController(text: _lastHex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bind();
  }

  @override
  void didUpdateWidget(SgColorPicker old) {
    super.didUpdateWidget(old);
    _bind();
  }

  void _bind() => _binding.bind(
    context,
    control: widget.control,
    name: widget.name,
    rules: null,
    initialValue:
        sgNormalizeHex(widget.defaultValue) ??
        sgNormalizeHex(widget.value) ??
        '#000000',
  );

  @override
  void dispose() {
    _binding.dispose();
    _hexCtl.dispose();
    super.dispose();
  }

  /// Cor vinda de fora (formulario ou `value`), se houver.
  String? get _external {
    if (_binding.bound) return sgNormalizeHex('${_binding.value ?? ''}');
    return sgNormalizeHex(widget.value);
  }

  void _commit(HSVColor next) {
    final hex = sgColorToHex(next.toColor());
    if (_binding.bound) {
      _binding.set(hex);
    } else if (widget.value == null) {
      _hsv = next;
    }
    setState(() => _hexInvalid = false);
    widget.onChange?.call(hex);
  }

  void _onHexTyped(String text) {
    final hex = sgNormalizeHex(text);
    if (hex == null) {
      // Invalido (ou incompleto): mostra o erro e NAO emite.
      setState(() => _hexInvalid = text.isNotEmpty);
      return;
    }
    _lastHex = hex;
    _commit(HSVColor.fromColor(sgHexToColor(hex)));
  }

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    // Valor de fora diferente do painel: o painel segue (valor controlado ou formulario).
    final ext = _external;
    if (ext != null && ext != _currentHex) {
      _hsv = HSVColor.fromColor(sgHexToColor(ext));
    }
    final hex = _currentHex;
    if (hex != _lastHex) {
      _lastHex = hex;
      if (sgNormalizeHex(_hexCtl.text) != hex) {
        _hexCtl.value = TextEditingValue(
          text: hex,
          selection: TextSelection.collapsed(offset: hex.length),
        );
      }
      _hexInvalid = false;
    }
    final error = resolveFieldError(w.error, _binding.errorMessage);
    final color = _hsv.toColor();
    // Texto sobre a previa: preto ou branco, o que tiver MAIOR contraste com a cor.
    final lum = color.computeLuminance();
    final onColor = (1.05 / (lum + 0.05)) > ((lum + 0.05) / 0.05)
        ? Colors.white
        : Colors.black;
    final presets = <String>[
      for (final p in w.presets ?? const <String>[])
        if (sgNormalizeHex(p) != null) sgNormalizeHex(p)!,
    ];

    Widget slider(String key, String label, double v, double max, void Function(double) apply) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          SgSlider(
            id: '${w.id}-$key',
            minValue: 0,
            maxValue: max,
            value: v.round(),
            enabled: w.enabled,
            ariaLabel: label,
            onChange: (n) => apply(n.toDouble()),
          ),
        ],
      );
    }

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (w.labelText != null && w.labelText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              w.labelText!,
              key: ValueKey('${w.id}-label'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        Semantics(
          label: _msg(context, 'preview'),
          value: hex,
          child: Container(
            key: ValueKey('${w.id}-preview'),
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: t.border),
            ),
            alignment: Alignment.center,
            child: Text(hex, style: TextStyle(color: onColor)),
          ),
        ),
        const SizedBox(height: 12),
        if (w.mode == SgColorPickerMode.sliders) ...[
          slider(
            'hue',
            _msg(context, 'hue'),
            _hsv.hue,
            360,
            (n) => _commit(_hsv.withHue(n)),
          ),
          slider(
            'saturation',
            _msg(context, 'saturation'),
            _hsv.saturation * 100,
            100,
            (n) => _commit(_hsv.withSaturation(n / 100)),
          ),
          slider(
            'brightness',
            _msg(context, 'brightness'),
            _hsv.value * 100,
            100,
            (n) => _commit(_hsv.withValue(n / 100)),
          ),
        ] else ...[
          _SvArea(
            key: ValueKey('${w.id}-sv'),
            hsv: _hsv,
            enabled: w.enabled,
            label: '${_msg(context, 'saturation')} / ${_msg(context, 'brightness')}',
            onChanged: (sat, val) => _commit(_hsv.withSaturation(sat).withValue(val)),
          ),
          const SizedBox(height: 12),
          _HueBar(
            key: ValueKey('${w.id}-hue'),
            hsv: _hsv,
            enabled: w.enabled,
            label: _msg(context, 'hue'),
            onChanged: (h) => _commit(_hsv.withHue(h)),
          ),
        ],
        if (w.showHex) ...[
          const SizedBox(height: 8),
          TextField(
            key: ValueKey('${w.id}-hex'),
            controller: _hexCtl,
            enabled: w.enabled,
            decoration: InputDecoration(
              isDense: true,
              labelText: _msg(context, 'hex'),
              errorText: _hexInvalid ? _msg(context, 'invalid') : null,
              border: const OutlineInputBorder(),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[#0-9a-fA-F]')),
              LengthLimitingTextInputFormatter(7),
            ],
            onChanged: _onHexTyped,
          ),
        ],
        if (presets.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in presets)
                Semantics(
                  button: true,
                  enabled: w.enabled,
                  selected: p == hex,
                  label: '${_msg(context, 'presets')}: $p',
                  child: InkWell(
                    key: ValueKey('${w.id}-preset-$p'),
                    customBorder: const CircleBorder(),
                    onTap: w.enabled
                        ? () => _commit(HSVColor.fromColor(sgHexToColor(p)))
                        : null,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: sgHexToColor(p),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: p == hex ? t.primary500 : t.border,
                          width: p == hex ? 3 : 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
        choiceErrorText(
          context,
          error,
          fontSize: 12,
          key: ValueKey('${w.id}-error'),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, c) {
        final available = c.maxWidth.isFinite ? c.maxWidth : 320.0;
        final width = choiceDim(w.width, available);
        Widget out = Semantics(
          container: true,
          label: w.ariaLabel,
          child: Opacity(opacity: w.enabled ? 1 : 0.6, child: body),
        );
        out = Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: width ?? (available > 360 ? 360 : available),
            child: out,
          ),
        );
        return out;
      },
    );
  }
}

/// Abre o [SgColorPicker] num dialogo e devolve a cor '#RRGGBB' escolhida, ou `null` se cancelar
/// (botao Cancelar ou toque fora), como `showDatePicker`. [id] e a base das chaves do dialogo
/// (`<id>-dialog`, `<id>-ok`, `<id>-cancel`) e do painel. [title], [okLabel] e [cancelLabel] trocam os textos
/// (por padrao seguem o idioma dos componentes).
Future<String?> showSgColorPicker(
  BuildContext context, {
  String id = 'sg-color-picker',
  String? initialValue,
  List<String>? presets,
  bool showHex = true,
  SgColorPickerMode mode = SgColorPickerMode.gradient,
  String? title,
  String? okLabel,
  String? cancelLabel,
  bool barrierDismissible = true,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => _SgColorPickerDialog(
      id: id,
      initialValue: initialValue,
      presets: presets,
      showHex: showHex,
      mode: mode,
      title: title,
      okLabel: okLabel,
      cancelLabel: cancelLabel,
    ),
  );
}

class _SgColorPickerDialog extends StatefulWidget {
  const _SgColorPickerDialog({
    required this.id,
    this.initialValue,
    this.presets,
    required this.showHex,
    required this.mode,
    this.title,
    this.okLabel,
    this.cancelLabel,
  });

  final String id;
  final String? initialValue;
  final List<String>? presets;
  final bool showHex;
  final SgColorPickerMode mode;
  final String? title;
  final String? okLabel;
  final String? cancelLabel;

  @override
  State<_SgColorPickerDialog> createState() => _SgColorPickerDialogState();
}

class _SgColorPickerDialogState extends State<_SgColorPickerDialog> {
  late String _draft = sgNormalizeHex(widget.initialValue) ?? '#000000';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: ValueKey('${widget.id}-dialog'),
      title: Text(widget.title ?? _msg(context, 'title')),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: SgColorPicker(
            id: widget.id,
            value: _draft,
            presets: widget.presets,
            showHex: widget.showHex,
            mode: widget.mode,
            onChange: (hex) => setState(() => _draft = hex),
          ),
        ),
      ),
      actions: [
        SgButton(
          key: ValueKey('${widget.id}-cancel'),
          appearance: SgAppearance.ghost,
          label: widget.cancelLabel ?? _msg(context, 'cancel'),
          onClick: () => Navigator.of(context).pop(),
        ),
        SgButton(
          key: ValueKey('${widget.id}-ok'),
          label: widget.okLabel ?? _msg(context, 'ok'),
          onClick: () => Navigator.of(context).pop(_draft),
        ),
      ],
    );
  }
}

/// Area em gradiente (saturacao na horizontal, brilho na vertical) com marcador arrastavel; setas ajustam 1% (Shift: 10%).
class _SvArea extends StatelessWidget {
  const _SvArea({
    super.key,
    required this.hsv,
    required this.enabled,
    required this.label,
    required this.onChanged,
  });

  final HSVColor hsv;
  final bool enabled;
  final String label;
  final void Function(double saturation, double value) onChanged;

  @override
  Widget build(BuildContext context) {
    final pure = HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor();
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        const h = 160.0;
        void at(Offset p) => onChanged(
          (p.dx / w).clamp(0.0, 1.0),
          1 - (p.dy / h).clamp(0.0, 1.0),
        );
        KeyEventResult key(FocusNode _, KeyEvent e) {
          if (!enabled || e is KeyUpEvent) return KeyEventResult.ignored;
          final step = HardwareKeyboard.instance.isShiftPressed ? 0.1 : 0.01;
          final k = e.logicalKey;
          if (k == LogicalKeyboardKey.arrowLeft) {
            onChanged((hsv.saturation - step).clamp(0.0, 1.0), hsv.value);
          } else if (k == LogicalKeyboardKey.arrowRight) {
            onChanged((hsv.saturation + step).clamp(0.0, 1.0), hsv.value);
          } else if (k == LogicalKeyboardKey.arrowUp) {
            onChanged(hsv.saturation, (hsv.value + step).clamp(0.0, 1.0));
          } else if (k == LogicalKeyboardKey.arrowDown) {
            onChanged(hsv.saturation, (hsv.value - step).clamp(0.0, 1.0));
          } else {
            return KeyEventResult.ignored;
          }
          return KeyEventResult.handled;
        }

        return Semantics(
          label: label,
          value: '${(hsv.saturation * 100).round()}% / ${(hsv.value * 100).round()}%',
          child: Focus(
            canRequestFocus: enabled,
            onKeyEvent: key,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: enabled ? (d) => at(d.localPosition) : null,
              onPanStart: enabled ? (d) => at(d.localPosition) : null,
              onPanUpdate: enabled ? (d) => at(d.localPosition) : null,
              child: SizedBox(
                width: w,
                height: h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(colors: [Colors.white, pure]),
                        ),
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: hsv.saturation * w - 9,
                      top: (1 - hsv.value) * h - 9,
                      child: IgnorePointer(
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black54)],
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
      },
    );
  }
}

/// Barra de matiz em gradiente (0 a 360) com marcador arrastavel; setas ajustam 1 grau (Shift: 10).
class _HueBar extends StatelessWidget {
  const _HueBar({
    super.key,
    required this.hsv,
    required this.enabled,
    required this.label,
    required this.onChanged,
  });

  final HSVColor hsv;
  final bool enabled;
  final String label;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        const h = 24.0;
        void at(Offset p) => onChanged(((p.dx / w).clamp(0.0, 1.0)) * 360);
        KeyEventResult key(FocusNode _, KeyEvent e) {
          if (!enabled || e is KeyUpEvent) return KeyEventResult.ignored;
          final step = HardwareKeyboard.instance.isShiftPressed ? 10.0 : 1.0;
          final k = e.logicalKey;
          if (k == LogicalKeyboardKey.arrowLeft || k == LogicalKeyboardKey.arrowDown) {
            onChanged((hsv.hue - step).clamp(0.0, 360.0));
          } else if (k == LogicalKeyboardKey.arrowRight || k == LogicalKeyboardKey.arrowUp) {
            onChanged((hsv.hue + step).clamp(0.0, 360.0));
          } else {
            return KeyEventResult.ignored;
          }
          return KeyEventResult.handled;
        }

        return Semantics(
          label: label,
          value: '${hsv.hue.round()}',
          child: Focus(
            canRequestFocus: enabled,
            onKeyEvent: key,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: enabled ? (d) => at(d.localPosition) : null,
              onHorizontalDragStart: enabled ? (d) => at(d.localPosition) : null,
              onHorizontalDragUpdate: enabled ? (d) => at(d.localPosition) : null,
              child: SizedBox(
                width: w,
                height: h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(h / 2),
                          gradient: LinearGradient(
                            colors: [
                              for (var i = 0; i <= 6; i++)
                                HSVColor.fromAHSV(1, i * 60.0, 1, 1).toColor(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: (hsv.hue / 360) * w - h / 2,
                      top: 0,
                      child: IgnorePointer(
                        child: Container(
                          width: h,
                          height: h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor(),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black54)],
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
      },
    );
  }
}
