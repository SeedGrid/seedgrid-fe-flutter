// Tema SeedGrid como `ThemeExtension`. No React o tema e um mapa de variaveis CSS
// (`--sg-btn-primary-bg`); aqui o mesmo mapa vive em [SgTheme.vars], com os MESMOS nomes, e os
// tokens `--sg-*` ganham getters tipados (sg_theme_tokens.g.dart):
//   `--sg-btn-primary-bg`  ->  theme.btnPrimaryBg   (tira "--sg-" e vira camelCase)
//   `--sg-primary-600`     ->  theme.primary600
// Tokens legados (`--background`, `--primary`...) so saem por `theme.color('--background')`.

import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'component_tokens.dart';
import 'theme_config.dart';
import 'theme_generator.dart';

class SgTheme extends ThemeExtension<SgTheme> {
  const SgTheme({required this.vars, required this.mode});

  /// Gera o tema do mesmo jeito que o `SeedThemeProvider` do React: variaveis base + tokens de
  /// componente (os de componente vencem em caso de nome repetido).
  factory SgTheme.fromInput(SeedThemeInput input, Brightness mode) {
    final base = generateThemeVars(input, mode);
    return SgTheme(
      vars: {...base, ...generateComponentTokens(base)},
      mode: mode,
    );
  }

  /// Equivale a `vars` do `ThemeContextValue`.
  final ThemeVars vars;

  /// `light` ou `dark` (o React chama de `currentMode`; nunca "auto" aqui).
  final Brightness mode;

  /// Texto cru do token. Lanca [StateError] se nao existir.
  String value(String name) {
    final v = vars[name];
    if (v == null) throw StateError('Token de tema inexistente: $name');
    return v;
  }

  /// Cor de um token pelo nome CSS (`'--sg-primary-600'`). Entende `r g b`, `rgb(r g b)`,
  /// `transparent` e o `H S% L%` dos aliases legados.
  Color color(String name) => parseThemeColor(value(name));

  /// `--sg-radius` em px.
  double get radius => double.parse(value('--sg-radius').replaceAll('px', ''));

  @override
  SgTheme copyWith({ThemeVars? vars, Brightness? mode}) =>
      SgTheme(vars: vars ?? this.vars, mode: mode ?? this.mode);

  /// Nao interpola: muda de uma vez na metade da transicao. As variaveis sao texto, e interpolar
  /// ~200 tokens a cada quadro nao compensa.
  @override
  SgTheme lerp(ThemeExtension<SgTheme>? other, double t) =>
      other is SgTheme && t >= 0.5 ? other : this;

  /// `ThemeData` Material coerente com o tema SeedGrid (cores principais), com [SgTheme] registrado
  /// como extensao. Os widgets SeedGrid leem os tokens da extensao.
  ThemeData toThemeData([ThemeData? base]) {
    final scheme = ColorScheme(
      brightness: mode,
      primary: color('--sg-primary-500'),
      onPrimary: color('--sg-on-primary'),
      secondary: color('--sg-secondary-500'),
      onSecondary: color('--sg-on-secondary'),
      error: color('--sg-error-500'),
      onError: color('--sg-on-error'),
      surface: color('--sg-surface'),
      onSurface: color('--sg-text'),
      // Os papeis que nao tem token proprio ficariam no padrao do tema claro do Material (texto preto e
      // superficies claras no escuro): chips, caixas de codigo e textos de apoio ficavam ilegiveis.
      onSurfaceVariant: color('--sg-muted'),
      outline: color('--sg-border'),
      outlineVariant: color('--sg-border'),
      surfaceContainerLowest: color('--sg-bg'),
      surfaceContainerLow: color('--sg-surface'),
      surfaceContainer: color('--sg-surface'),
      surfaceContainerHigh: color('--sg-muted-surface'),
      surfaceContainerHighest: color('--sg-muted-surface'),
    );
    final b = base ?? ThemeData(useMaterial3: true);
    // O ThemeData de fabrica guarda varias cores ja resolvidas para o modo claro (texto, icones, canvas, card,
    // dialogo...). Refaz esses campos a partir do esquema do modo atual: o Material sem cor propria (chips,
    // por exemplo) pinta com `canvasColor` e ficava branco no escuro, com texto claro por cima.
    final onSurface = scheme.onSurface;
    final fresh = ThemeData(useMaterial3: b.useMaterial3, colorScheme: scheme);
    return b.copyWith(
      brightness: mode,
      colorScheme: scheme,
      canvasColor: fresh.canvasColor,
      cardColor: fresh.cardColor,
      disabledColor: fresh.disabledColor,
      hintColor: fresh.hintColor,
      hoverColor: fresh.hoverColor,
      focusColor: fresh.focusColor,
      highlightColor: fresh.highlightColor,
      iconTheme: fresh.iconTheme,
      primaryIconTheme: fresh.primaryIconTheme,
      chipTheme: fresh.chipTheme,
      textTheme: b.textTheme.apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      primaryTextTheme: b.primaryTextTheme.apply(
        bodyColor: scheme.onPrimary,
        displayColor: scheme.onPrimary,
      ),
      scaffoldBackgroundColor: color('--sg-bg'),
      dividerColor: color('--sg-border'),
      extensions: [...b.extensions.values.where((e) => e is! SgTheme), this],
    );
  }
}

final RegExp _rgbFn = RegExp(r'^rgb\(\s*(\d+)\s+(\d+)\s+(\d+)\s*\)$');
final RegExp _rgbTriplet = RegExp(r'^(\d+)\s+(\d+)\s+(\d+)$');
final RegExp _hslTriplet = RegExp(
  r'^(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)%\s+(\d+(?:\.\d+)?)%$',
);

/// Converte o texto de um token em [Color]. Lanca [FormatException] para formato desconhecido.
Color parseThemeColor(String text) {
  final t = text.trim();
  if (t == 'transparent') return const Color(0x00000000);
  var m = _rgbFn.firstMatch(t) ?? _rgbTriplet.firstMatch(t);
  if (m != null) {
    return Color.fromARGB(
      255,
      int.parse(m[1]!),
      int.parse(m[2]!),
      int.parse(m[3]!),
    );
  }
  m = _hslTriplet.firstMatch(t);
  if (m != null) {
    return HSLColor.fromAHSL(
      1,
      double.parse(m[1]!),
      double.parse(m[2]!) / 100,
      double.parse(m[3]!) / 100,
    ).toColor();
  }
  throw FormatException('Valor de token nao e cor: $text');
}

/// Atalho: a mesma conversao que `hexToRgb` faz para texto `#RRGGBB`, devolvendo [Color].
Color colorFromHex(String hex) {
  final c = hexToRgb(hex);
  return Color.fromARGB(255, c.r, c.g, c.b);
}
