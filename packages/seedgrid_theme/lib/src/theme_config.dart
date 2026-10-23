// Porte de @seedgrid/fe-theme src/theme/ThemeConfig.ts (somente o caminho `SeedThemeInput`).
//
// Nao portado de proposito:
//  - `persistMode` e `persistenceStrategy`: dependem da persistencia de `@seedgrid/fe-core`
//    (SgEnvironmentProvider), que entra na tarefa T3.7 do plano.
//  - `SeedGridThemeConfig`, `defaultTheme`, `ThemeProvider`, `useTheme` e `AppShell`: caminho
//    legado, marcado `@deprecated` no React, que escreve variaveis CSS (`hsl`, `--sg-sidebar`).

/// `Mode` do React: `"light" | "dark" | "auto"`.
enum SgThemeMode { light, dark, auto }

/// `SeedThemeInput` do React. Campos opcionais continuam opcionais.
class SeedThemeInput {
  const SeedThemeInput({
    required this.seed,
    this.mode,
    this.radius,
    this.warning,
    this.error,
    this.info,
    this.success,
    this.customVars,
  });

  /// `"#RRGGBB"`.
  final String seed;

  /// Padrao do React: `light`.
  final SgThemeMode? mode;

  /// Em px. Padrao do React: 12.
  final num? radius;

  /// Cores semanticas diretas (hex). Quando ausentes, saem de matizes fixos.
  final String? warning;
  final String? error;
  final String? info;
  final String? success;

  /// Variaveis completas para forcar (substituem as geradas).
  final Map<String, String>? customVars;

  SeedThemeInput copyWith({
    String? seed,
    SgThemeMode? mode,
    num? radius,
    String? warning,
    String? error,
    String? info,
    String? success,
    Map<String, String>? customVars,
  }) => SeedThemeInput(
    seed: seed ?? this.seed,
    mode: mode ?? this.mode,
    radius: radius ?? this.radius,
    warning: warning ?? this.warning,
    error: error ?? this.error,
    info: info ?? this.info,
    success: success ?? this.success,
    customVars: customVars ?? this.customVars,
  );
}

/// `defaultSeedTheme` do React (sem `persistMode`).
const SeedThemeInput defaultSeedTheme = SeedThemeInput(
  seed: '#16803D', // Verde SeedGrid
  mode: SgThemeMode.light,
  radius: 12,
);

/// `ThemeVars` do React: nome da variavel CSS (`--sg-primary-600`) para o valor em texto.
typedef ThemeVars = Map<String, String>;
