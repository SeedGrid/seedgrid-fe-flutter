import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

/// Tema SeedGrid do contexto: o `SgTheme` registrado no `ThemeData` (por `SeedThemeProvider` ou
/// `SgTheme.toThemeData`). Sem ele, gera o tema padrao do React para o brilho atual, igual ao
/// React sem `SeedThemeProvider` (que cai nos valores padrao).
SgTheme sgThemeOf(BuildContext context) {
  final theme = Theme.of(context);
  return theme.extension<SgTheme>() ??
      SgTheme.fromInput(defaultSeedTheme, theme.brightness);
}
