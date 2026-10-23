// Equivalente do `SeedThemeProvider` + `useSgTheme` do React.
//
// Diferencas deliberadas:
//  - `applyTo` (`html`/`wrapper`) nao existe: nao ha CSS no Flutter. O provider envolve os filhos
//    num [Theme] com o [SgTheme] como extensao.
//  - Persistencia (`persistMode`, `persistenceStrategy`, chaves `sg:theme:*`) nao esta portada:
//    depende do provider de ambiente da tarefa T3.7 do plano.
//  - `setTheme` recebe parametros nomeados; `null` significa "nao mudar" (no React, chave ausente).
//  - O modo resolvido e [Brightness], nao a string "light"/"dark".

import 'package:flutter/material.dart';

import 'sg_theme.dart';
import 'theme_config.dart';
import 'theme_generator.dart';

/// Equivale a `ThemeContextValue`.
class SgThemeContextValue {
  const SgThemeContextValue({
    required this.theme,
    required this.setTheme,
    required this.setMode,
    required this.currentMode,
    required this.currentTheme,
  });

  /// O tema atual (extensao com as variaveis).
  final SgTheme theme;

  /// Variaveis do tema (mesmo mapa de `theme.vars`).
  ThemeVars get vars => theme.vars;

  /// Troca partes da entrada do tema. `mode: auto` volta a seguir o sistema.
  final void Function({
    String? seed,
    SgThemeMode? mode,
    num? radius,
    String? warning,
    String? error,
    String? info,
    String? success,
    Map<String, String>? customVars,
  })
  setTheme;

  /// Troca o modo resolvido (light/dark) sem mexer no resto.
  final void Function(Brightness mode) setMode;

  /// Modo resolvido (nunca "auto").
  final Brightness currentMode;

  /// `seed`, `mode` e `radius` da entrada atual.
  final SeedThemeInput currentTheme;
}

class _SgThemeScope extends InheritedWidget {
  const _SgThemeScope({required this.value, required super.child});

  final SgThemeContextValue value;

  @override
  bool updateShouldNotify(_SgThemeScope old) =>
      !identical(old.value.theme, value.theme) ||
      old.value.currentMode != value.currentMode;
}

/// Equivale a `useSgTheme()`. Lanca [StateError] fora de um [SeedThemeProvider].
SgThemeContextValue useSgTheme(BuildContext context) {
  final scope = context.dependOnInheritedWidgetOfExactType<_SgThemeScope>();
  if (scope == null) {
    throw StateError('useSgTheme must be used within SeedThemeProvider');
  }
  return scope.value;
}

/// Fornece o tema SeedGrid. Equivale ao `SeedThemeProvider` do React.
class SeedThemeProvider extends StatefulWidget {
  const SeedThemeProvider({super.key, this.initialTheme, required this.child});

  /// Padrao: [defaultSeedTheme].
  final SeedThemeInput? initialTheme;
  final Widget child;

  @override
  State<SeedThemeProvider> createState() => _SeedThemeProviderState();
}

class _SeedThemeProviderState extends State<SeedThemeProvider>
    with WidgetsBindingObserver {
  late SeedThemeInput _input;
  late Brightness _mode;

  @override
  void initState() {
    super.initState();
    _input = widget.initialTheme ?? defaultSeedTheme;
    _mode = _resolve(_input.mode);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Brightness _resolve(SgThemeMode? m) => switch (m ?? SgThemeMode.light) {
    SgThemeMode.light => Brightness.light,
    SgThemeMode.dark => Brightness.dark,
    SgThemeMode.auto => getSystemMode(),
  };

  // Acompanha o sistema enquanto a entrada estiver em `auto`.
  @override
  void didChangePlatformBrightness() {
    if (_input.mode == SgThemeMode.auto) {
      setState(() => _mode = getSystemMode());
    }
  }

  void _setTheme({
    String? seed,
    SgThemeMode? mode,
    num? radius,
    String? warning,
    String? error,
    String? info,
    String? success,
    Map<String, String>? customVars,
  }) {
    setState(() {
      _input = _input.copyWith(
        seed: seed,
        mode: mode,
        radius: radius,
        warning: warning,
        error: error,
        info: info,
        success: success,
        customVars: customVars,
      );
      if (mode != null) _mode = _resolve(mode);
    });
  }

  void _setMode(Brightness m) => setState(() => _mode = m);

  @override
  Widget build(BuildContext context) {
    final theme = SgTheme.fromInput(_input, _mode);
    final value = SgThemeContextValue(
      theme: theme,
      setTheme: _setTheme,
      setMode: _setMode,
      currentMode: _mode,
      currentTheme: _input,
    );
    return _SgThemeScope(
      value: value,
      child: Theme(
        data: theme.toThemeData(Theme.of(context)),
        child: widget.child,
      ),
    );
  }
}
